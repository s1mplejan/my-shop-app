import 'package:flutter/material.dart';

class CustomCart extends StatelessWidget {
  const CustomCart({super.key, required this.child, required this.number});
  final Widget child;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          top: 15,
          right: 10,
          child: Container(
            alignment: Alignment.center,
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: Text(
              number,
              style: const TextStyle(fontSize: 10),
            ),
          ),
        )
      ],
    );
  }
}
