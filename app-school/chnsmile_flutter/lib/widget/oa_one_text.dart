import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';

class OAOneText extends StatelessWidget {
  final String tips;
  final String content;
  final Color tipColor;
  final FontWeight tipFontWeight;
  final Color contentColor;
  final double height;

  OAOneText(this.tips, this.content,
      {Key key, this.contentColor = Colors.black, this.height = 34,this.tipColor = Colors.grey,this.tipFontWeight=FontWeight.normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Row(
        children: [
          Text(tips ?? '',
              style: TextStyle(fontSize: 12, color: tipColor,fontWeight: tipFontWeight)),
          hiSpace(width: 0),
          Text(content ?? '',
              style: TextStyle(fontSize: 12, color: contentColor))
        ],
      ),
    );
  }
}
