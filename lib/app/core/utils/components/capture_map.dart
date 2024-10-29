import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../presentation/providers/user_provider.dart';
import '../strings/asset_img_string.dart';

class CaptureMap extends StatelessWidget {
  const CaptureMap({
    super.key,
    required this.points,
    this.zoom = 15.0,
    this.showPreview = false,
    this.scrollGestureEnabled = true,
  });

  final List<LatLng> points;
  final double zoom;
  final bool showPreview;
  final bool scrollGestureEnabled;

  //* show preview
  void _showMapDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _MapsPreview(points),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool availablePoints = (points.length >= 2);
    double customZoom = 11.0;
    LatLng customCenter = const LatLng(
        -6.969301228877812, 110.42436341802649); // titik nol semarang
    LatLng defaultCenter = const LatLng(50.5, 30.51);

    return FlutterMap(
      options: MapOptions(
        initialZoom: !availablePoints ? customZoom : zoom,
        initialCenter: !availablePoints ? customCenter : defaultCenter,
        initialCameraFit: availablePoints
            ? CameraFit.coordinates(
                coordinates: points,
                padding: const EdgeInsets.all(32),
              )
            : null,
        interactionOptions: InteractionOptions(
          flags: (scrollGestureEnabled)
              ? InteractiveFlag.all
              : InteractiveFlag.none, // disable gesture
        ),
        onTap: availablePoints
            ? (position, coord) {
                if (showPreview == false) return;
                _showMapDialog(context);
              }
            : null,
      ),
      children: [
        // tile layer
        _tileLayer(),

        // polylines
        if (availablePoints) _drawPolyline(context),

        // marker (start point - end point)
        if (availablePoints) _buildMarker(context),
      ],
    );
  }

  Widget _tileLayer() {
    return TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.walk_for_wealth',
      errorImage: const AssetImage(AssetImg.error),
      tileProvider: CancellableNetworkTileProvider(),
    );
  }

  Widget _drawPolyline(BuildContext context) {
    return PolylineLayer(
      polylines: [
        Polyline(
          strokeWidth: 3,
          borderStrokeWidth: 1,
          borderColor: Colors.grey.shade700,
          color: Theme.of(context).primaryColor,
          points: points,
        )
      ],
    );
  }

  Widget _buildMarker(BuildContext context) {
    return Consumer<UserProvider>(builder: (ctx, c, _) {
      return MarkerLayer(
        markers: [
          // start point
          Marker(
            point: points.first,
            height: 20,
            width: 20,
            child: const Icon(
              Icons.circle,
              color: Color.fromARGB(255, 0, 67, 122),
              size: 18,
            ),
          ),

          // end point
          Marker(
            point: points.last,
            height: 25,
            width: 25,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color: const Color.fromARGB(255, 0, 67, 122),
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).dialogBackgroundColor,
                backgroundImage: c.getImgProfile(),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _MapsPreview extends StatelessWidget {
  const _MapsPreview(this.points);

  final List<LatLng> points;

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.zero;
    final dialogWidth = MediaQuery.of(context).size.width;
    final dialogHeight = MediaQuery.of(context).size.height * 0.7;

    return AlertDialog(
      iconPadding: padding,
      titlePadding: padding,
      buttonPadding: padding,
      actionsPadding: padding,
      contentPadding: padding,
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          child: CaptureMap(points: points),
        ),
      ),
      actions: [
        Row(children: [
          _actionButton(
            context,
            'Kembali',
            () => Navigator.of(context).pop(),
          ),
        ]),
      ],
    );
  }

  Widget _actionButton(
    BuildContext context,
    String label,
    VoidCallback action,
  ) {
    return Expanded(
      child: OutlinedButton(
        onPressed: action,
        style: OutlinedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(8),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(label),
        ),
      ),
    );
  }
}
