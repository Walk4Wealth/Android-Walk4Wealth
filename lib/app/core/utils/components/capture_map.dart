import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../strings/asset_img_string.dart';

class CaptureMap extends StatelessWidget {
  const CaptureMap({
    super.key,
    required this.points,
    this.zoom = 15.0,
    this.showPreview = false,
  });

  final List<LatLng> points;
  final double zoom;
  final bool showPreview;

  //* show preview
  void _showMapDialog(
    BuildContext context,
    List<LatLng> points,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        const padding = EdgeInsets.zero;
        return AlertDialog(
          iconPadding: padding,
          titlePadding: padding,
          buttonPadding: padding,
          actionsPadding: padding,
          contentPadding: padding,
          insetPadding: const EdgeInsets.symmetric(horizontal: 30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.7,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: CaptureMap(points: points),
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(8),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Kembali'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCameraFit: CameraFit.coordinates(
          coordinates: points,
          padding: const EdgeInsets.all(32),
        ),
        initialZoom: zoom,
        onTap: (_, __) {
          if (showPreview == false) return;
          _showMapDialog(context, points);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.walk_for_wealth',
          errorImage: const AssetImage(AssetImg.error),
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              strokeWidth: 3,
              color: Theme.of(context).primaryColor.withOpacity(0.8),
              points: points,
            ),
          ],
        ),
      ],
    );
  }
}
