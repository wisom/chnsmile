import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class EmptyView extends StatelessWidget {
  final Function onRefreshClick;
  final String emptyString;

  const EmptyView({Key key, this.onRefreshClick, this.emptyString = "暂时没有相关内容"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
                image: AssetImage("images/icon_empty_no_data.png"),
                width: 80,
                height: 80),
            hiSpace(height: 6),
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: emptyString,
                  style: const TextStyle(fontSize: 13, color: Colors.black54)),
              onRefreshClick != null
                  ? TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          onRefreshClick();
                        },
                      text: '点我刷新',
                      style: const TextStyle(
                          fontSize: 13,
                          color: primary,
                          decoration: TextDecoration.underline))
                  : TextSpan()
            ])),
          ],
        ));
  }
}
