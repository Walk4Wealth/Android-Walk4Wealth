import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/navigate.dart';
import '../../../core/utils/components/w_tab_bar.dart';
import '../../providers/shop_provider.dart';
import '../../widgets/product_card.dart';

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
    final headerHeght =
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
              Consumer<ShopProvider>(builder: (_, c, child) {
                return CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  backgroundImage: CachedNetworkImageProvider(
                    c.vendor?.logoUrl ?? '',
                  ),
                );
              }),
              const SizedBox(width: 16),

              // nama vendor
              Consumer<ShopProvider>(builder: (_, c, child) {
                return Text(
                  c.vendor?.name ?? '',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600),
                );
              }),
            ],
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: Column(
          children: [
            // foto
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: headerHeght,
                  child: Consumer<ShopProvider>(builder: (_, c, child) {
                    return CachedNetworkImage(
                      imageUrl: c.vendor?.logoUrl ?? '',
                      fit: BoxFit.cover,
                    );
                  }),
                ),
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: double.infinity,
                      height: headerHeght,
                      color: Colors.black26.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),

            // view
            const Material(
              color: Colors.white,
              child: WTabBar([
                Tab(text: 'Produk'),
                Tab(text: 'Tentang'),
              ]),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Consumer<ShopProvider>(
                    builder: (_, c, child) {
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
                            }),
                      );
                    },
                  ),
                  Consumer<ShopProvider>(builder: (_, c, child) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dibuat pada ${DateFormat('dd MMMM yyyy', 'id').format(DateTime.parse(c.vendor?.createdAt ?? ''))}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            c.vendor?.description ?? '',
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
