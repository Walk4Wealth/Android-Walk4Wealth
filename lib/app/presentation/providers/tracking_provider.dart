import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../core/enum/location_permission_state.dart';
import '../../core/enum/location_state.dart';
import '../../core/enum/tracking_state.dart';

class TrackingProvider extends ChangeNotifier {
  final Distance _distance;

  TrackingProvider({required Distance distance}) : _distance = distance;

  StreamSubscription<Position>? _locationListener;
  StreamSubscription<CompassEvent>? _compassListener;

  late Timer _timer;
  int _milliseconds = 0;

  String get trackingTime => _formatTime(_milliseconds);

  double _degreeRotation = 0.0;
  double get degreeRotation => _degreeRotation;

  Position? _position;
  Position? get position => _position;

  double _mileage = 0.0;
  double get mileage => _mileage;

  double _speed = 0.0;
  double get speed => _speed;

  double _accuracy = 0.0;
  double get accuracy => _accuracy;

  List<LatLng> _coordinates = [];
  List<LatLng> get coordinates => _coordinates;

  GetLocationState _getLocationState = GetLocationState.LOADING;
  GetLocationState get getLocationState => _getLocationState;

  LocationPermissionState _permissionState = LocationPermissionState.INIT;
  LocationPermissionState get permissionState => _permissionState;

  TrackingState _trackingState = TrackingState.INIT;
  TrackingState get trackingState => _trackingState;

  String? _permissionMessage;
  String? get permissionMessage => _permissionMessage;

  String? _getLocationMessage;
  String? get getLocationMessage => _getLocationMessage;

  String? _trackingMessage;
  String? get trackingMessage => _trackingMessage;

  //* format timer
  String _formatTime(int milliseconds) {
    final hours = (milliseconds ~/ 3600000).toString().padLeft(2, '0');
    final minutes =
        ((milliseconds % 3600000) ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((milliseconds % 60000) ~/ 1000).toString().padLeft(2, '0');
    final milliSeconds = (milliseconds % 1000).toString().padLeft(3, '0');
    return "$hours:$minutes:$seconds:$milliSeconds";
  }

  //* start timer
  void _startTimer() {
    if (_trackingState == TrackingState.TRACK) return;
    _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      _milliseconds++;
      notifyListeners();
    });
    log('Timer dimulai');
  }

  //* pause timer
  void _pauseTimer() {
    if (_trackingState == TrackingState.PAUSE) return;
    _timer.cancel();
    log("Timer dipause");
  }

  //* resume timer
  void _resumeTimer() {
    if (_trackingState == TrackingState.RESUME) return;
    _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      _milliseconds++;
      notifyListeners();
    });
    log("Timer dilanjutkan");
  }

  //* stop timer
  void _stopTimer() {
    if (_trackingState == TrackingState.STOP) return;
    _timer.cancel();
    log("Timer distop");
  }

  //* initialize compass
  void _initCompass() {
    _compassListener = FlutterCompass.events?.listen((event) {
      _degreeRotation = event.heading ?? 0.0;
      notifyListeners();
    });
    log('Kompas di inisiasi');
  }

  //* setting lokasi berdasarkan device
  LocationSettings _getSettingLocation() {
    const distanceFilter = 3;
    const accuracy = LocationAccuracy.high;
    if (Platform.isAndroid) {
      return AndroidSettings(
        accuracy: accuracy,
        forceLocationManager: true,
        distanceFilter: distanceFilter,
      );
    } else {
      return AppleSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
        showBackgroundLocationIndicator: true,
        activityType: ActivityType.otherNavigation,
      );
    }
  }

  //* izin perangkat
  Future<bool> _devicePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah gps aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      log('Harap hidupkan layanan lokasi atau GPS diperangkat Anda');
      _permissionMessage =
          'Harap hidupkan layanan lokasi atau GPS diperangkat Anda';
      notifyListeners();
      return false;
    }

    // Cek izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request izin lokasi jika ditolak
      log('Request permission location');
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Izin ditolak
        _permissionState = LocationPermissionState.DENIED;
        _permissionMessage =
            'Izin akses lokasi ditolak. Buka pengaturan untuk mengaktifkan layanan lokasi';
        notifyListeners();
        return false;
      }
    }

    // Izin ditolak selamanya
    if (permission == LocationPermission.deniedForever) {
      _permissionState = LocationPermissionState.DENIED_FOREVER;
      _permissionMessage =
          'Izin lokasi ditolak selamanya. Buka pengaturan untuk mengaktifkan layanan lokasi';
      notifyListeners();
      return false;
    }

    // Izin diberikan
    _permissionState = LocationPermissionState.ALLOWED;
    _permissionMessage = null;
    notifyListeners();
    return true;
  }

  //* buka setting aplikasi
  void openAppSetting() async {
    await Geolocator.openAppSettings();
  }

  //* Mendapatkan lokasi saat ini
  Future<void> getCurrentLocation() async {
    // Memeriksa izin terlebih dahulu
    bool permissionGranted = await _devicePermission();

    // Jika izin tidak diberikan, jangan lanjutkan
    if (!permissionGranted) {
      return;
    }

    // Mendapatkan lokasi saat ini
    try {
      final position = await Geolocator.getCurrentPosition();
      log('Lokasi ditemukan ${position.latitude}, ${position.longitude}');

      _position = position;
      _getLocationMessage = null;
      _permissionMessage = null;
      _getLocationState = GetLocationState.SUCCESS;
      notifyListeners();
    } catch (e) {
      // Mengelola kegagalan saat mendapatkan lokasi
      _getLocationState = GetLocationState.FAILURE;
      _getLocationMessage =
          'Kesalahan saat mendapatkan lokasi: ${e.toString()}';
      notifyListeners();
    }
  }

  //* reset data coordinate dan mileage
  void _resetData() {
    _coordinates = [];
    _mileage = 0.0;
    _trackingMessage = null;
    notifyListeners();
  }

  //* start tracking
  Future<void> startTracking(MapController mapController) async {
    log('Mulai melakukan tracking');

    if (_trackingState == TrackingState.TRACK) {
      log('Tracking sudah dimulai');
      _trackingMessage = 'Tracking sudah dimulai';
      notifyListeners();
      return;
    }

    // Set tracking state ke LOADING
    _trackingState = TrackingState.LOADING;
    notifyListeners();

    // Cek apakah listener sudah aktif
    if (_locationListener != null) {
      log('Listener sudah aktif');
      return;
    }

    // reset coordinate ketika memulai track
    if (_mileage != 0.0 ||
        _coordinates.isNotEmpty ||
        _trackingMessage != null) {
      _resetData();
      return;
    }

    // rekam lokasi secara real time
    _locationListener = Geolocator.getPositionStream(
      locationSettings: _getSettingLocation(),
    ).listen(
      (position) {
        final newPoint = LatLng(position.latitude, position.longitude);

        //* DO
        _position = position;
        _speed = position.speed;
        _accuracy = position.accuracy;
        notifyListeners();

        // hitung jarak tempuh
        _calculateMileage(
            _coordinates.isNotEmpty ? _coordinates.last : null, newPoint);

        // gambar polyline
        _drawPolylines(newPoint);

        // move camera
        _moveCamera(mapController, newPoint);
      },
      onError: (e) {
        log('Terjadi kesalahan saat melakukan Tracking : ${e.toString()}');
        _getLocationMessage =
            'Terjadi kesalahan saat melakukan Tracking : ${e.toString()}';
        _trackingState = TrackingState.FAILURE;
        notifyListeners();
      },
    );

    // init kompas untuk rotasi user
    _initCompass();

    // start time
    _startTimer();

    // state dan pesan
    _trackingState = TrackingState.TRACK;
    _trackingMessage = 'Selamat beraktivitas';
    notifyListeners();
  }

  //* calculate mileage
  void _calculateMileage(LatLng? lastPoint, LatLng newPoint) {
    if (lastPoint != null) {
      final newDistance = _distance(lastPoint, newPoint);

      // Log jarak antara titik terakhir dan titik baru
      log('Jarak antara point ${_coordinates.length - 1} dan point ${_coordinates.length} adalah ${newDistance.toStringAsFixed(2)} meter');

      if (newDistance < 50) {
        _mileage += newDistance;
        notifyListeners();
        log('Pergerakan valid: Mileage diperbarui menjadi ${_mileage.toStringAsFixed(2)} meter');
      } else {
        log('Gerakan tidak valid: ${newDistance.toStringAsFixed(2)} meter tidak dihitung');
      }
    }
  }

  //* draw polyline
  void _drawPolylines(LatLng newPoint) {
    _coordinates.add(newPoint);
    notifyListeners();
  }

  //* move camera
  void _moveCamera(MapController mapController, LatLng newPoint) {
    final zoom = mapController.camera.zoom;
    mapController.move(newPoint, zoom);
  }

  //* pause tracking
  void pauseTracking() {
    if (_locationListener != null &&
        _compassListener != null &&
        _trackingState == TrackingState.TRACK) {
      _pauseTimer();
      _locationListener!.pause();
      _compassListener!.pause();

      _trackingState = TrackingState.PAUSE;
      _trackingMessage = 'Tracking dijeda';
      notifyListeners();
      log('Tracking dijeda');
    }
  }

  //* resume tracking
  void resumeTracking() {
    if (_locationListener != null &&
        _compassListener != null &&
        _trackingState == TrackingState.PAUSE) {
      _resumeTimer();
      _locationListener!.resume();
      _compassListener!.resume();

      _trackingState = TrackingState.RESUME;
      _trackingMessage = 'Aktivitas dilanjutkan kembali';
      notifyListeners();
      log('Tracking dilanjutkan');
    }
  }

  //* stop tracking
  void stopTracking() {
    if (_locationListener != null && _compassListener != null) {
      _stopTimer();
      _locationListener!.cancel();
      _compassListener!.cancel();
      _locationListener = null;
      _compassListener = null;
      _trackingState = TrackingState.STOP;
      _trackingMessage = 'Aktivitas ditutup';
      notifyListeners();
      log('Menghentikan tracking lokasi');
    }
  }
}
