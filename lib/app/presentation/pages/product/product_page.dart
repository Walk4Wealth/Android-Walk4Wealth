// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/enum/request_state.dart';
import '../../../core/utils/components/w_app_bar.dart';
import '../../../core/utils/components/w_button.dart';
import '../../providers/shop_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/user_provider.dart';
import 'product_view.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    super.key,
    required this.idProduct,
    required this.idVendor,
  });

  final int idProduct;
  final int idVendor;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    // get product
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<ShopProvider>()
        ..getProductById(widget.idProduct)
        ..getVendorById(widget.idVendor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleWidget: LayoutBuilder(builder: (_, size) {
          return Consumer<ShopProvider>(
            builder: (_, c, child) {
              if (c.getProductByIdState == RequestState.SUCCESS) {
                return Text(c.product?.name ?? '');
              } else {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: size.maxWidth * 0.9,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                );
              }
            },
          );
        }),
        actions: [
          GestureDetector(child: const Icon(Icons.more_vert)),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        child: SingleChildScrollView(
          child: Consumer<ShopProvider>(
            builder: (_, c, child) {
              if (c.getProductByIdState == RequestState.LOADING) {
                return _loadingState();
              } else if (c.getProductByIdState == RequestState.SUCCESS) {
                return ProductView(c.product);
              } else {
                return _errorState(c.errorMessage ?? 'State tidak valid');
              }
            },
          ),
        ),
      ),
      bottomSheet: Container(
        padding: Platform.isIOS
            ? EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom)
            : null,
        child: Row(
          children: [
            // poin saya
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<UserProvider>(
                builder: (_, c, child) {
                  return Text.rich(TextSpan(
                    text: 'Poin Kamu ',
                    children: [
                      TextSpan(
                        text: '\n${c.user?.totalPoints ?? 0}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ));
                },
              ),
            ),

            // button reedem poin
            Flexible(
              fit: FlexFit.tight,
              child: WButton(
                expand: true,
                label: 'Tukar Poin',
                onPressed: () {
                  context.read<TransactionProvider>().showReedemDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorState(String message) {
    return Center(
      child: Text(message),
    );
  }

  Widget _loadingState() {
    return Column(
      children: [
        // shimmer foto
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: double.infinity,
            height: 350,
            color: Colors.grey.shade300,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // shimmer poin
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // shimmer nama produk & stok
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // shimmer toko
              Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
