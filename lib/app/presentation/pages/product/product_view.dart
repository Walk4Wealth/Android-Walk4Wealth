import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/navigate.dart';
import '../../../core/utils/strings/asset_img_string.dart';
import '../../../domain/entity/product.dart';
import '../../providers/shop_provider.dart';

class ProductView extends StatelessWidget {
  const ProductView(this.product, {super.key});

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //* product header
        // foto produk / masa aktif / status
        _productHeader(),

        //* konten produk
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* poin
              Text('${product?.pointsRequired ?? 0} Poin',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      )),
              const SizedBox(height: 4),

              // nama produk & stok
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //* nama produk
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      product?.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),

                  //* stok
                  Text(
                    '${product?.stock ?? 0} Stok Tersedia',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 4),

              //* deskripsi
              Text(
                product?.description ?? '',
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodySmall,
              ),

              //* terms
              Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  title: const Text('Syarat & Ketentuan'),
                  tilePadding: EdgeInsets.zero,
                  children: List.generate(
                    product?.terms.length ?? 0,
                    (index) {
                      final term = product?.terms[index];
                      return ListTile(
                        minLeadingWidth: 20,
                        leading: Text('${term?.number ?? 0}'),
                        title: Text(term?.description ?? ''),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),

              //* toko
              _vendorTile(context),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ],
    );
  }

  Widget _productHeader() {
    return SizedBox(
      width: double.infinity,
      height: 350,
      child: Stack(
        children: [
          //* product image
          SizedBox(
            width: double.infinity,
            height: 350,
            child: CachedNetworkImage(
              imageUrl: product?.productImg ?? '',
              errorWidget: (_, u, e) => Image.asset(AssetImg.error),
              fit: BoxFit.cover,
            ),
          ),

          // status & masa aktif
          Positioned(
            bottom: 8,
            right: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //* masa aktif
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Consumer<ShopProvider>(builder: (_, c, child) {
                    final expiration =
                        c.getProductExpiration(c.product?.expiration);
                    return Text(
                      '$expiration Hari Lagi',
                    );
                  }),
                ),
                const SizedBox(width: 4),

                //* status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(product?.status ?? ''),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vendorTile(BuildContext context) {
    return Consumer<ShopProvider>(builder: (_, c, child) {
      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            //* logo vendor
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                backgroundImage:
                    CachedNetworkImageProvider(c.vendor?.logoUrl ?? ''),
              ),
            ),
            const SizedBox(width: 16),

            //* nama toko
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                c.vendor?.name ?? '',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 16),

            //* button kunjungi
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  To.VENDOR,
                  arguments: c.vendor?.id ?? 0,
                );
              },
              child: const Text('Kunjungi'),
            ),
          ],
        ),
      );
    });
  }
}
