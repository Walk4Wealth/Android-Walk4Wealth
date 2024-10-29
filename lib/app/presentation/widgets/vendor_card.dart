import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/routes/navigate.dart';
import '../../core/utils/strings/asset_img_string.dart';
import '../../domain/entity/vendor.dart';

class VendorCard extends StatelessWidget {
  const VendorCard(this.vendor, {super.key});

  final Vendor vendor;

  void _navigateToVendorDetailPage(BuildContext context) {
    Navigator.pushNamed(context, To.VENDOR, arguments: vendor.id);
  }

  @override
  Widget build(BuildContext context) {
    double radius = 8.0;

    return InkWell(
      onTap: () => _navigateToVendorDetailPage(context),
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Stack(
          children: [
            //* watermark logo dibawah efek blur
            Positioned(
              top: 0,
              right: 0,
              child: _logoWatermark(),
            ),

            //* efek blur
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: _blurredEfffect(radius),
            ),

            //* nama vendor & deskripsi
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _vendorName(context),
                    _description(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vendorName(BuildContext context) {
    return Text(
      vendor.name,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _description(BuildContext context) {
    return Text(
      vendor.description ?? '',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            height: 1,
          ),
    );
  }

  Widget _blurredEfffect(double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.04),
          ),
        ),
      ),
    );
  }

  Widget _logoWatermark() {
    return SizedBox(
      width: 70,
      height: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: CachedNetworkImage(
          imageUrl: vendor.logoUrl ?? '',
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => Image.asset(AssetImg.error),
        ),
      ),
    );
  }
}
