import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../app.dart';
import '../../core/db/local_db.dart';
import '../../core/enums/activity_mode.dart';
import '../../core/enums/location_permission_state.dart';
import '../../core/enums/location_state.dart';
import '../../core/enums/tracking_state.dart';
import '../../core/formatter/time_formatter.dart';
import '../../core/network/device_connection.dart';
import '../../core/utils/dialog/w_dialog.dart';

class TrackingProvider extends ChangeNotifier {
  final Distance _distance;
  final Location _location;
  final DeviceConnection _connection;
  final Db _db;

  TrackingProvider({
    required Distance distance,
    required Location location,
    required DeviceConnection connection,
    required Db db,
  })  : _distance = distance,
        _location = location,
        _connection = connection,
        _db = db;

  late MapController _mapController;
  MapController get mapController => _mapController;

  final _panelController = PanelController();
  PanelController get panelController => _panelController;

  StreamSubscription<LocationData>? _locationListener;
  StreamSubscription<List<ConnectivityResult>>? _connectionListener;
  StreamSubscription? _gpsListener;

  bool _isConnectionDialogShowing = false;
  bool _isCheatDialogShowing = false;
  bool _isInternetActive = false;
  bool _isGPSActive = true;

  bool get isShowAlertDialog {
    final isShow = _db.hasData('_is_show_alert_dialog_key_');
    return (isShow == false);
  }

  Timer? _timer;
  int _seconds = 0;

  Duration get duration => Duration(seconds: _seconds);

  DateTime get currentDate => DateTime.now();

  String get stringTimer => TimeFormat.formatTimer(_seconds);
  String get stringDuration => TimeFormat.formatDuration(duration);

  LocationData? _position;
  LocationData? get position => _position;

  LocationData? _currentPosition;
  LocationData? get currentPosition => _currentPosition;

  double _mileage = 0.0;
  double get mileage => _mileage;

  double _speed = 0.0;
  double get speed => _speed;

  int _step = 0;
  int get step => _step;

  List<LatLng> _coordinates = [];
  List<LatLng> get coordinates => _coordinates;

  var _activityMode = ActivityMode.Berjalan;
  ActivityMode get activityMode => _activityMode;

  var _permissionState = LocationPermissionState.INIT;
  LocationPermissionState get permissionState => _permissionState;

  var _getLocationState = GetLocationState.LOADING;
  GetLocationState get getLocationState => _getLocationState;

  var _trackingState = TrackingState.INIT;
  TrackingState get trackingState => _trackingState;

  String? _permissionMessage;
  String? get permissionMessage => _permissionMessage;

  String? _getLocationMessage;
  String? get getLocationMessage => _getLocationMessage;

  String? _trackingMessage;
  String? get trackingMessage => _trackingMessage;

  //* get activity id
  int getActivityId() {
    switch (_activityMode) {
      case ActivityMode.Berjalan:
        return 1;
      case ActivityMode.Berlari:
        return 3;
    }
  }

  //* select activity mode
  void selecActivitytMode(ActivityMode mode) {
    _activityMode = mode;
    notifyListeners();
  }

  //* init map controller
  void initMapController(MapController controller) {
    _mapController = controller;
  }

  //* open panel
  void openPanel() async {
    if (_panelController.isPanelClosed) {
      await _panelController.open();
      return;
    }
  }

  //* close panel
  void closePanel() async {
    if (_panelController.isPanelOpen) {
      await _panelController.close();
      return;
    }
  }

  //* panel toggle
  void panelToggle() async {
    if (_panelController.isPanelClosed) {
      await _panelController.open();
      return;
    }
    if (_panelController.isPanelOpen) {
      await _panelController.close();
      return;
    }
  }

  //* calculate step
  void calculateStep() {
    double estimateStep;
    switch (_activityMode) {
      case ActivityMode.Berjalan:
        // estimasi langkah
        estimateStep = 1.38; //m
        break;
      case ActivityMode.Berlari:
        // estimasi langkah
        estimateStep = 0.95; //m
        break;
    }
    _step = (_mileage * estimateStep).toInt();
    notifyListeners();
  }

  //* move camera
  void moveCamera() {
    final zoom = _mapController.camera.zoom;
    _mapController.move(_coordinates.last, zoom);
  }

  //* start timer
  void _startTimer() {
    if (_trackingState == TrackingState.TRACK) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
      notifyListeners();
    });
    // logger
    log('Timer dimulai');
  }

  //* pause timer
  void _pauseTimer() {
    if (_trackingState == TrackingState.PAUSE) return;
    _timer!.cancel();
    // logger
    log("Timer dipause");
  }

  //* resume timer
  void _resumeTimer() {
    if (_trackingState == TrackingState.TRACK) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
      notifyListeners();
    });
    // logger
    log("Timer dilanjutkan");
  }

  //* stop timer
  void _stopTimer() {
    if (_trackingState == TrackingState.STOP) return;
    _timer!.cancel();

    // logger
    log("Timer distop");
  }

  //* set key activity alert dialog to db
  void setKeyActivityAlertDialog() async {
    await _db.set('_is_show_alert_dialog_key_', 'save');
  }

  //* start listen internet connection (internet & gps)
  void _startListenServiceConnection() {
    // logger
    log('mulai memantau service internet / gps');

    _connectionListener = _connection.connectionStream.listen((connections) {
      _isInternetActive = connections.contains(ConnectivityResult.wifi) ||
          connections.contains(ConnectivityResult.mobile) ||
          connections.contains(ConnectivityResult.vpn) ||
          connections.contains(ConnectivityResult.ethernet);
      _updateTrackingStatus();
    });

    // setiap 3 detik sekali akan melakukan cek apakah gps aktif atau mati
    _gpsListener = Stream.periodic(const Duration(seconds: 3))
        .asyncMap((_) => _location.serviceEnabled())
        .distinct() // handle event duplikat
        .listen((isGpsEnabled) {
      _isGPSActive = isGpsEnabled;
      _updateTrackingStatus();
    });
  }

  //* update tracking status when location service is available
  void _updateTrackingStatus() {
    // jika internet dan GPS keduanya aktif, resume tracking
    if (_isInternetActive && _isGPSActive) {
      // action
      resumeTracking();
      _hideNoConnectionDialog();

      // logger
      log('Internet dan GPS aktif, melanjutkan tracking',
          name: 'TRACKING STATUS');
    } else {
      // jika salah satu atau keduanya mati, pause tracking
      pauseTracking();
      _showNoConnectionDialog();

      // logger
      if (!_isInternetActive) {
        log('Koneksi internet mati', name: 'INTERNET STATUS');
      }
      if (!_isGPSActive) {
        log('GPS mati', name: 'GPS STATUS');
      }
    }
  }

  //* show no connection & gps dialog
  void _showNoConnectionDialog() {
    final context = navigatorKey.currentContext!;

    if (_isConnectionDialogShowing) return;
    _isConnectionDialogShowing = true;

    WDialog.showDialog(
      context,
      canPop: false,
      dismissible: false,
      icon: const Icon(Icons.signal_wifi_connected_no_internet_4_rounded),
      title: 'Aktivitas terjeda',
      message:
          'Aktivitas kamu terjeda karena layanan GPS atau koneksi internet mati. Segera periksa koneksi untuk melanjutkan aktivitas.',
    );
  }

  //* hide no connection & gps dialog
  void _hideNoConnectionDialog() {
    if (_isConnectionDialogShowing) {
      Navigator.of(navigatorKey.currentContext!).pop();
      _isConnectionDialogShowing = false;
    }
  }

  //* stop listen internet connection
  void _stopListenServiceConnection() {
    _connectionListener!.cancel();
    _gpsListener!.cancel();

    // logger
    log('memantau koneksi internet & gps distop');
  }

  //* show cheat dialog
  void _showCheatDialog() async {
    pauseTracking();
    _stopListenServiceConnection();

    final context = navigatorKey.currentContext!;

    if (_isCheatDialogShowing) return;
    _isCheatDialogShowing = true;

    WDialog.showDialog(
      context,
      dismissible: false,
      canPop: false,
      icon: const Icon(Icons.warning_amber, color: Colors.red),
      title: 'Terdeteksi Kecurangan',
      message:
          'Kecepatan Kamu melebihi batas wajar untuk seorang pelari. Kami mendeteksi adanya aktivitas yang tidak valid. Untuk menjaga keakuratan data, aktivitas Kamu akan dihentikan.',
      actions: [
        DialogAction(
          label: 'Mengerti',
          color: Colors.red,
          isDefaultAction: true,
          onPressed: () async {
            _isCheatDialogShowing = false;
            await stopTracking();
            resetTrackingData();
            if (context.mounted) {
              Navigator.of(context).pop(); // tutup dialog
              Navigator.of(context).pop(); // keluar halaman
            }
          },
        ),
      ],
    );
  }

  //* cek GPS
  Future<bool> _isGPSEnabled() async {
    bool serviceEnabled;

    // Cek apakah layanan lokasi (GPS) aktif
    serviceEnabled = await _location.serviceEnabled();

    if (!serviceEnabled) {
      // Jika tidak aktif, minta user untuk mengaktifkan GPS
      serviceEnabled = await _location.requestService();

      // Berikan feedback ke user jika GPS masih belum aktif
      if (!serviceEnabled) {
        _permissionMessage =
            'Harap hidupkan layanan lokasi atau GPS di perangkat Kamu';
        notifyListeners();
        log('Layanan lokasi / GPS tidak aktif');
        return false;
      }
    }

    // Jika layanan GPS aktif
    return true;
  }

  //* Cek izin lokasi
  Future<bool> _devicePermission() async {
    PermissionStatus permission;

    // Pastikan GPS aktif terlebih dahulu
    bool gpsEnabled = await _isGPSEnabled();
    if (!gpsEnabled) return false;

    // Cek izin lokasi
    permission = await _location.hasPermission();

    // Jika izin lokasi ditolak
    if (permission == PermissionStatus.denied) {
      // Request izin lokasi jika ditolak
      log('Request permission location');
      permission = await _location.requestPermission();

      // Jika izin masih ditolak setelah permintaan
      if (permission != PermissionStatus.granted) {
        _permissionState = LocationPermissionState.DENIED;
        _permissionMessage =
            'Izin akses lokasi ditolak. Buka pengaturan untuk mengaktifkan layanan lokasi';
        notifyListeners();
        return false;
      }
    }

    // Jika izin diberikan
    _permissionState = LocationPermissionState.ALLOWED;
    _permissionMessage = null;
    notifyListeners();

    return true;
  }

  //* get current location
  Future<void> getCurrentLocation() async {
    // logger
    log('Mulai mendapatkan lokasi terkini');

    // set location to loading
    _getLocationState = GetLocationState.LOADING;
    notifyListeners();

    log('state: ${_getLocationState.name}', name: 'GET LOCATION STATE');

    // Memeriksa izin terlebih dahulu
    // Jika izin tidak diberikan, jangan lanjutkan
    bool permissionGranted = await _devicePermission();
    if (!permissionGranted) return;

    // Mendapatkan lokasi saat ini
    try {
      final position = await _location.getLocation();

      // set data & state
      _currentPosition = position;
      _getLocationMessage = null;
      _getLocationState = GetLocationState.SUCCESS;
      notifyListeners();

      // logger
      log('Lokasi ditemukan ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');
      log('Akurasi GPS saat lokasi didapatkan: ${position.accuracy}');
      log('state: ${_getLocationState.name}', name: 'GET LOCATION STATE');
    } catch (e) {
      // handle error
      // next code ->

      // set error state & message
      _getLocationMessage = 'Gagal mendapatkan lokasi: ${e.toString()}';
      _getLocationState = GetLocationState.FAILURE;
      notifyListeners();

      // logger
      log('Gagal mendapatkan lokasi: ${e.toString()}');
      log('state: ${_getLocationState.name}', name: 'GET LOCATION STATE');
    }
  }

  //* Enable Background Mode
  Future<void> _enableBackgroundMode(bool enable) async {
    try {
      await _location.enableBackgroundMode(enable: enable);
      bool isEnabled = await _location.isBackgroundModeEnabled();

      // logger
      log('Background Mode Enabled: $isEnabled');
    } catch (e) {
      // handle error
      // next code ->

      // logger
      log('Gagal mengubah mode latar belakang: ${e.toString()}');
    }
  }

  //* start tracking
  Future<void> startTracking() async {
    // logger
    log('Mulai melakukan tracking');

    // set loading state
    _trackingState = TrackingState.LOADING;
    notifyListeners();

    // logger
    log('state: ${_trackingState.name}', name: 'TRACKING STATE');

    // aktifkan layanan latar belakang
    await _enableBackgroundMode(true);

    // setting map interval & distance filter
    // aplikasi akan memperbaharui lokasi setelah berjarak 5 meter
    await _location.changeSettings(
      distanceFilter: 10,
      interval: 1000,
      accuracy: LocationAccuracy.high,
    );

    await _location.changeNotificationOptions();

    // start listen location
    _locationListener = _location.onLocationChanged.listen(
      (position) {
        if (position.latitude != null && position.longitude != null) {
          final newPoint = LatLng(position.latitude!, position.longitude!);
          final lastPoint = _coordinates.isNotEmpty ? _coordinates.last : null;

          // set data
          _position = position;
          // nilai speed yang ditampung harus dalam satuan km/h
          // sedangkan satuan speed bawaan dari object position adalah m/s
          // rumus untuk mengkonversi m/s ke km/h adalah: km/h = m/s * 3.6
          _speed = ((position.speed ?? 0.0) * 3.6);
          notifyListeners();

          // logger
          log('Kecepatan tracking in km/h : $_speed');
          log('Akurasi GPS : ${position.accuracy} m');

          // action
          _calculateDistance(lastPoint, newPoint);

          // handle kecurangan
          if (_speed > 21) {
            _showCheatDialog();
          }
        } else {
          // logger
          log('Nilai koordinat lat long null');
        }
      },
      onError: (e) {
        // handle error
        // next code ->

        // set error state & message
        _trackingState = TrackingState.FAILURE;
        _trackingMessage =
            'Terjadi kesalahan saat melakukan Aktifitas : ${e.toString()}';
        notifyListeners();

        // logger
        log('Terjadi kesalahan saat melakukan Tracking : ${e.toString()}');
        log('state: ${_trackingState.name}', name: 'TRACKING STATE');
      },
    );

    // start timer
    _startTimer();

    // listen gps & internet connection
    _startListenServiceConnection();

    // set state
    _trackingState = TrackingState.TRACK;
    _trackingMessage = 'Aktivitas dimulai';
    notifyListeners();

    // open panel & activity snackbar
    openPanel();

    // logger
    log('state: ${_trackingState.name}', name: 'TRACKING STATE');
  }

  //* calculate distance
  void _calculateDistance(LatLng? lastPoint, LatLng newPoint) {
    // Pastikan koordinat pertama ditambahkan jika _coordinates kosong
    if (_coordinates.isEmpty) {
      _coordinates.add(newPoint);
      notifyListeners();

      // logger
      log('Point pertama (${newPoint.latitude}, ${newPoint.longitude}) tercatat pada detik: $_seconds');
      return; // Keluar dari fungsi, karena tidak perlu menghitung jarak jika hanya 1 titik
    }

    // logger untuk point yang ditambahkan
    log('Point ${_coordinates.length} (${newPoint.latitude}, ${newPoint.longitude}) tercatat pada detik: $_seconds');

    if (lastPoint != null) {
      final newDistance = _distance(lastPoint, newPoint);

      // logger
      log('Jarak antara point ${_coordinates.length - 1} (${lastPoint.latitude}, ${lastPoint.longitude}) ke point ${_coordinates.length} (${newPoint.latitude}, ${newPoint.longitude}) adalah ${newDistance.toStringAsFixed(2)} meter');

      // Jika jarak valid (kurang dari 35 meter), tambahkan koordinat
      if (newDistance < 30) {
        _coordinates.add(newPoint); // Tambahkan point baru ke koordinat
        _mileage += newDistance; // Tambah jarak tempuh
        notifyListeners();

        // logger
        log('Pergerakan valid sejauh $newDistance meter dihitung');
        log('Jarak tempuh diperbarui menjadi ${_mileage.toStringAsFixed(2)} meter');
      } else {
        // logger
        log('Pergerakan tidak valid sejauh $newDistance meter, tidak dihitung, poin dihapus');

        // Koordinat tidak valid, tidak perlu menambah point baru
        // Hanya log yang akan muncul di sini
      }
    }
  }

  //* pause tracking
  void pauseTracking() {
    if (_locationListener != null && _trackingState == TrackingState.TRACK) {
      // action
      _pauseTimer();
      _locationListener!.pause();

      // set state
      _trackingState = TrackingState.PAUSE;
      _trackingMessage = 'Aktivitas dijeda';
      notifyListeners();

      // open panel & activity snackbar
      openPanel();

      // logger
      log('Tracking dijeda');
      log('state: ${_trackingState.name}', name: 'TRACKING STATE');
    }
  }

  //* resume tracking
  void resumeTracking() {
    if (_locationListener != null && _trackingState == TrackingState.PAUSE) {
      // action
      _resumeTimer();
      _locationListener!.resume();

      // set state
      _trackingState = TrackingState.TRACK;
      _trackingMessage = 'Aktivitas dilanjutkan';
      notifyListeners();

      // open panel & activity snackbar
      openPanel();

      // logger
      log('Tracking dilanjutkan kembali');
      log('state: ${_trackingState.name}', name: 'TRACKING STATE');
    }
  }

  //* stop tracking
  Future<void> stopTracking() async {
    if (_locationListener != null) {
      // nonaktifkan layanan latar belakang
      await _enableBackgroundMode(false);

      // dispose action
      _stopTimer();
      _stopListenServiceConnection();
      _locationListener!.cancel();
      _mapController.dispose();

      // set state
      _trackingState = TrackingState.STOP;
      _trackingMessage = 'Aktivitas dihentikan';
      notifyListeners();

      // logger
      log('Menghentikan tracking lokasi');
      log('state: ${_trackingState.name}', name: 'TRACKING STATE');
    }
  }

  //* reset data coordinate & mileage
  void resetTrackingData() {
    // action
    _step = 0;
    _seconds = 0;
    _speed = 0.0;
    _mileage = 0.0;
    _coordinates = [];
    _timer = null;
    _gpsListener = null;
    _trackingMessage = null;
    _locationListener = null;
    _connectionListener = null;
    _trackingState = TrackingState.INIT;
    notifyListeners();

    // logger
    log('Semua data tracking dihapus');
    log('tracking message : $_trackingMessage');
    log('state: ${_trackingState.name}', name: 'TRACKING STATE');
  }
}
