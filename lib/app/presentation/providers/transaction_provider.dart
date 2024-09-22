import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/enum/request_state.dart';
import '../../core/routes/navigate.dart';
import '../../core/utils/components/w_button.dart';
import '../../domain/entity/history.dart';
import '../../domain/usecases/point/get_history_transaction.dart';
import '../../domain/usecases/point/reedem_point.dart';
import '../widgets/confirm_reedem_bottom_sheet.dart';
import 'shop_provider.dart';
import 'user_provider.dart';

class TransactionProvider extends ChangeNotifier {
  // use case
  final ReedemPoint _reedemPoint;
  final GetHistoryTransaction _getHistoryTransaction;

  TransactionProvider({
    required ReedemPoint reedemPoint,
    required GetHistoryTransaction getHistoryTransaction,
  })  : _reedemPoint = reedemPoint,
        _getHistoryTransaction = getHistoryTransaction;

  late RequestState _reedemPoinState;
  RequestState get reedemPoinState => _reedemPoinState;

  RequestState _getHistoryTransactionState = RequestState.LOADING;
  RequestState get getHistoryTransactionState => _getHistoryTransactionState;

  var _histories = <History>[];
  List<History> get histories => _histories;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  //* dialog konfirmasi
  void showReedemDialog(BuildContext context) async {
    // inisiasi state
    _reedemPoinState = RequestState.INIT;
    notifyListeners();

    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 400),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      builder: (context) {
        return ConfirmReedemBottomSheet(action: [
          WButton(
            label: 'Batal',
            padding: 12,
            type: ButtonType.OUTLINED,
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Flexible(
            fit: FlexFit.tight,
            child: WButton(
              expand: true,
              padding: 12,
              label: 'Tukar',
              onPressed: () {
                final userId = context.read<UserProvider>().user?.id;
                final productId = context.read<ShopProvider>().product?.id;
                _reedem(context, userId ?? 0, productId ?? 0);
              },
            ),
          ),
        ]);
      },
    );
  }

  //* reedem point
  void _reedem(
    BuildContext context,
    int userId,
    int productId,
  ) async {
    // loading
    _reedemPoinState = RequestState.LOADING;
    notifyListeners();

    // reedem point
    final reedemPoint = await _reedemPoint.call(
      userId: userId,
      productId: productId,
    );

    // state
    reedemPoint.fold(
      (failure) {
        log('gagal melakukan reedem point [${failure.message}]');
        _reedemPoinState = RequestState.FAILURE;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (_) {
        _reedemPoinState = RequestState.SUCCESS;
        notifyListeners();

        // update user diperlukan ketika reedem poin berhasil
        // untuk mendapat poin user yang sekarang
        context.read<UserProvider>().updateProfile();

        // pesan
        log('sukses melakukan reedem point');
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(
          context,
          To.REEDEM_STATUS,
          (route) => route.isFirst,
        );
      },
    );
  }

  //* get history transaction
  Future<void> getHistoryTransaction() async {
    // loading
    _getHistoryTransactionState = RequestState.LOADING;
    notifyListeners();

    // get all history
    final allHistory = await _getHistoryTransaction.call();

    // state
    allHistory.fold(
      (failure) {
        log('data riwayat transaksi gagal di get [${failure.message}]');
        _getHistoryTransactionState = RequestState.FAILURE;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (histories) {
        log('data riwayat transaksi berhasil di get');
        _getHistoryTransactionState = RequestState.SUCCESS;
        _histories = histories;
        notifyListeners();
      },
    );
  }
}
