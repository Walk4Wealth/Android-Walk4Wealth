import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../app.dart';
import '../../core/enums/activity_mode.dart';
import '../../core/enums/location_permission_state.dart';
import '../../core/enums/location_state.dart';
import '../../core/enums/tracking_state.dart';
import '../../core/formatter/time_formatter.dart';
import '../../core/network/device_connection.dart';
import '../../core/utils/dialog/w_dialog.dart';

class TrackingProvider extends ChangeNotifier {
  final Location _location;
  final Distance _calculateDistance;
  final DeviceConnection _connection;

  TrackingProvider({
    required Distance distance,
    required Location location,
    required DeviceConnection connection,
  })  : _calculateDistance = distance,
        _location = location,
        _connection = connection;

  //! controller
  late MapController _mapController;
  final PanelController _panelController = PanelController();

  MapController get mapController => _mapController;
  PanelController get panelController => _panelController;

  //! stream subscription
  StreamSubscription? _gpsListener;
  StreamSubscription<LocationData>? _locationListener;
  StreamSubscription<List<ConnectivityResult>>? _connectionListener;

  //! tracking interval
  final double _distanceFilter = 10.0; // in meters
  final int _trackingInterval = 1000; // in miliseconds 1000ms = 1s
  final LocationAccuracy _trackingAccuracy = LocationAccuracy.high;

  //! is cheating
  bool _isCheatDialogShowing = false;

  //! is allow all time
  bool _isLocationAllowAllTime = false;
  bool get isLocationAllowAllTime => _isLocationAllowAllTime;

  //! tracking threshold (max speed & distance)
  final double _maxSpeed = 21.0; // km/h
  final double _distanceThreshold = 50.0; //in meters

  //! step per meter walking & running (estimate)
  final double _stepPerMeterWalking = 1.35; // in meters
  final double _stepPerMeterRunning = 1.0; // in meters

  //! tracking service (internet & gps)
  bool _isNoServiceDialogShowing = false;
  bool _isInternetActive = true;
  bool _isGPSActive = true;

  //! countdown timer
  // saat memulai tracking maka akan ada hitung mundur
  int _countdown = 3;
  bool _isCountingDown = false;

  int get countdown => _countdown;
  bool get isCountingDown => _isCountingDown;

  //! timer
  int _seconds = 0;
  Timer? _timer;

  //! tracking time & duration
  DateTime get currentDate => DateTime.now();
  Duration get duration => Duration(seconds: _seconds);
  String get stringTimer => TimeFormat.formatTimer(_seconds);
  String get stringDuration => TimeFormat.formatDuration(duration);

  //! temp tracking point
  LocationData? _position; // for tracking
  LocationData? _currentPosition; // for get current location

  LocationData? get position => _position;
  LocationData? get currentPosition => _currentPosition;

  //! tracking result (distance/mileage, speed, steps, & coordinates)
  int _step = 0;
  double _speed = 0.0;
  double _mileage = 0.0;
  final List<LatLng> _coordinates = <LatLng>[];

  int get step => _step;
  double get speed => _speed;
  double get mileage => _mileage;
  List<LatLng> get coordinates => _coordinates;

  //! state
  TrackingState _trackingState = TrackingState.INIT;
  ActivityMode _activityMode = ActivityMode.Berjalan;
  GetLocationState _getLocationState = GetLocationState.LOADING;
  LocationPermissionState _permissionState = LocationPermissionState.INIT;

  ActivityMode get activityMode => _activityMode;
  TrackingState get trackingState => _trackingState;
  GetLocationState get getLocationState => _getLocationState;
  LocationPermissionState get permissionState => _permissionState;

  //! message
  String? _trackingMessage;
  String? _permissionMessage;
  String? _getLocationMessage;

  String? get trackingMessage => _trackingMessage;
  String? get permissionMessage => _permissionMessage;
  String? get getLocationMessage => _getLocationMessage;

  ////! ======[ INITIAL DEPENDENCIES ]====== ////

  //* init map controller
  void initMapController(MapController controller) {
    _mapController = controller;
  }

  ////! ======[ COUNTDOWN TIMER DIALOG ]====== ////

  //* show countdown dialog // before tracking
  void startCountdown(
    BuildContext context,
    VoidCallback startTracking,
  ) async {
    // reset countdown
    _countdown = 3;
    _isCountingDown = true;
    notifyListeners();

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        if (_countdown == 3) {
          _countdownCounter(context, startTracking);
        }
        return PopScope(
          canPop: false,
          child: Consumer<TrackingProvider>(builder: (ctx, c, _) {
            const color = Colors.transparent;
            const padding = EdgeInsets.zero;

            return AlertDialog(
              shadowColor: color,
              titlePadding: padding,
              actionsPadding: padding,
              buttonPadding: padding,
              contentTextStyle: Theme.of(context).textTheme.displayMedium,
              content: Text(
                c.countdown.toString(),
                textAlign: TextAlign.center,
              ),
            );
          }),
        );
      },
    );
  }

  void _countdownCounter(
    BuildContext context,
    VoidCallback startTracking,
  ) async {
    while (_countdown > 0) {
      await Future.delayed(const Duration(seconds: 1));
      _countdown--;
      notifyListeners();
    }
    if (context.mounted) {
      Navigator.of(context).pop(); // tutup dialog countdown
      startTracking(); // tracking callback
    }
  }

  ////! ======[ HANDLE CHEATING ]====== ////

  //* show cheat dialog
  void _showCheatDialog() async {
    pauseTracking();
    _stopListenServiceConnection();

    BuildContext context = navigatorKey.currentContext!;

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

  ////! ======[ CALCULATE TRACKING DATA ]====== ////

  //* get activity id
  int getActivityId() {
    switch (_activityMode) {
      case ActivityMode.Berjalan:
        return 1;
      case ActivityMode.Berlari:
        return 3;
    }
  }

  //* calculate step
  void calculateStep() {
    double estimateStep;
    switch (_activityMode) {
      case ActivityMode.Berjalan:
        estimateStep = _stepPerMeterWalking;
        break;
      case ActivityMode.Berlari:
        estimateStep = _stepPerMeterRunning;
        break;
    }
    _step = (_mileage * estimateStep).round();
    notifyListeners();
  }

  ////! ======[ ACTIVITY MODE ]====== ////

  //* select activity mode
  void selecActivitytMode(ActivityMode mode) {
    _activityMode = mode;
    notifyListeners();
  }

  ////! ======[ PANEL CONTROLLER ]====== ////

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

  ////! ======[ LISTEN SERVICE (INTERNET & GPS) CONNECTION ]====== ////

  //* start listen internet connection (internet & gps)
  void _startListenServiceConnection() {
    _connectionListener = _connection.connectionStream.listen((connections) {
      _isInternetActive = connections.contains(ConnectivityResult.wifi) ||
          connections.contains(ConnectivityResult.mobile) ||
          connections.contains(ConnectivityResult.vpn) ||
          connections.contains(ConnectivityResult.ethernet);
      _updateTrackingServiceStatus();
    });

    // setiap 3 detik sekali akan melakukan cek apakah gps aktif atau mati
    _gpsListener = Stream.periodic(const Duration(seconds: 3))
        .asyncMap((_) => _location.serviceEnabled())
        .distinct() // handle event duplikat
        .listen((isGpsEnabled) {
      _isGPSActive = isGpsEnabled;
      _updateTrackingServiceStatus();
    });
  }

  //* update tracking status when location service is available
  void _updateTrackingServiceStatus() {
    // jika internet dan GPS keduanya aktif, resume tracking
    if (_isInternetActive && _isGPSActive) {
      // action
      resumeTracking();
      _hideNoServiceDialog();
    } else {
      // jika salah satu atau keduanya mati, pause tracking
      pauseTracking();
      _showNoServiceDialog();
    }
  }

  //* show no connection & gps dialog
  void _showNoServiceDialog() {
    final context = navigatorKey.currentContext!;

    if (_isNoServiceDialogShowing) return;
    _isNoServiceDialogShowing = true;

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
  void _hideNoServiceDialog() {
    if (_isNoServiceDialogShowing) {
      Navigator.of(navigatorKey.currentContext!).pop();
      _isNoServiceDialogShowing = false;
    }
  }

  //* stop listen internet connection
  void _stopListenServiceConnection() {
    _connectionListener!.cancel();
    _gpsListener!.cancel();
  }

  ////! ======[ TIMER CONTROLLER ]====== ////

  //* start timer
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _seconds++;
      notifyListeners();
    });
  }

  //* pause timer
  void _pauseTimer() {
    _timer!.cancel();
  }

  //* resume timer
  void _resumeTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _seconds++;
      notifyListeners();
    });
  }

  //* stop timer
  void _stopTimer() {
    _timer!.cancel();
  }

  ////! ======[ OPEN APP SETTINGS ]====== ////

  //* open app setting
  Future<void> openAppSettings() async {
    await ph.openAppSettings();
  }

  ////! ======[ PREPARE TRACKING SERVICE (GPS, PERMISSION, BACKGROUND TASK) ]====== ////

  Future<void> checkLocationAllowAllTime() async {
    bool allowGranted = await ph.Permission.locationAlways.isGranted;

    _isLocationAllowAllTime = allowGranted;
    notifyListeners();
  }

  //* cek GPS
  Future<bool> _isGPSEnabled() async {
    bool serviceEnabled;

    // cek apakah gps aktif
    serviceEnabled = await _location.serviceEnabled();

    if (!serviceEnabled) {
      // jika tidak aktif, minta user untuk mengaktifkan gps
      serviceEnabled = await _location.requestService();

      // feedback ke user jika gps masih belum aktif
      if (!serviceEnabled) {
        _permissionMessage =
            'Harap hidupkan layanan lokasi atau GPS di perangkat Kamu';
        notifyListeners();
        return false;
      }
    }

    // jika gps aktif
    return true;
  }

  //* device permission
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
      permission = await _location.requestPermission();

      // Jika izin masih ditolak setelah permintaan
      if (permission != PermissionStatus.granted) {
        _permissionState = LocationPermissionState.DENIED;
        _permissionMessage = 'Izin akses lokasi ditolak';
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

  //* Enable Background Mode
  Future<void> enableBackgroundMode(bool enable) async {
    try {
      await _location.enableBackgroundMode(enable: enable);
    } catch (e) {
      // handle error
      // next code ->
    }
  }

  ////! ======[ TRACKING CONTROLLER (GET CURRENT LOCATION & LISTEN TRACKING) ]====== ////

  //* get current location
  Future<void> getCurrentLocation() async {
    // set location to loading
    _getLocationState = GetLocationState.LOADING;
    notifyListeners();

    // jika izin tidak diberikan, jangan lanjutkan
    bool permissionGranted = await _devicePermission();
    if (!permissionGranted) return;

    // mendapatkan lokasi saat ini
    try {
      LocationData position = await _location.getLocation();

      // set data & state
      _currentPosition = position;
      _getLocationMessage = null;
      _getLocationState = GetLocationState.SUCCESS;
      notifyListeners();
    } catch (e) {
      // handle error
      // next code ->

      // set error state & message
      _getLocationMessage = 'Gagal mendapatkan lokasi: ${e.toString()}';
      _getLocationState = GetLocationState.FAILURE;
      notifyListeners();
    }
  }

  //* start tracking
  Future<void> startTracking() async {
    // set loading state
    _trackingState = TrackingState.LOADING;
    notifyListeners();

    // aktifkan layanan latar belakang
    await enableBackgroundMode(true);

    // setting map interval & distance filter
    // aplikasi akan memperbaharui lokasi setelah berjarak 10 meter
    await _location.changeSettings(
      distanceFilter: _distanceFilter,
      interval: _trackingInterval,
      accuracy: _trackingAccuracy,
    );

    // start listen location
    _locationListener = _location.onLocationChanged.listen(
      (position) {
        if (position.latitude != null && position.longitude != null) {
          LatLng newPoint = LatLng(position.latitude!, position.longitude!);
          LatLng? lastPoint =
              _coordinates.isNotEmpty ? _coordinates.last : null;

          // nilai speed yang ditampung harus dalam satuan km/h
          // sedangkan satuan speed bawaan dari object position adalah m/s
          // rumus untuk mengkonversi m/s ke km/h adalah: km/h = m/s * 3.6
          double speedInKmh = ((position.speed ?? 0.0) * 3.6);

          // set data
          _position = position;
          _speed = speedInKmh;
          notifyListeners();

          // action
          _trackingAction(lastPoint, newPoint);
          if (speedInKmh > _maxSpeed) {
            _showCheatDialog();
          }
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
      },
    );

    // set state
    _trackingState = TrackingState.TRACK;
    _trackingMessage = 'Aktivitas dimulai';
    notifyListeners();

    // action
    openPanel();
    _startTimer();
    _startListenServiceConnection();
  }

  //* tracking action
  // calculate distance, update mileage / draw polylines / focus on user
  void _trackingAction(LatLng? lastPoint, LatLng newPoint) {
    if (_coordinates.isEmpty) {
      _coordinates.add(newPoint);
      notifyListeners();

      return;
    }

    if (lastPoint != null) {
      // calculate distance
      double newDistance = _calculateDistance(lastPoint, newPoint);

      // Jika jarak valid (kurang dari 30 meter)
      if (newDistance < _distanceThreshold) {
        _coordinates.add(newPoint); // draw polylines
        _mileage += newDistance; // update mileage
        notifyListeners();

        // move camera
        _mapController.move(newPoint, _mapController.camera.zoom);
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
    }
  }

  //* stop tracking
  Future<void> stopTracking() async {
    if (_locationListener != null) {
      // nonaktifkan layanan latar belakang
      await enableBackgroundMode(false);

      // dispose action
      _stopTimer();
      _stopListenServiceConnection();
      _locationListener!.cancel();
      _mapController.dispose();

      // set state
      _trackingState = TrackingState.STOP;
      _trackingMessage = 'Aktivitas dihentikan';
      notifyListeners();
    }
  }

  //* reset data coordinate & mileage
  void resetTrackingData() {
    _seconds = 0;
    _step = 0;
    _speed = 0.0;
    _mileage = 0.0;
    _coordinates.clear();
    _position = null;
    _timer = null;
    _gpsListener = null;
    _trackingMessage = null;
    _locationListener = null;
    _connectionListener = null;
    _trackingState = TrackingState.INIT;
  }
}
