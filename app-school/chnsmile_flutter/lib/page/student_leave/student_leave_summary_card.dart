import 'package:chnsmile_flutter/flutter_sound/public/util/LogUtil.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';
import '../../model/student_leave_model.dart';

///学生请假-缺勤汇总
class StudentLeaveSumaryCard extends StatelessWidget {
  final String type;
  final StudentLeave item;
  final ValueChanged<StudentLeave> onCellClick;

  const StudentLeaveSumaryCard(
      {Key key, this.type, this.item, this.onCellClick})
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
              hiSpace(height: 14),
              _buildCenter(),
              hiSpace(height: 19),
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
        Text(
          "班主任   "+(item.headTeacherName ?? "")+"   本班",
          style: const TextStyle(color: HiColor.color_181717_A50, fontSize: 12),
        ),
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
              (item.className??"") + "   "+(item.leaveStudentName??"")+"请假   "+_getStatusText(),
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
              color: _getStatusColor(), borderRadius: BorderRadius.circular(12)),
          child: Text(
            _getStatusText(),
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        )
      ],
    );
  }

  ///列表类型 1.我的发起；2.请假审批；3.收到通知/我的通知；5.缺勤汇总
  Color _getStatusColor() {
    LogUtil.d("学生请假", "getStatusColor type=" + type+" reviewStatus="+(item.reviewStatus??0).toString());
    if (type == "2") {
      LogUtil.d("学生请假","type == 2");
      return buildOAApplyStatus(item.reviewStatus)[0];
    } else if (type == "3") {
      return buildOAApplyNoticeStatus(item.reviewStatus)[0];
    } else if (type == "5") {
      return buildOAStatus(item.reviewStatus)[0];
    } else {
      LogUtil.d("学生请假","type == other");
      return buildOAStatus(item.reviewStatus)[0];
    }
  }

  String _getStatusText() {
    LogUtil.d("学生请假", "getStatusColor type=" + type+" reviewStatus="+(item.reviewStatus??0).toString());
    if (type == "2") {
      LogUtil.d("学生请假","type == 2");
      return buildOAApplyStatus(item.reviewStatus)[1];
    } else if (type == "3") {
      return buildOAApplyNoticeStatus(item.reviewStatus)[1];
    } else if (type == "5") {
      return buildOAStatus(item.reviewStatus)[1];
    } else {
      LogUtil.d("学生请假","type == other");
      return buildOAStatus(item.reviewStatus)[1];
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
              style: const TextStyle(fontSize: 12, color: HiColor.color_181717_A50),
            ),
          ],
        ),
        Text(
          "通知日期 " +
              dateYearMothAndDay(
                  (item.leaveDate ?? "").replaceAll(".000", "")),
          style: const TextStyle(fontSize: 12, color: HiColor.color_181717_A50),
        )
      ],
    );
  }
}
