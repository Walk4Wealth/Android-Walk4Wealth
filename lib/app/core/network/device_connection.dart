import 'package:connectivity_plus/connectivity_plus.dart';

class DeviceConnection {
  final _connectivity = Connectivity();

  // Method to check internet connection
  Future<bool> hasConnection() async {
    var result = await _connectivity.checkConnectivity();

    return result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.vpn);
  }
}
