import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../core/utils/components/w_button.dart';
import '../../core/utils/components/w_text_field.dart';
import '../providers/auth/login_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _passFNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _passFNode.dispose();
    super.dispose();
  }

  //* login
  void _login(BuildContext context) async {
    await context.read<LoginProvider>().login(
          context,
          isValidate: _formKey.currentState!.validate(),
          email: _emailController.text.trim(),
          password: _passController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* back arrow
              Material(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(100),
                child: InkWell(
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  borderRadius: BorderRadius.circular(100),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              //* ilustrasi login
              const Text(
                'Masuk ke W4W',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),

              //* form
              Consumer<LoginProvider>(
                builder: (_, c, child) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //* email
                        WTextField(
                          label: 'Email',
                          validator: c.validate,
                          hint: 'Masukan email anda',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: c.setEmail,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_passFNode);
                          },
                        ),
                        const SizedBox(height: 24),

                        //* password
                        WTextField(
                          label: 'Password',
                          focusNode: _passFNode,
                          obscureText: c.hidePassword,
                          controller: _passController,
                          hint: 'Masukan password anda',
                          keyboardType: TextInputType.visiblePassword,
                          suffix: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (chld, a) {
                              return ScaleTransition(scale: a, child: chld);
                            },
                            child: GestureDetector(
                              onTap: c.togglePassword,
                              key: ValueKey<bool>(c.hidePassword),
                              child: Icon(
                                (c.hidePassword)
                                    ? Iconsax.eye_slash
                                    : Iconsax.eye,
                              ),
                            ),
                          ),
                          onChanged: c.setPassword,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // button login
              Consumer<LoginProvider>(
                builder: (_, c, chld) {
                  return WButton(
                    expand: true,
                    label: 'Login',
                    onPressed:
                        c.isValidSubmitted ? () => _login(context) : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
