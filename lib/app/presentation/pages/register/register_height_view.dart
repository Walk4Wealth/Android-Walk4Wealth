import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../../../core/utils/components/w_button.dart';
import '../../providers/auth/register_provider.dart';

class RegisterHeightView extends StatelessWidget {
  const RegisterHeightView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* height title
          // "Berapa tinggi kamu"
          _heightTitle(),
          const SizedBox(height: 32),

          //* height slider
          _heightSlider(),
          const SizedBox(height: 16),

          //* action button
          Row(
            children: [
              //* previous button
              _previousButton(context),
              const SizedBox(width: 16),

              //* next button
              _nextButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heightTitle() {
    return FittedBox(
      child: RichText(
        text: const TextSpan(
          text: 'Berapa Tinggi Kamu ',
          style: TextStyle(
            fontSize: 32,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: '(Cm)',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heightSlider() {
    return SizedBox(
      height: 400,
      child: Consumer<RegisterProvider>(
        builder: (_, c, child) {
          return WheelChooser.integer(
            maxValue: 200,
            minValue: 120,
            initValue: c.currentHeight,
            onValueChanged: (height) => c.setHeight(height),
            selectTextStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
  }

  Widget _nextButton(BuildContext context) {
    return Flexible(
      child: WButton(
        expand: true,
        label: 'Selanjutnya',
        onPressed: () {
          context.read<RegisterProvider>().nextPage();
        },
      ),
    );
  }

  Widget _previousButton(BuildContext context) {
    return WButton(
      label: '',
      type: ButtonType.OUTLINED,
      onPressed: () {
        context.read<RegisterProvider>().previousPage();
      },
      child: const Icon(Icons.arrow_back),
    );
  }
}
