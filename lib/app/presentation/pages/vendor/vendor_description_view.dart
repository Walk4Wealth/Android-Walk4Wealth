import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/shop_provider.dart';

class VendorDescriptionView extends StatelessWidget {
  const VendorDescriptionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopProvider>(
      builder: (ctx, c, _) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* tanggal dibuat
              _createdAt(c, context),
              const SizedBox(height: 8),

              //* deskripsi vendor
              _description(c),
            ],
          ),
        );
      },
    );
  }

  Widget _createdAt(ShopProvider c, BuildContext context) {
    return Text(
      'Dibuat pada ${DateFormat('dd MMMM yyyy', 'id').format(DateTime.parse(c.vendor?.createdAt ?? ''))}',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget _description(ShopProvider c) {
    return Text(
      c.vendor?.description ?? '',
      textAlign: TextAlign.justify,
    );
  }
}
