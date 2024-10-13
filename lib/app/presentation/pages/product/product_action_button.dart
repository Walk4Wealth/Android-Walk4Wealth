import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/components/w_button.dart';
import '../../providers/user_provider.dart';
import '../../providers/transaction_provider.dart';

class ProductActionButton extends StatelessWidget {
  const ProductActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          //* poin saya
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<UserProvider>(
              builder: (_, c, child) {
                return Text.rich(
                  TextSpan(
                    text: 'Poin Kamu ',
                    children: [
                      TextSpan(
                        text: '\n${c.user?.totalPoints ?? 0}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
          ),

          //* button reedem poin
          Flexible(
            fit: FlexFit.tight,
            child: WButton(
              expand: true,
              label: 'Tukar Poin',
              onPressed: () async {
                context.read<TransactionProvider>().showReedemDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
