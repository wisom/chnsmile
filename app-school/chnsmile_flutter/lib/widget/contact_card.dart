import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/model/contact_model.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

import 'hi_badge.dart';

class ContactCard extends StatelessWidget {
  final Contact item;

  const ContactCard({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // 打开聊天页面
          print("url: ${HiConstant.chat + item.userId}");
          BoostNavigator.instance.push(
              HiConstant.chat + item.userId + '&name=' + item.teacherName);
        },
        child: Container(
          decoration: BoxDecoration(border: borderLine(context)),
          child: Column(
            children: [_buildContent()],
          ),
        ));
  }

  _itemImage() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            cachedImage(item.avatarImg,
                width: 40, height: 40, placeholder: "images/default_avator.png")
          ],
        ),
      ),
    );
  }

  _buildContent() {
    return Row(
      children: [
        Expanded(
            child: Row(
              children: [
                _itemImage(),
                Text(
                  _buildTeachName(),
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                ),
              ],
            )),
        Row(
          children: [
            item.unreadMsgNum != null && int.parse(item.unreadMsgNum) > 0
                ? HiBadge(unCountMessage: int.parse(item.unreadMsgNum) ?? 0) : Container(),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 15, color: Colors.grey),
            hiSpace(width: 10)
          ],
        )
      ],
    );
  }

  _buildTeachName() {
    String name = "";
    if (isNotEmpty(item.classGradeName)) {
      name += item.classGradeName;
    }

    if (isNotEmpty(item.className)) {
      name += item.className;
    }

    if (isNotEmpty(item.courseName)) {
      name += '${item.courseName}老师';
    }

    if (isNotEmpty(item.teacherName)) {
      name += ' - ${item.teacherName}';
    }

    return name;
  }
}
