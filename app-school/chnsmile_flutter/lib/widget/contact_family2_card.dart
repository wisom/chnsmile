import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/model/contact_family_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/base_expandable_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/view_util.dart';

typedef VoidCallback = void Function(String classId, String userId, bool isSelected);

class ContactFamily2Card extends StatefulWidget {
  final ClassInfo item;
  final List<StudentParentInfo> subItems;

  const ContactFamily2Card({Key key, this.item, this.subItems}) : super(key: key);

  @override
  _ContactFamily2CardState createState() => _ContactFamily2CardState();
}

class _ContactFamily2CardState extends BaseExpandableContentState<ContactFamily2Card> {

  @override
  double topHeight() {
    return 40;
  }

  @override
  double marginLR() {
    return 10;
  }

  @override
  buildContent() {
    if (widget.subItems == null) return Container();
    return Column(
      children: widget.subItems.asMap().entries.map((entry) {
      int index = entry.key;
      StudentParentInfo item = entry.value;
        return Container(
          height: 50,
          decoration: BoxDecoration(
            border: (index != widget.subItems.length - 1) ? borderLine(context) : const Border(bottom: BorderSide.none)
          ),
          child: InkWell(
            onTap: () {
              // 打开聊天页面
              BoostNavigator.instance.push(HiConstant.chat + item.userId + '&name=' + item.studentName);
            },
            child: Row(
              children: [
                hiSpace(width: 10),
                showAvatorIcon(avatarImg: item.avatarImg, name: item.studentName, width: 30, fontSize: 15),
                hiSpace(width: 10),
                Text('${item.studentName} - ${item.relations} (${item.parentName})', style: const TextStyle(fontSize: 13, color: Colors.black87))
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  buildTop() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            '${widget.item.classGradeName} ${widget.item.className}',
            style: const TextStyle(fontSize: 13, color: Colors.black),
          ),
        )
      ],
    );
  }
}
