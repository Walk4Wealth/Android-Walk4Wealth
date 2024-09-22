import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/utils/strings/asset_img_string.dart';
import '../../domain/entity/vendor.dart';

class VendorCard extends StatelessWidget {
  const VendorCard(
    this.vendor, {
    super.key,
    this.onTap,
    this.radius = 8.0,
  });

  final Vendor vendor;
  final double radius;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
            // logo
            Positioned(
              top: 0,
              right: 0,
              child: SizedBox(
                width: 70,
                height: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl: vendor.logoUrl ?? '',
                    fit: BoxFit.cover,
                    errorWidget: (_, u, e) {
                      return Image.asset(AssetImg.noProfile);
                    },
                  ),
                ),
              ),
            ),

            // efek hitam
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: ClipRRect(
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
              ),
            ),

            // nama vendor & deskripsi
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
                    Text(
                      vendor.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      vendor.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            height: 1,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
