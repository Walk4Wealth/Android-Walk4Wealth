import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../../../core/utils/components/w_button.dart';
import '../../providers/auth/register_provider.dart';

class HeightView extends StatelessWidget {
  const HeightView({super.key});

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
          ),
          const SizedBox(height: 32),

          // slider number
          SizedBox(
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
                  label: 'Selanjutnya',
                  onPressed: context.read<RegisterProvider>().nextPage,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
