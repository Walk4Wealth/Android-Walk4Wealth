import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../core/enum/location_permission_state.dart';
import '../../../core/enum/location_state.dart';
import '../../../core/utils/strings/asset_img_string.dart';
import '../../providers/tracking_provider.dart';

class ActivityMapView extends StatelessWidget {
  const ActivityMapView(
    this.mapController, {
    super.key,
  });

  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer<TrackingProvider>(
            builder: (ctx, c, _) {
              switch (c.permissionState) {
                case LocationPermissionState.INIT:
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                case LocationPermissionState.DENIED:
                  return _deniedPermissionView(c);
                case LocationPermissionState.DENIED_FOREVER:
                  return _deniedPermissionView(c);
                case LocationPermissionState.ALLOWED:
                  return _buildViewState(context, mapController, c);
              }
            },
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: kBottomNavigationBarHeight +
              MediaQuery.of(context).padding.bottom,
        ),
      ],
    );
  }

  Widget _buildViewState(
    BuildContext context,
    MapController mapController,
    TrackingProvider c,
  ) {
    if (c.getLocationState == GetLocationState.LOADING) {
      return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 100,
                child: Image.asset(AssetImg.loadingLocation),
              ),
              const SizedBox(height: 8),
              const Text('Mendapatkan lokasi...'),
            ],
          ),
        ),
      );
    } else if (c.getLocationState == GetLocationState.FAILURE) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              c.getLocationMessage ?? '',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      return FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: LatLng(
            c.position!.latitude,
            c.position!.longitude,
          ),
          initialZoom: 17.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.walk_for_wealth',
          ),
          CurrentLocationLayer(),
          PolylineLayer(
            polylines: [Polyline(points: c.coordinates)],
          ),
        ],
      );
    }
  }

  Widget _deniedPermissionView(TrackingProvider c) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 100,
              child: Image.asset(
                AssetImg.onBoarding1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              c.permissionMessage ?? '',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => c.openAppSetting(),
              label: const Text('Buka Pengaturan'),
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
