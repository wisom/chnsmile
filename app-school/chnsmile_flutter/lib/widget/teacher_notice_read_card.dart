import 'package:chnsmile_flutter/model/notice_read_model.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';

class TeacherNoticeReadCard extends StatelessWidget {
  final Read item;

  const TeacherNoticeReadCard({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(border: borderLine(context)),
          padding:
              const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
          child: Column(
            children: [_buildContent()],
          ),
        ));
  }

  _buildContent() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(item.studentName ?? '',
              style: const TextStyle(fontSize: 15, color: Colors.black87)),
          hiSpace(width: 10),
          Row(
            children: item.parentInfoList.map((item) {
              return Text(item.parentName + '-' + item.relation, style: const TextStyle(fontSize: 13, color: Colors.grey));
            })?.toList() ??
                [],
          )
        ],
      ),
    );
  }
}
