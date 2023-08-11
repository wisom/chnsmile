import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/model/contact_depart_model.dart';
import 'package:chnsmile_flutter/model/contact_model.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/hi_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

class TeacherDepContactCard extends StatefulWidget {
  final DeptInfo item;

  const TeacherDepContactCard({Key key, this.item}) : super(key: key);

  @override
  _TeacherDepContactCardState createState() => _TeacherDepContactCardState();
}

class _TeacherDepContactCardState extends State<TeacherDepContactCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          BoostNavigator.instance.push("teacher_contact_tab_page", arguments: {"pid": widget.item.id});
        },
        child: Container(
          height: 50,
          padding: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(border: borderLine(context)),
          child: _buildContent(),
        ));
  }

  _buildContent() {
    return Row(
      children: [
        Expanded(
            child: Text(
              widget.item.title,
              style: const TextStyle(fontSize: 13, color: Colors.black),
            )),
        const Icon(Icons.arrow_forward_ios_rounded,
            size: 16, color: Colors.grey)
      ],
    );
  }
}
