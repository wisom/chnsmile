import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';

class OAOneTextWrap extends StatelessWidget {
  final String tips;
  final String content;
  final Color tipColor;
  final FontWeight tipFontWeight;
  final Color contentColor;

  OAOneTextWrap(this.tips, this.content,
      {Key key, this.contentColor = Colors.black,this.tipColor = Colors.grey,this.tipFontWeight=FontWeight.normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Text(tips ?? '',
              style: TextStyle(fontSize: 12, color: tipColor,fontWeight: tipFontWeight)),
          hiSpace(width: 0),
          Expanded(child: Text(content ?? '',
              style: TextStyle(fontSize: 12, color: contentColor)))
        ],
      ),
    );
  }
}
