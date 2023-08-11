import 'dart:async';

import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/model/contact_depart_model.dart';
import 'package:chnsmile_flutter/model/contact_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/hi_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

class TeacherUserContactCard extends StatefulWidget {
  final UserInfo item;
  final String pid;

  const TeacherUserContactCard({Key key, this.item, this.pid}) : super(key: key);

  @override
  _TeacherUserContactCardState createState() => _TeacherUserContactCardState();
}

class _TeacherUserContactCardState extends State<TeacherUserContactCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // 打开聊天页面
        BoostNavigator.instance.push(HiConstant.chat + widget.item.userId + '&name=' + widget.item.userName);
        Future.delayed(const Duration(milliseconds: 800), () {
          BoostNavigator.instance.popUntil(route: "teacher_contact_page");
        });

      },
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        height: 50,
        decoration: BoxDecoration(border: borderLine(context)),
        child: _buildContent(),
      ),
    );
  }

  _buildContent() {
    return Row(
      children: [
        showAvatorIcon(
            width: 28,
            fontSize: 13,
            avatarImg: widget.item.avatarImg,
            name: widget.item.userName),
        hiSpace(width: 10),
        Expanded(
            child: Text(
              widget.item.userName,
              style: const TextStyle(fontSize: 13, color: Colors.black),
            )),
        const Icon(Icons.arrow_forward_ios_rounded,
            size: 16, color: Colors.grey)
      ],
    );
  }
}
