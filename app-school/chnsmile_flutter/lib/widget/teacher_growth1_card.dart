import 'package:chnsmile_flutter/model/teacher_growth1_model.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class TeacherGrowth1Card extends StatelessWidget {
  final TeacherGrowth1 item;
  final ValueChanged<TeacherGrowth1> onCellClick;

  const TeacherGrowth1Card({Key key, this.item, this.onCellClick})
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
              const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
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
          style: const TextStyle(fontSize: 15, color: Colors.black87),
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
        Text(item.classYear ?? '',
            style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }
}
