import 'package:flutter/material.dart';

import '../../../core/routes/navigate.dart';
import '../../../core/utils/dialog/w_dialog.dart';
import '../../../domain/usecases/auth/register_user.dart';

class RegisterProvider extends ChangeNotifier {
  final RegisterUser _registerUser;

  RegisterProvider({
    required RegisterUser registerUser,
  }) : _registerUser = registerUser;

  //! controller
  final _pageController = PageController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get usernameController => _usernameController;
  PageController get pageController => _pageController;
  TextEditingController get passController => _passController;

  //! form key
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  //! focus node (email & password)
  final _emailFNode = FocusNode();
  final _passFNode = FocusNode();

  FocusNode get emailFNode => _emailFNode;
  FocusNode get passFNode => _passFNode;

  //! height & weight
  int _currentHeight = 170; // in cm
  int _currentWeight = 70; // in kg

  int get currentHeight => _currentHeight;
  int get currentWeight => _currentWeight;

  //! temp form value
  String? _usernameValue;
  String? _emailValue;
  String? _passValue;

  //! hide password toggle
  bool _hidePassword = true;
  bool get hidePassword => _hidePassword;

  //! total view in register view page
  // register / height / weight view
  int totalViews = 3;
  int _indexView = 0;
  int get indexView => _indexView;

  //! is valid submitted
  bool get isValidSubmitted {
    return (_usernameValue != null) &&
        (_emailValue != null) &&
        (_passValue != null);
  }

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
        movePage(0); // register view
      },
      (_) async {
        WDialog.closeLoading();

        // action
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            To.LOGIN,
            (route) => route.isFirst,
          );
          WDialog.snackbar(
            context,
            seconds: 5,
            type: SnackBarType.NORMAL,
            title: 'Registrasi berhasil',
            message:
                'Akun dengan email $email berhasil didaftarkan, silahkan login untuk melanjutkan',
          );
        }
      },
    );
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
      WDialog.snackbar(
        context,
        title: 'Input tidak valid',
        type: SnackBarType.ERROR,
        message: 'Perhatikan kesalahan pada Form',
      );
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

  void movePage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
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
