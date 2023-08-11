import 'package:chnsmile_flutter/model/teacher_performance2_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class TeacherPerformance2Card extends StatelessWidget {
  final TeacherPerformance2 item;
  final ValueChanged<TeacherPerformance2> onCellClick;

  const TeacherPerformance2Card({Key key, this.item, this.onCellClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onCellClick(item);
        },
        child: Container(
          decoration: BoxDecoration(border: borderLine(context)),
          padding:
              const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
          child: Column(
            children: [_buildTop(), hiSpace(height: 10), _buildContent(), hiSpace(height: 10), _buildTime()],
          ),
        ));
  }

  _buildTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: Text(
          item.studentName ?? '',
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
        item.status == 1
            ? buildReadUnReadStatus('已发布', Colors.green)
            : buildReadUnReadStatus('未发布', Colors.grey)
      ],
    );
  }

  // Text.rich(TextSpan(children: [
  // TextSpan(
  // text: item.attend??'',
  // style:
  // const TextStyle(fontSize: 15, color: HiColor.dark_text)),
  // ])),

  _buildContent() {
    return Container(
        alignment: Alignment.centerLeft,
        child: Text(item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Colors.black)));
  }

  _buildTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('发布人:${item.teacherName ?? ''}',
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        item.status == 1 ? Text('发布时间:${item.publishTime != null ? dateYearMothAndDayAndMinutes(item.publishTime.replaceAll(".000", "")): ""}',
            style: const TextStyle(fontSize: 12, color: Colors.grey)) : Container(),
      ],
    );
  }
}
