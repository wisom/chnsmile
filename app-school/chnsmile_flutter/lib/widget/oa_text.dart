import 'package:chnsmile_flutter/widget/wxtext.dart';
import 'package:flutter/material.dart';

class OAText extends StatelessWidget {
  final String title;

  const OAText(this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      margin: const EdgeInsets.only(top: 3),
      child: WXText(title,
          maxLines: 1,
          wxOverflow: WXTextOverflow.ellipsisMiddle,
          style: const TextStyle(fontSize: 13, color: Colors.black)),
    );
  }
}
