import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/strings/asset_img_string.dart';
import '../../domain/entity/product.dart';
import '../providers/shop_provider.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
    this.product, {
    super.key,
    this.onTap,
    this.radius = 8.0,
  });

  final double radius;
  final Product product;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 190,
            maxWidth: 150,
            minHeight: 80,
            minWidth: 140,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
          ),
          child: LayoutBuilder(
            builder: (_, size) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //foto
                  Expanded(
                    child: Stack(
                      children: [
                        // foto
                        _productImage(size),

                        // poin
                        Positioned(
                          top: 0,
                          right: 0,
                          child: _poin(context),
                        ),
                      ],
                    ),
                  ),

                  // product content
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 8,
                      left: 8,
                      bottom: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // event berakhir berapa hari lagi
                        _expiration(context),

                        // nama produk
                        _productName(context),
                        const SizedBox(height: 2),

                        // deksripsi produk
                        _description(context),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _description(BuildContext context) {
    return Text(
      product.description ?? '',
      style: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(height: 1, fontSize: 10),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }

  Widget _productName(BuildContext context) {
    return Text(
      product.name ?? '',
      style: Theme.of(context).textTheme.titleSmall,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _expiration(BuildContext context) {
    final expiration = context.read<ShopProvider>().getProductExpiration(
          product.expiration ?? '',
        );
    return Text(
      '$expiration Hari lagi',
      style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 10),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }

  Widget _poin(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(4),
        ),
      ),
      child: Text(
        '${product.pointsRequired ?? 0} Poin',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  Widget _productImage(BoxConstraints size) {
    return SizedBox(
      width: size.maxWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CachedNetworkImage(
          imageUrl: product.productImg ?? '',
          errorWidget: (_, u, e) => Image.asset(AssetImg.error),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
