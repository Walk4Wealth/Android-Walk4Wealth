import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/enums/request_state.dart';
import '../../../core/routes/navigate.dart';
import '../../../core/utils/components/to_top_button.dart';
import '../../../core/utils/strings/asset_img_string.dart';
import '../../providers/transaction_provider.dart';

class TransactionHistoryListView extends StatefulWidget {
  const TransactionHistoryListView({super.key});

  @override
  State<TransactionHistoryListView> createState() =>
      _TransactionHistoryListViewState();
}

class _TransactionHistoryListViewState
    extends State<TransactionHistoryListView> {
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
    await context.read<TransactionProvider>().getHistoryTransaction();
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
        child: Consumer<TransactionProvider>(
          builder: (_, c, child) {
            if (c.getHistoryTransactionState == RequestState.LOADING) {
              return _loadingState();
            } else if (c.getHistoryTransactionState == RequestState.SUCCESS) {
              if (c.histories.isEmpty) {
                return _emptyState();
              } else {
                return _historyList(c);
              }
            } else {
              return _errorState(c.errorMessage ?? 'State tidak valid');
            }
          },
        ),
      ),
      floatingActionButton: _showToTop ? ToTopButton(_toTop) : null,
    );
  }

  Widget _historyList(TransactionProvider c) {
    return ListView.separated(
      itemCount: c.histories.length,
      separatorBuilder: (c, i) => const SizedBox(height: 8),
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final history = c.histories[index];
        return ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          leading: CachedNetworkImage(
            imageUrl: history.product.productImg ?? '',
            errorWidget: (c, u, e) => Image.asset(AssetImg.error),
            width: 50,
            fit: BoxFit.cover,
          ),
          title: Text(
            history.product.name ?? '',
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            DateFormat('dd/MM/yyyy HH:mm:ss a', 'id').format(
              DateTime.parse(history.timeStamp),
            ),
          ),
          titleTextStyle: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w500),
          trailing: Text('${history.product.pointsRequired ?? 0} Poin'),
          onTap: () {
            Navigator.pushNamed(
              context,
              To.TRANSACTION_DETAIL,
              arguments: history.product,
            );
          },
        );
      },
    );
  }

  Widget _errorState(String message) {
    return Center(
      child: Text(
        'Terjadi kesalahan [$message]',
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _emptyState() {
    return const SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.box),
            SizedBox(height: 8),
            Text('Anda belum pernah melakukan transaksi'),
          ],
        ),
      ),
    );
  }

  Widget _loadingState() {
    return ListView.separated(
      itemCount: 10,
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      separatorBuilder: (c, i) => const SizedBox(height: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Row(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              fit: FlexFit.tight,
              child: LayoutBuilder(builder: (_, size) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: size.maxWidth * 0.8,
                        height: 10,
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
                        width: size.maxWidth * 0.6,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
