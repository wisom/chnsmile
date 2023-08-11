import 'package:chnsmile_flutter/widget/hi_button.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';

class OASubmitButton extends StatelessWidget {
  final VoidCallback onSavePressed;
  final VoidCallback onSubmitPressed;
  final bool enabled;
  final bool leftEnabled;
  final String leftText;
  final String rightText;

  const OASubmitButton(
      {Key key,
      this.onSavePressed,
      this.onSubmitPressed,
      this.enabled = true,
      this.leftEnabled = true,
      this.leftText,
      this.rightText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          HiButton(leftText ?? "保存", bgColor: Colors.green, enabled: leftEnabled, onPressed: onSavePressed),
          hiSpace(width: 20),
          HiButton(rightText ?? "发布", onPressed: onSubmitPressed)
        ],
      ),
    );
  }
}
