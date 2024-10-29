import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../../../core/utils/components/w_button.dart';
import '../../providers/auth/register_provider.dart';

class RegisterWeightView extends StatelessWidget {
  const RegisterWeightView(this.rootContext, {super.key});

  final BuildContext rootContext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* weight title
          // "Berapa berat kamu"
          _weightTitle(),
          const SizedBox(height: 32),

          //* slider number (pilih berat badan)
          _weightSlider(),
          const SizedBox(height: 16),

          //* action button
          Row(
            children: [
              //* previous
              _previousButton(context),
              const SizedBox(width: 16),

              //* register
              _registerButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _weightTitle() {
    return FittedBox(
      child: RichText(
        text: const TextSpan(
          text: 'Berapa Berat Kamu ',
          style: TextStyle(
            fontSize: 32,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: '(Kg)',
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

  Widget _weightSlider() {
    return SizedBox(
      height: 400,
      child: Consumer<RegisterProvider>(
        builder: (_, c, child) {
          return WheelChooser.integer(
            onValueChanged: (weight) => c.setWeight(weight),
            maxValue: 200,
            minValue: 40,
            initValue: c.currentWeight,
            selectTextStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
  }

  Widget _registerButton(BuildContext context) {
    return Flexible(
      child: WButton(
        expand: true,
        label: 'Register',
        onPressed: () {
          context.read<RegisterProvider>().register(rootContext);
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
