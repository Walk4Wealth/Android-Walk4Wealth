import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../../../core/utils/components/w_button.dart';
import '../../providers/auth/register_provider.dart';

class RegisterWeightView extends StatelessWidget {
  const RegisterWeightView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
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
          ),
          const SizedBox(height: 32),

          // slider number
          SizedBox(
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
          ),
          const SizedBox(height: 16),

          // button previous
          Row(
            children: [
              WButton(
                label: '',
                type: ButtonType.OUTLINED,
                onPressed: context.read<RegisterProvider>().previousPage,
                child: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: WButton(
                  expand: true,
                  label: 'Selesai',
                  onPressed: () {
                    context.read<RegisterProvider>().register(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
