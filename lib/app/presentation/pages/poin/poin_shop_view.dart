import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/enums/request_state.dart';
import '../../../core/utils/components/to_top_button.dart';
import '../../providers/shop_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/vendor_card.dart';

class PoinShopView extends StatefulWidget {
  const PoinShopView({super.key});

  @override
  State<PoinShopView> createState() => _PoinShopViewState();
}

class _PoinShopViewState extends State<PoinShopView> {
  final _scrollController = ScrollController();
  bool _showToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _loadData() async {
    await Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<ShopProvider>()
        ..getAllVendor()
        ..getAllProduct();
    });
  }

  void _scrollListener() {
    if (_scrollController.offset >= 300) {
      setState(() => _showToTop = true);
    } else {
      setState(() => _showToTop = false);
    }
  }

  void _toTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        child: Consumer<ShopProvider>(builder: (ctx, c, _) {
          return ListView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: const [
              _VendorViewState(),
              SizedBox(height: 16),
              _ProductViewState(),
            ],
          );
        }),
      ),
      floatingActionButton: _showToTop ? ToTopButton(_toTop) : null,
    );
  }
}

//* list vendor
class _VendorViewState extends StatelessWidget {
  const _VendorViewState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Vendor Pilihan',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 8),

        //* content
        Consumer<ShopProvider>(
          builder: (_, c, child) {
            if (c.getAllVendorState == RequestState.LOADING) {
              return _loadingState();
            } else if (c.getAllVendorState == RequestState.SUCCESS) {
              return _vendorList(c, context);
            } else {
              return _errorState(c, context);
            }
          },
        )
      ],
    );
  }

  Widget _vendorList(ShopProvider c, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(c.vendors.length, (index) {
          final vendor = c.vendors[index];
          final isLast = (vendor == c.vendors.last);
          return Padding(
            padding: isLast ? EdgeInsets.zero : const EdgeInsets.only(right: 8),
            child: VendorCard(vendor),
          );
        }),
      ),
    );
  }

  Widget _errorState(ShopProvider c, BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Center(
        child: Text(
          c.errorMessage ?? 'state tidak valid',
          textAlign: TextAlign.center,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.red),
        ),
      ),
    );
  }

  Widget _loadingState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(5, (index) {
          final isLast = (index == 4);
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 200,
              height: 100,
              margin: isLast ? null : const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(''),
            ),
          );
        }),
      ),
    );
  }
}

//* list product
class _ProductViewState extends StatelessWidget {
  const _ProductViewState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Semua Produk',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 8),

        //* content
        Consumer<ShopProvider>(
          builder: (_, c, child) {
            if (c.getAllProductState == RequestState.LOADING) {
              return _loadingState();
            } else if (c.getAllProductState == RequestState.SUCCESS) {
              return _productList(c);
            } else {
              return _errorState(c, context);
            }
          },
        )
      ],
    );
  }

  Widget _productList(ShopProvider c) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.9,
      ),
      itemCount: c.products.length,
      itemBuilder: (context, index) {
        final product = c.products[index];
        return ProductCard(product);
      },
    );
  }

  Widget _errorState(ShopProvider c, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 600,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          c.errorMessage ?? 'state tidak valid',
          textAlign: TextAlign.center,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.red),
        ),
      ),
    );
  }

  Widget _loadingState() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }
}
