import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../injection.dart';
import '../../core/utils/components/w_button.dart';
import '../../core/utils/components/w_text_field.dart';
import '../providers/auth/login_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<LoginProvider>(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // back arrow
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

                // ilustrasi login
                const Text(
                  'Masuk ke W4W',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),

                // form
                Consumer<LoginProvider>(
                  builder: (_, c, child) {
                    return Form(
                      key: c.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // email
                          WTextField(
                            label: 'Email',
                            isError: c.isError,
                            validator: c.validate,
                            hint: 'Masukan email anda',
                            controller: c.emailController,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: c.setEmail,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(c.passFNode);
                            },
                          ),
                          const SizedBox(height: 24),

                          // password
                          WTextField(
                            label: 'Password',
                            isError: c.isError,
                            focusNode: c.passFNode,
                            obscureText: c.hidePassword,
                            controller: c.passController,
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
                          (c.isValidSubmitted) ? () => c.login(context) : null,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
