import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../injection.dart';
import '../../providers/auth/register_provider.dart';
import 'height_view.dart';
import 'register_view.dart';
import 'weight_view.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<RegisterProvider>(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // back arrow and progress bar
              Consumer<RegisterProvider>(
                builder: (_, c, child) {
                  return _buildHeader(
                    totalViews: c.totalViews,
                    currentView: (c.indexView + 1),
                    backOnTap: () => Navigator.pop(context),
                  );
                },
              ),
              const SizedBox(height: 16),

              // view registrasi (input )
              Expanded(
                child: Consumer<RegisterProvider>(
                  builder: (_, c, child) {
                    return PageView(
                      controller: c.pageController,
                      onPageChanged: c.setViewOnChanged,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        RegisterView(),
                        HeightView(),
                        WeightView(),
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

  Widget _buildHeader({
    required int currentView,
    required int totalViews,
    required void Function() backOnTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // tombol back
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

          // progress bar
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

          // text langkah
          Text(
            'Langkah $currentView/$totalViews',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
