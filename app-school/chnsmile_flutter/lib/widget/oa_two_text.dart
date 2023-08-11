import 'package:chnsmile_flutter/widget/oa_one_text.dart';
import 'package:flutter/material.dart';

class OATwoText extends StatelessWidget {
  final String tips1;
  final String content1;
  final String tips2;
  final String content2;
  final Color content1Color;
  final Color content2Color;
  final bool isLong;

  OATwoText(this.tips1, this.content1, this.tips2, this.content2,
      {Key key, this.content1Color = Colors.black, this.isLong = false, this.content2Color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: isLong ? 3 : 5,
            child: OAOneText(tips1, content1, contentColor: content1Color)),
        Expanded(
            flex: isLong ? 2: 4, child: OAOneText(tips2, content2, contentColor: content2Color))
      ],
    );
  }
}
