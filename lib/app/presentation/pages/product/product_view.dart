import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/navigate.dart';
import '../../../core/utils/dialog/w_dialog.dart';
import '../../../core/utils/strings/asset_img_string.dart';
import '../../../domain/entity/product.dart';
import '../../providers/shop_provider.dart';

class ProductView extends StatefulWidget {
  const ProductView(this.product, {super.key});

  final Product? product;

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  bool _isLike = false;

  void _like() async {
    setState(() => _isLike = !_isLike);
    if (_isLike) {
      await Future.delayed(const Duration(milliseconds: 500), () {
        // ignore: use_build_context_synchronously
        WDialog.snackbar(
          // ignore: use_build_context_synchronously
          context,
          seconds: 2,
          message: '${widget.product?.name ?? ''} Ditambahkan ke Favorit',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // foto produk
        SizedBox(
          width: double.infinity,
          height: 350,
          child: Stack(
            children: [
              //* foto
              SizedBox(
                width: double.infinity,
                height: 350,
                child: CachedNetworkImage(
                  imageUrl: widget.product?.productImg ?? '',
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
                      child: Text(widget.product?.status ?? ''),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        //* konten produk
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // poin & icon favorite
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //* poin
                  Text('${widget.product?.pointsRequired ?? 0} Poin',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              )),

                  //* icon favorite
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (chld, a) {
                      return ScaleTransition(scale: a, child: chld);
                    },
                    child: GestureDetector(
                      onTap: _like,
                      key: ValueKey<bool>(_isLike),
                      child: Icon(
                        (_isLike) ? Iconsax.heart5 : Iconsax.heart,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // nama produk & stok
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //* nama produk
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      widget.product?.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),

                  //* stok
                  Text(
                    '${widget.product?.stock ?? 0} Stok Tersedia',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 4),

              //* deskripsi
              Text(
                widget.product?.description ?? '',
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
                    widget.product?.terms.length ?? 0,
                    (index) {
                      final term = widget.product?.terms[index];
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
              Consumer<ShopProvider>(builder: (_, c, child) {
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
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          backgroundImage: CachedNetworkImageProvider(
                              c.vendor?.logoUrl ?? ''),
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
              }),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ],
    );
  }
}
