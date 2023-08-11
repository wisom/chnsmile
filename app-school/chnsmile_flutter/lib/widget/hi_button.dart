import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';

class HiButton extends StatelessWidget {
  final String title;
  final Color bgColor;
  final double height;
  final VoidCallback onPressed;
  final bool enabled;

  const HiButton(this.title,
      {Key key, this.bgColor, this.height = 40, this.onPressed, this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: InkWell(
      onTap: enabled ? onPressed : null,
      child: Container(
        height: height ?? 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: enabled ? (bgColor ?? primary) : Colors.grey[200],
            borderRadius: BorderRadius.circular(4)),
        child: Text(title,
            style: const TextStyle(fontSize: 13, color: Colors.white)),
      ),
    ));
  }
}
