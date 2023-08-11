import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/model/attach.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/oa_attach_grid.dart';
import 'package:chnsmile_flutter/widget/wxtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class OAAttachList extends StatelessWidget {
  final String suffix;
  final String url;
  final String title;

  const OAAttachList({Key key, this.suffix, this.url, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BoostNavigator.instance.push(HiConstant.attachment + url  + '&title=' + title);
      },
      child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              buildAttachImage(suffix: suffix, url: url, width: 40),
              hiSpace(width: 10),
              Container(
                margin: const EdgeInsets.only(top: 3),
                child: WXText(title,
                    maxLines: 1,
                    wxOverflow: WXTextOverflow.ellipsisMiddle,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black)),
              )
            ],
          )),
    );
  }

  _buildImage() {
    if (suffix == 'xls') {
      return const AssetImage('images/icon_excel.png');
    } else if (suffix == 'pdf') {
      return const AssetImage('images/icon_pdf.png');
    } else if (suffix == 'doc' || suffix == 'docx') {
      return const AssetImage('images/icon_word.png');
    } else {
      return AssetImage('images/icon_word.png');
    }
  }
}
