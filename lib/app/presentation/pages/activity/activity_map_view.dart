import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

import '../../../core/enums/location_permission_state.dart';
import '../../../core/enums/location_state.dart';
import '../../../core/utils/strings/asset_img_string.dart';
import '../../providers/tracking_provider.dart';
import '../../providers/user_provider.dart';

class ActivityMapView extends StatelessWidget {
  const ActivityMapView(this.actionButtonHeight, {super.key});

  final double actionButtonHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: actionButtonHeight),
      child: Consumer<TrackingProvider>(
        builder: (ctx, c, _) {
          switch (c.permissionState) {
            case LocationPermissionState.INIT:
              return const Center(child: CircularProgressIndicator.adaptive());
            case LocationPermissionState.DENIED:
              return _deniedPermissionView(context, c);
            case LocationPermissionState.ALLOWED:
              return _buildViewState(context, c);
          }
        },
      ),
    );
  }

  Widget _buildViewState(
    BuildContext context,
    TrackingProvider c,
  ) {
    if (c.getLocationState == GetLocationState.LOADING) {
      return const SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator.adaptive(),
              SizedBox(height: 16),
              Text(
                'Mendapatkan lokasi...',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    } else if (c.getLocationState == GetLocationState.FAILURE) {
      return Center(
        child: Text(c.getLocationMessage!, textAlign: TextAlign.center),
      );
    } else {
      return Stack(
        children: [
          // map view
          FlutterMap(
            mapController: c.mapController,
            options: MapOptions(
              initialCenter: LatLng(
                c.currentPosition!.latitude!,
                c.currentPosition!.longitude!,
              ),
              initialZoom: 17.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.walk_for_wealth',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    strokeWidth: 2.8,
                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                    points: c.coordinates,
                  )
                ],
              ),
              Consumer<UserProvider>(builder: (ctx, c, _) {
                return CurrentLocationLayer(
                  style: LocationMarkerStyle(
                    markerSize: const Size.square(24),
                    marker: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: c.getImgProfile(),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),

          // focus controller
          if (c.coordinates.isNotEmpty)
            Positioned(
              right: 16,
              bottom: actionButtonHeight + 32,
              child: FloatingActionButton(
                heroTag: 'focus_controller',
                onPressed: c.moveCamera,
                highlightElevation: 0,
                child: const Icon(Icons.track_changes_outlined),
              ),
            )
        ],
      );
    }
  }

  Widget _deniedPermissionView(BuildContext context, TrackingProvider c) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetImg.onBoarding1,
              width: double.infinity,
              height: 200,
            ),
            const SizedBox(height: 8),
            Text(
              c.permissionMessage ?? '',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
