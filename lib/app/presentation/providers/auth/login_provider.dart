import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../activity_provider.dart';
import '../user_provider.dart';
import '../../../core/routes/navigate.dart';
import '../../../core/utils/dialog/w_dialog.dart';
import '../../../domain/usecases/auth/login_user.dart';

class LoginProvider extends ChangeNotifier {
  // use case
  final LoginUser _loginUser;

  LoginProvider({
    required LoginUser loginUser,
  }) : _loginUser = loginUser;

  String? _emailValue;
  String? get emailValue => _emailValue;

  String? _passValue;
  String? get passValue => _passValue;

  bool _hidePassword = true;
  bool get hidePassword => _hidePassword;

  bool get isValidSubmitted => (_emailValue != null) && (_passValue != null);

  //* login
  Future<void> login(
    BuildContext context, {
    required bool isValidate,
    required String email,
    required String password,
  }) async {
    // jika masih terdapat kesalahan pada form
    if (!isValidate) {
      WDialog.snackbar(
        context,
        type: SnackBarType.ERROR,
        message: 'Perhatikan kesalahan pada Form',
      );
      return;
    }

    // loading
    WDialog.showLoading(context);

    // login
    final login = await _loginUser.call(email: email, password: password);

    // state
    login.fold(
      (failure) {
        WDialog.closeLoading();
        WDialog.showDialog(
          context,
          icon: const Icon(Icons.warning_amber_rounded),
          title: 'Terjadi kesalahan',
          message: failure.message,
          actions: [
            DialogAction(
              label: 'Coba lagi',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
      (_) {
        WDialog.closeLoading();
        // get data
        context.read<UserProvider>().getProfile();
        context.read<ActivityProvider>().getActivity();
        Navigator.pushNamedAndRemoveUntil(
          context,
          To.MAIN,
          (route) => false,
        );
        WDialog.snackbar(context, message: 'Berhasil Masuk sebagai $email');
      },
    );
  }

  String? validate(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      return 'Format Email tidak valid';
    }

    return null;
  }

  void setEmail(String value) {
    _emailValue = (value.isEmpty) ? null : value;
    notifyListeners();
  }

  void setPassword(String value) {
    _passValue = (value.isEmpty) ? null : value;
    notifyListeners();
  }

  void togglePassword() {
    _hidePassword = !_hidePassword;
    notifyListeners();
  }
}
