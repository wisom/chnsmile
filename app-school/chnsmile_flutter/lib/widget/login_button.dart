import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';

class LoginButton extends StatelessWidget {
  final String title;
  final bool enable;
  final VoidCallback onPressed;
  final double height;

  const LoginButton(this.title, {Key key, this.height = 52, this.enable = true, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: MaterialButton(
        height: height,
        onPressed: enable ? onPressed : null,
        disabledColor: Colors.grey,
        color: primary,
        child: Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
