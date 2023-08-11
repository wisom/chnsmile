import 'package:chnsmile_flutter/flutter_sound/public/util/LogUtil.dart';
import 'package:chnsmile_flutter/model/student_leave_early_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

///学生早退-收到通知
class StudentLeaveEarlyNotifyCard extends StatelessWidget {
  final bool isTeacher;
  final String type;
  final StudentLeaveEarly item;
  final ValueChanged<StudentLeaveEarly> onCellClick;

  const StudentLeaveEarlyNotifyCard(
      {Key key, this.type, this.item, this.isTeacher, this.onCellClick})
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
              const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 8),
          child: Column(
            children: [
              _buildTop(),
              hiSpace(height: 8),
              _buildCenter(),
              hiSpace(height: 13),
              line(context),
              hiSpace(height: 9),
              _buildBottom()
            ],
          ),
        ));
  }

  _buildCenter() {
    return Row(
      children: [
        const Text(
          "请假事由： ",
          style: TextStyle(color: HiColor.color_181717_A50, fontSize: 12),
        ),
        Text(
          item.reason ?? "",
          style: const TextStyle(color: HiColor.color_black_A60, fontSize: 12),
        )
      ],
    );
  }

  _buildTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              (item.className ?? "") + "    " + (item.earlyStudentName??"")+"早退   "+_getStatusText(),
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: HiColor.color_181717),
            ),
          ],
        ),
        Container(
          height: 24,
          width: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: _getStatusColor(),
              borderRadius: BorderRadius.circular(12)),
          child: Text(
            _getStatusText(),
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        )
      ],
    );
  }

  ///列表类型 1.发起列表；2.审批列表；3.通知列表；4.备案修改
  Color _getStatusColor() {
    LogUtil.d(
        "学生早退",
        "getStatusColor type=" +
            type +
            " reviewStatus=" +
            (item.status ?? 0).toString());
    if (type == "2") {
      LogUtil.d("学生早退", "type == 2");
      return buildOAApplyStatus(item.status ?? 0)[0];
    } else if (type == "3") {
      return buildOAApplyNoticeStatus(item.status ?? 0)[0];
    } else if (type == "5") {
      return buildOAStatus(item.status ?? 0)[0];
    } else {
      LogUtil.d("学生早退", "type == other");
      return buildOAStatus(item.status ?? 0)[0];
    }
  }

  String _getStatusText() {
    LogUtil.d(
        "学生早退",
        "getStatusColor type=" +
            type +
            " reviewStatus=" +
            (item.status ?? 0).toString());
    if (type == "2") {
      LogUtil.d("学生早退", "type == 2");
      return buildOAApplyStatus(item.status ?? 0)[1];
    } else if (type == "3") {
      return buildOAApplyNoticeStatus(item.status ?? 0)[1];
    } else if (type == "5") {
      return buildOAStatus(item.status ?? 0)[1];
    } else {
      LogUtil.d("学生早退", "type == other");
      return buildOAStatus(item.status ?? 0)[1];
    }
  }

  _buildBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              "表单编号",
              style: TextStyle(fontSize: 12, color: HiColor.color_181717_A50),
            ),
            Text(
              "  " + item.formId ?? "",
              style: const TextStyle(fontSize: 12, color: HiColor.color_181717),
            ),
          ],
        ),
        Text(
          "通知日期 " +
              dateYearMothAndDay(
                  (item.createTime ?? "").replaceAll(".000", "")),
          style: const TextStyle(fontSize: 12, color: HiColor.color_181717_A50),
        )
      ],
    );
  }
}
