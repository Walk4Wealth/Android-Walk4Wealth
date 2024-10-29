import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/components/w_button.dart';
import '../../../core/utils/components/w_text_field.dart';
import '../../providers/auth/register_provider.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* title
          _registerTitle(),
          const SizedBox(height: 32),

          //* form
          Consumer<RegisterProvider>(
            builder: (ctx, c, _) {
              return Form(
                key: c.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //* username
                    _usernameTextField(c, context),
                    const SizedBox(height: 24),

                    //* email
                    _emailTextField(c, context),
                    const SizedBox(height: 24),

                    //* password
                    _passwordTextField(c, context),
                    const SizedBox(height: 8),

                    //* password hint
                    // "Password setidaknya memuat 8 karakter"
                    _passwordHint()
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          //* next button
          _nextButton(context),
        ],
      ),
    );
  }

  Widget _registerTitle() {
    return const Text(
      'Buat Akun Kamu',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _usernameTextField(RegisterProvider c, BuildContext context) {
    return WTextField(
      label: 'Username',
      onChanged: c.setUsername,
      hint: 'Masukan username anda',
      controller: c.usernameController,
      keyboardType: TextInputType.name,
      validator: (value) => c.validate(value, 'Username'),
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(c.emailFNode);
      },
    );
  }

  Widget _emailTextField(RegisterProvider c, BuildContext context) {
    return WTextField(
      label: 'Email',
      onChanged: c.setEmail,
      focusNode: c.emailFNode,
      hint: 'Masukan email anda',
      controller: c.emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => c.validate(value, 'Email'),
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(c.passFNode);
      },
    );
  }

  Widget _passwordTextField(RegisterProvider c, BuildContext context) {
    return WTextField(
      label: 'Password',
      focusNode: c.passFNode,
      onChanged: c.setPassword,
      obscureText: c.hidePassword,
      controller: c.passController,
      hint: 'Masukan password anda',
      keyboardType: TextInputType.visiblePassword,
      validator: (value) => c.validate(value, 'Password'),
      suffix: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (chld, a) {
          return ScaleTransition(scale: a, child: chld);
        },
        child: GestureDetector(
          onTap: c.togglePassword,
          key: ValueKey<bool>(c.hidePassword),
          child: Icon(
            (c.hidePassword) ? Iconsax.eye_slash : Iconsax.eye,
          ),
        ),
      ),
      onFieldSubmitted: (_) {
        FocusScope.of(context).unfocus();
      },
    );
  }

  Widget _passwordHint() {
    return const Text(
      'Password setidaknya memuat 8 karakter',
      style: TextStyle(
        fontSize: 12,
        color: Colors.black54,
      ),
    );
  }

  Widget _nextButton(BuildContext context) {
    return Consumer<RegisterProvider>(
      builder: (_, c, child) {
        return WButton(
          label: 'Selanjutnya',
          onPressed:
              (c.isValidSubmitted) ? () => c.validateForm(context) : null,
        );
      },
    );
  }
}
