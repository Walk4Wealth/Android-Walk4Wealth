import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  // form key
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  // properti email
  String? _emailValue;
  String? get emailValue => _emailValue;

  final _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  // properti password
  String? _passValue;
  String? get passValue => _passValue;

  bool _hidePassword = true;
  bool get hidePassword => _hidePassword;

  final _passFNode = FocusNode();
  FocusNode get passFNode => _passFNode;

  final _passController = TextEditingController();
  TextEditingController get passController => _passController;

  bool _isError = false;
  bool get isError => _isError;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _passFNode.dispose();
    super.dispose();
  }

  //* login
  void login(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passController.text.trim();

    if (!_formKey.currentState!.validate()) {
      WDialog.snackbar(
        context,
        type: SnackBarType.ERROR,
        message: 'Perhatikan kesalahan pada Form',
      );
    } else {
      _setError(false);

      // loading
      WDialog.showLoading(context);

      // login
      final login = await _loginUser.call(email: email, password: password);

      // state
      login.fold(
        (failure) {
          _setError(true);
          WDialog.closeLoading();
          WDialog.snackbar(
            context,
            message: failure.message,
            type: SnackBarType.ERROR,
          );
        },
        (_) {
          _setError(false);
          WDialog.closeLoading();
          // get data
          context.read<UserProvider>().getProfile();
          Navigator.pushNamedAndRemoveUntil(
            context,
            To.MAIN,
            (route) => false,
          );
          WDialog.snackbar(context, message: 'Berhasil Masuk sebagai $email');
        },
      );
    }
  }

  bool get isValidSubmitted {
    return (_emailValue != null) && (_passValue != null);
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

  void _setError(bool error) {
    _isError = error;
    notifyListeners();
  }
}
