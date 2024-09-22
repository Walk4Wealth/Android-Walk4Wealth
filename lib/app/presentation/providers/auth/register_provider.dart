import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../user_provider.dart';
import '../../../core/routes/navigate.dart';
import '../../../core/utils/dialog/w_dialog.dart';
import '../../../domain/usecases/auth/register_user.dart';

class RegisterProvider extends ChangeNotifier {
  final RegisterUser _registerUser;

  RegisterProvider({
    required RegisterUser registerUser,
  }) : _registerUser = registerUser;

  final _pageController = PageController();
  PageController get pageController => _pageController;

  final _usernameController = TextEditingController();
  TextEditingController get usernameController => _usernameController;

  final _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final _passController = TextEditingController();
  TextEditingController get passController => _passController;

  String? _usernameValue;
  String? _emailValue;
  String? _passValue;

  int _currentHeight = 170;
  int get currentHeight => _currentHeight;

  int _currentWeight = 70;
  int get currentWeight => _currentWeight;

  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  final _emailFNode = FocusNode();
  FocusNode get emailFNode => _emailFNode;

  final _passFNode = FocusNode();
  FocusNode get passFNode => _passFNode;

  bool _hidePassword = true;
  bool get hidePassword => _hidePassword;

  int totalViews = 3;
  int _indexView = 0;
  int get indexView => _indexView;

  @override
  void dispose() {
    _pageController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _emailFNode.dispose();
    _passFNode.dispose();
    super.dispose();
  }

  //* register
  void register(BuildContext context) async {
    final username = _usernameController.text;
    final email = _emailController.text.trim();
    final password = _passController.text.trim();
    final weight = _currentWeight;
    final height = _currentHeight;

    // loading
    WDialog.showLoading(context);

    // register
    final register = await _registerUser.call(
      email: email,
      username: username,
      password: password,
      weight: weight,
      height: height,
    );

    // state
    register.fold(
      (failure) {
        WDialog.closeLoading();
        WDialog.snackbar(context, message: failure.message);
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      },
      (_) {
        WDialog.closeLoading();
        // get data
        context.read<UserProvider>().getProfile();
        Navigator.pushNamedAndRemoveUntil(
          context,
          To.MAIN,
          (route) => false,
        );
        WDialog.snackbar(
          context,
          seconds: 5,
          message: 'Berhasil membuat akun dan masuk sebagai $email',
        );
      },
    );
  }

  bool get isValidSubmitted {
    return (_usernameValue != null) &&
        (_emailValue != null) &&
        (_passValue != null);
  }

  String? validate(String? value, String title) {
    if (value == null || value.isEmpty) {
      return '$title tidak boleh kosong';
    }

    if (title == 'Username') {
      // Cek panjang username
      if (value.length < 3 || value.length > 20) {
        return '$title harus memiliki panjang antara 3 hingga 20 karakter';
      }

      // Cek jika mengandung spasi
      if (value.contains(' ')) {
        return '$title tidak boleh mengandung spasi';
      }

      // Cek jika hanya mengandung huruf, angka, dan underscore
      final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
      if (!usernameRegex.hasMatch(value)) {
        return '$title hanya boleh mengandung (huruf, angka, _)';
      }
    }

    if (title == 'Email') {
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      if (!emailRegex.hasMatch(value)) {
        return 'Format $title tidak valid';
      }
    }

    if (title == 'Password') {
      // Minimal 8 karakter
      if (value.length < 8) {
        return '$title harus memiliki minimal 8 karakter';
      }

      // Minimal harus mengandung satu karakter selain huruf
      final hasNonLetter = value.contains(RegExp(r'[^a-zA-Z]'));
      if (!hasNonLetter) {
        return '$title harus mengandung satu karakter unik';
      }
    }
    return null;
  }

  void validateForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      nextPage();
    } else {
      WDialog.snackbar(context, message: 'Perhatikan kesalahan pada Form');
    }
  }

  void setViewOnChanged(int view) {
    _indexView = view;
    notifyListeners();
  }

  void setUsername(String value) {
    _usernameValue = (value.isNotEmpty) ? value : null;
    notifyListeners();
  }

  void setEmail(String value) {
    _emailValue = (value.isNotEmpty) ? value : null;
    notifyListeners();
  }

  void setPassword(String value) {
    _passValue = (value.isNotEmpty) ? value : null;
    notifyListeners();
  }

  void togglePassword() {
    _hidePassword = !_hidePassword;
    notifyListeners();
  }

  void setHeight(dynamic height) {
    _currentHeight = height;
    notifyListeners();
  }

  void setWeight(dynamic height) {
    _currentWeight = height;
    notifyListeners();
  }

  void nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  void previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }
}
