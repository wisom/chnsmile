import 'package:chnsmile_flutter/model/teacher_performance1_model.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class TeacherPerformance1Card extends StatelessWidget {
  final TeacherPerformance1 item;
  final ValueChanged<TeacherPerformance1> onCellClick;

  const TeacherPerformance1Card({Key key, this.item, this.onCellClick})
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
            children: [_buildContent(), hiSpace(height: 10), _buildTime()],
          ),
        ));
  }

  _buildContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: Text(
          item.label ?? '',
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
        Container(
          alignment: Alignment.center,
          width: 40,
          height: 26,
          decoration: const BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.all(Radius.circular(13))),
          child: const Text('查看',
              style: TextStyle(fontSize: 12, color: Colors.white)),
        ),
      ],
    );
  }

  _buildTime() {
    return Row(
      children: [
        Text(item.operateDate ?? '',
            style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }
}
