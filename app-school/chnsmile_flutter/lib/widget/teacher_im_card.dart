import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/model/contact_im_model.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/hi_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';
import 'package:hi_cache/hi_cache.dart';

class TeacherIMCard extends StatelessWidget {
  final ContactIM item;

  const TeacherIMCard({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // 打开聊天页面
          BoostNavigator.instance.push(HiConstant.chat + item.toUserId + '&name=' + item.showName);
        },
        child: Container(
          decoration: BoxDecoration(border: borderLine(context)),
          child: Column(
            children: [_buildContent()],
          ),
        ));
  }

  _itemImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(19),
      child: Stack(
        children: [
          cachedImage(item.toUserAvatarImg,
              width: 38, height: 38, placeholder: "images/default_avator.png")
        ],
      ),
    );
  }

  _buildContent() {
    return ListTile(
        leading: _itemImage(),
        title: Text(_buildName(),
            style: const TextStyle(fontSize: 13, color: Colors.black)),
        trailing: (item.unreadMsgNum != null && item.unreadMsgNum != "")
            ? HiBadge(unCountMessage: int.parse(item.unreadMsgNum) ?? 0)
            : const Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: Colors.grey));
  }

  bool get isTeacher {
    return HiCache.getInstance().get(HiConstant.spIdentity) == "2";
  }

  String _buildName() {
    String name = item.toUserName; // 消息列表显示的
    String showName = item.toUserName; // 聊天页面显示的
    if (isTeacher) {
      if (isNotEmpty(item.teacherName)) {
        name = "${item.toUserName}老师";
        showName = item.toUserName;
      }
      if (isNotEmpty(item.parentName)) {
        name = "${item.studentName.isNotEmpty ? item.studentName[0] : item.parentName} - 家长(${item.parentName})";
        showName = name;
      }
    } else {
      if (isNotEmpty(item.teacherName)) {
        name = "${item.toUserName}老师";
        showName = name;
      }
      if (isNotEmpty(item.parentName)) {
        name = "${item.toUserName}家长";
        showName = name;
      }
    }
    item.showName = showName;
    return name;
  }
}
