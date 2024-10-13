import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/enums/request_state.dart';
import '../../core/routes/navigate.dart';
import '../../core/utils/components/w_tab_bar.dart';
import '../../core/utils/strings/asset_img_string.dart';
import '../providers/shop_provider.dart';
import '../widgets/product_card.dart';

class VendorPage extends StatefulWidget {
  const VendorPage({super.key, required this.vendorId});

  final int vendorId;

  @override
  State<VendorPage> createState() => _VendorPageState();
}

class _VendorPageState extends State<VendorPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  _loadData() {
    context.read<ShopProvider>().getVendorById(widget.vendorId);
  }

  @override
  Widget build(BuildContext context) {
    double barHeight = 50;
    final headerHeight =
        MediaQuery.of(context).padding.top + kToolbarHeight + barHeight;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: kToolbarHeight + barHeight,
          title: Row(
            children: [
              //* logo vendor
              Consumer<ShopProvider>(builder: (ctx, c, _) {
                return CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  backgroundImage:
                      (c.getVendorByIdState == RequestState.SUCCESS)
                          ? CachedNetworkImageProvider(c.vendor?.logoUrl ?? '')
                          : null,
                );
              }),
              const SizedBox(width: 16),

              //* nama vendor
              Consumer<ShopProvider>(builder: (ctx, c, _) {
                if (c.getVendorByIdState == RequestState.LOADING) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 60,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  );
                } else {
                  return Text(
                    c.vendor?.name ?? '',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  );
                }
              }),
            ],
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: Column(
          children: [
            //* header background vendor
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: headerHeight,
                  child: Consumer<ShopProvider>(builder: (ctx, c, _) {
                    if (c.getVendorByIdState == RequestState.LOADING) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: double.infinity,
                          height: headerHeight,
                          color: Colors.grey.shade300,
                        ),
                      );
                    }
                    return CachedNetworkImage(
                      imageUrl: c.vendor?.logoUrl ?? '',
                      errorWidget: (_, __, ___) => Image.asset(AssetImg.error),
                      fit: BoxFit.cover,
                    );
                  }),
                ),
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: double.infinity,
                      height: headerHeight,
                      color: Colors.black26.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),

            //* tabbar
            const Material(
              color: Colors.white,
              child: WTabBar([
                Tab(text: 'Produk'),
                Tab(text: 'Tentang'),
              ]),
            ),

            //* vendor view
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  //* list product
                  Consumer<ShopProvider>(
                    builder: (ctx, c, _) {
                      if (c.getVendorByIdState == RequestState.LOADING) {
                        return _loadingProductList();
                      } else {
                        if (c.vendor!.vendorProducts.isEmpty) {
                          return const Center(
                            child: Text('Vendor ini tidak memiliki produk'),
                          );
                        }
                        return RefreshIndicator(
                          onRefresh: () async => _loadData(),
                          child: GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.9,
                            ),
                            itemCount: c.vendor?.vendorProducts.length ?? 0,
                            itemBuilder: (context, index) {
                              final product = c.vendor!.vendorProducts[index];
                              return ProductCard(product, onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  To.PRODUCT,
                                  arguments: {
                                    'product_id': product.id,
                                    'vendor_id': product.vendorId,
                                  },
                                );
                              });
                            },
                          ),
                        );
                      }
                    },
                  ),

                  //* desktripsi vendor
                  Consumer<ShopProvider>(
                    builder: (ctx, c, _) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (c.getVendorByIdState ==
                                RequestState.LOADING) ...[
                              Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                            ] else ...[
                              Text(
                                'Dibuat pada ${DateFormat('dd MMMM yyyy', 'id').format(DateTime.parse(c.vendor?.createdAt ?? ''))}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                            const SizedBox(height: 8),
                            Text(
                              c.vendor?.description ?? '',
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadingProductList() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.9,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Card(
            elevation: 0,
            color: Colors.grey.shade300,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }
}
