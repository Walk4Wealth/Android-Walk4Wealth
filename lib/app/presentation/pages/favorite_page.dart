import 'package:flutter/material.dart';

import '../../core/utils/components/w_app_bar.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: WAppBar(title: 'Produk yang kamu sukai'),
    );
  }
}
