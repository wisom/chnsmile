import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/widget/oa_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

class OAAttachGrid extends StatelessWidget {
  final String suffix;
  final String url;
  final String title;
  final double width;

  const OAAttachGrid({Key key, this.suffix, this.url, this.title, this.width = 60})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BoostNavigator.instance.push(HiConstant.attachment + url + '&title=' + title);
      },
      child: Container(
          width: width,
          margin: const EdgeInsets.only(top: 3, right: 6),
          child: !isAudioType(suffix) ? Column(
            children: [
                buildAttachImage(width: width, suffix: suffix, url: url),
                OAText(title)
            ],
          ) : Container()),
    );
  }
}
