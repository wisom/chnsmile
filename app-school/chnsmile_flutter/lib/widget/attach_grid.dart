import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/model/attach.dart';
import 'package:chnsmile_flutter/widget/wxtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

class AttachGrid extends StatelessWidget {

  final List<Attach> items;

  const AttachGrid({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 6,
        childAspectRatio: 0.8,
        children: items.map((item) => _item(item)).toList()),
    );
  }

  Widget _item(Attach attach) {
    return GestureDetector(
      onTap: () {
        BoostNavigator.instance.push(HiConstant.attachment + attach.attachUrl + '&title=' + attach.origionName);
      },
      child: Column(
        children: [
          Image(
            image: _buildImage(attach),
            width: 40,
            height: 40,
          ),
          Container(
            width: 80,
            margin: const EdgeInsets.only(top: 3),
            child: WXText(attach.origionName,
                maxLines: 1,
                wxOverflow: WXTextOverflow.ellipsisMiddle,
                style: const TextStyle(fontSize: 13, color: Colors.black)),
          ),
        ],
      ),
    );
  }

  _buildImage(Attach attach) {
    if (attach.attachSuffix == 'xls') {
      return const AssetImage('images/icon_excel.png');
    } else if (attach.attachSuffix == 'pdf') {
      return const AssetImage('images/icon_pdf.png');
    } else if (attach.attachSuffix == 'doc' || attach.attachSuffix == 'docx') {
      return const AssetImage('images/icon_word.png');
    }


  }
}
