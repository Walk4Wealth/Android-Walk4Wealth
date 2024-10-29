import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

import '../../../core/enums/location_permission_state.dart';
import '../../../core/enums/location_state.dart';
import '../../../core/utils/components/w_button.dart';
import '../../../core/utils/strings/asset_img_string.dart';
import '../../providers/tracking_provider.dart';
import '../../providers/user_provider.dart';

//* activity view
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
              return const Center(child: CircularProgressIndicator());
            case LocationPermissionState.DENIED:
            case LocationPermissionState.DENIED_FOREVER:
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
    switch (c.getLocationState) {
      case GetLocationState.LOADING:
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(bottom: actionButtonHeight),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Mendapatkan lokasi...',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      case GetLocationState.FAILURE:
        return Center(
          child: Text(c.getLocationMessage!, textAlign: TextAlign.center),
        );
      case GetLocationState.SUCCESS:
        return _TrackingMapsView(c);
    }
  }

  Widget _deniedPermissionView(BuildContext context, TrackingProvider c) {
    return Padding(
      padding: EdgeInsets.only(bottom: actionButtonHeight),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //* asset intruksi
              Image.asset(
                AssetImg.accessLocationAllTime,
                width: double.infinity,
                height: 200,
              ),
              const SizedBox(height: 16),

              //* title
              Text(
                c.permissionMessage ?? '',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              //* intruksi
              Text.rich(
                TextSpan(
                  text: 'Masuk pengaturan aplikasi -> Izin lokasi -> ',
                  style: Theme.of(context).textTheme.bodySmall,
                  children: [
                    TextSpan(
                      text: 'Izinkan lokasi sepanjang waktu',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    TextSpan(
                      text: ' untuk mengaktifkan mode latar belakang',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              //* opeen app settings
              WButton(
                label: 'Buka pengaturan',
                padding: 12,
                onPressed: () async {
                  Navigator.of(context).pop();
                  await c.openAppSettings();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//* tracking maps view
class _TrackingMapsView extends StatelessWidget {
  const _TrackingMapsView(this.c);

  final TrackingProvider c;

  @override
  Widget build(BuildContext context) {
    const primaryDarker = Color.fromARGB(255, 0, 67, 122);

    return FlutterMap(
      mapController: c.mapController,
      options: MapOptions(
        initialZoom: 17.0,
        initialCenter: LatLng(
          c.currentPosition!.latitude!,
          c.currentPosition!.longitude!,
        ),
      ),
      children: [
        //* tile (maps)
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.walk_for_wealth',
          tileProvider: CancellableNetworkTileProvider(),
        ),

        //* polyline
        PolylineLayer(
          polylines: [
            Polyline(
              strokeWidth: 3,
              borderStrokeWidth: 1,
              borderColor: Colors.grey.shade700,
              color: Theme.of(context).primaryColor,
              points: c.coordinates,
            )
          ],
        ),

        //* first marker
        if (c.coordinates.isNotEmpty)
          MarkerLayer(
            markers: [
              Marker(
                point: c.coordinates.first,
                height: 20,
                width: 20,
                child: const Icon(
                  Icons.circle,
                  color: primaryDarker,
                  size: 18,
                ),
              ),
            ],
          ),

        //* current marker
        Consumer<UserProvider>(builder: (ctx, c, _) {
          return CurrentLocationLayer(
            moveAnimationCurve: Curves.ease,
            moveAnimationDuration: const Duration(milliseconds: 500),
            style: LocationMarkerStyle(
              markerSize: const Size.square(22),
              marker: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    color: primaryDarker,
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
    );
  }
}
