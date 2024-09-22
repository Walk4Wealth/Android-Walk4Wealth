import 'package:flutter/material.dart';

class PanelDragHandle extends StatelessWidget {
  const PanelDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 24,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      child: Center(
        child: Container(
          width: 50,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}
