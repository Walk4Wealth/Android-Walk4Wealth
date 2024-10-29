import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../injection.dart';
import '../../providers/auth/register_provider.dart';
import 'register_height_view.dart';
import 'register_view.dart';
import 'register_weight_view.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late BuildContext rootContext;

  @override
  Widget build(BuildContext context) {
    rootContext = context;

    return ChangeNotifierProvider(
      create: (_) => locator<RegisterProvider>(),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* back arrow and progress bar
              Consumer<RegisterProvider>(
                builder: (_, c, child) {
                  return _buildHeader(
                    context,
                    totalViews: c.totalViews,
                    currentView: (c.indexView + 1),
                    backOnTap: () => Navigator.pop(context),
                  );
                },
              ),
              const SizedBox(height: 16),

              //* view registrasi
              Expanded(
                child: Consumer<RegisterProvider>(
                  builder: (_, c, child) {
                    return PageView(
                      controller: c.pageController,
                      onPageChanged: c.setViewOnChanged,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const RegisterView(),
                        const RegisterHeightView(),
                        RegisterWeightView(rootContext),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //* header
  Widget _buildHeader(
    BuildContext context, {
    required int currentView,
    required int totalViews,
    required void Function() backOnTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          //* tombol back
          Material(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(100),
            child: InkWell(
              onTap: backOnTap,
              borderRadius: BorderRadius.circular(100),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          const SizedBox(width: 16),

          //* progress bar
          Flexible(
            child: LayoutBuilder(
              builder: (_, size) {
                return Stack(
                  children: [
                    // background
                    Container(
                      height: 8,
                      width: size.maxWidth,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),

                    // progress
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: 8,
                      width: size.maxWidth * currentView / totalViews,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: 16),

          //* text langkah
          Text(
            'Langkah $currentView/$totalViews',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
