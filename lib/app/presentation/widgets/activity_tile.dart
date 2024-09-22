import 'package:flutter/material.dart';

class ActivityTile extends StatelessWidget {
  const ActivityTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //* konten
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              //* foto cuplikan rute
              Container(),

              //*
            ],
          ),
        ),

        //* divider
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            height: 1.5,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }
}
