import 'package:chnsmile_flutter/widget/hi_button.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';

class OASaveButton extends StatelessWidget {
  final VoidCallback onSavePressed;
  final bool enabled;
  final String leftText;

  const OASaveButton(
      {Key key,
      this.onSavePressed,
      this.enabled = true,
      this.leftText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          HiButton(leftText ?? "保存", bgColor: Colors.green, onPressed: onSavePressed),
        ],
      ),
    );
  }
}
