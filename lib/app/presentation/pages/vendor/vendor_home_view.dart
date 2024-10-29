import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/enums/request_state.dart';
import '../../providers/shop_provider.dart';
import '../../widgets/product_card.dart';

class VendorHomeView extends StatelessWidget {
  const VendorHomeView(this.loadData, {super.key});

  final VoidCallback loadData;

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopProvider>(
      builder: (ctx, c, _) {
        if (c.getVendorByIdState == RequestState.LOADING) {
          return _loadingProducts();
        } else {
          if (c.vendor!.vendorProducts.isEmpty) {
            return const Center(
              child: Text('Vendor ini tidak memiliki produk'),
            );
          }
          return _vendorProducts(c);
        }
      },
    );
  }

  Widget _loadingProducts() {
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

  Widget _vendorProducts(ShopProvider c) {
    return RefreshIndicator(
      onRefresh: () async => loadData.call(),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.9,
        ),
        itemCount: c.vendor?.vendorProducts.length ?? 0,
        itemBuilder: (context, index) {
          final product = c.vendor!.vendorProducts[index];

          return ProductCard(product);
        },
      ),
    );
  }
}
