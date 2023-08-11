import 'package:flutter/material.dart';

class Star extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 2),
      child: const Icon(Icons.star, color: Colors.red, size: 10),
    );
  }
}
