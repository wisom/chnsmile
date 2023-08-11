import 'package:chnsmile_flutter/model/contact_depart_model.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/hi_badge.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/string_util.dart';

class ContactDepartCard extends StatelessWidget {
  final DeptInfo item;

  const ContactDepartCard({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // 打开聊天页面
          // BoostNavigator.instance.push(HiConstant.webview + item.url);
        },
        child: Container(
          decoration: BoxDecoration(border: borderLine(context)),
          child: Column(
            children: [_buildContent()],
          ),
        ));
  }

  _buildContent() {
    return ListTile(
        leading: Checkbox(value: false, onChanged: (value) {

        }),
        title: Text(
          _buildTeachName(),
          style: const TextStyle(fontSize: 13, color: Colors.black),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded,
            size: 16, color: Colors.grey));
  }

  _buildTeachName() {
    String name = "";
    return name;
  }
}
