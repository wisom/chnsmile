import 'package:chnsmile_flutter/model/clock_in_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class ClockInCard extends StatelessWidget {
  final String isSchool; //(0:查询教师的打卡列表，2：查询学生的打卡列表)
  final ClockIn item;
  final ValueChanged<ClockIn> onCellClick;

  const ClockInCard({Key key, this.isSchool, this.item, this.onCellClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
            onTap: () {
              onCellClick(item);
            },
            child: Container(
              decoration: BoxDecoration(border: borderLine(context)),
              padding: const EdgeInsets.only(
                  left: 15, right: 15, bottom: 0, top: 15),
              child: Column(
                children: [
                  _buildTop(),
                  hiSpace(height: 12),
                  _buildSecond(),
                  hiSpace(height: 14),
                  _buildThird(),
                  hiSpace(height: 15),
                  _buildBottom(),
                  hiSpace(height: 8),
                ],
              ),
            )),
        Container(
          width: double.infinity,
          height: 1,
          decoration: const BoxDecoration(color: HiColor.color_F7F7F7),
        )
      ],
    );
  }

  _buildBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          item?.punchStatusLabel ?? "未开始",
          style: const TextStyle(fontSize: 12, color: HiColor.color_181717_A50),
        ),
        Text(
          "打卡时间：${item.startDate}-${item.endDate}",
          style: const TextStyle(fontSize: 12, color: HiColor.color_181717_A50),
        ),
      ],
    );
  }

  _buildTop() {
    return Row(
      children: [
        Expanded(
            child: Text(
          item.title ?? "",
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: HiColor.color_181717),
        )),
        Container(
          width: 58,
          height: 20,
          alignment: Alignment.center,
          child: Text(
            getTextByType(),
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(10),
              color: buildClockInStatus(item.releaseStatus ?? 0)[0]),
        ),
      ],
    );
  }

  _buildSecond() {
    return Row(
      children: [
        const Text(
          "参与打卡：",
          style: TextStyle(fontSize: 13, color: HiColor.color_181717_A50),
        ),
        Expanded(
            child: Text(
          item.gradClass.join("、"),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, color: HiColor.color_181717_A50),
        ))
      ],
    );
  }

  ///打卡频次（0：每天，1：周一，2：周二，3：周三，4：周四，5：周五，6：周六，7：周日）
  _buildWeek(int week) {
    if (week == 0) {
      return "每天";
    } else if (week == 1) {
      return "周一";
    } else if (week == 2) {
      return "周二";
    } else if (week == 3) {
      return "周三";
    } else if (week == 4) {
      return "周四";
    } else if (week == 5) {
      return "周五";
    } else if (week == 6) {
      return "周六";
    } else if (week == 7) {
      return "周日";
    }
  }

  _buildThird() {
    var frequencys = "";
    if (item?.clockFrequencys?.length == 1 && item?.clockFrequencys[0] == 0) {
      frequencys = "每天";
    } else {
      if (item?.clockFrequencys != null && item?.clockFrequencys?.isNotEmpty) {
        for (var i = 0; i < item.clockFrequencys.length; i++) {
          var f = item.clockFrequencys[i];
          frequencys = frequencys + (i == 0 ? "" : "、") + _buildWeek(f);
        }
      }
    }
    return Row(
      children: [
        Expanded(
            child: Row(
          children: [
            const Text(
              "进度：",
              style: TextStyle(fontSize: 12, color: HiColor.color_181717_A50),
            ),
            Text(
              "已进行${item.dayAlready ?? 0}天/共${item.dayTotal}天",
              style: const TextStyle(fontSize: 12, color: HiColor.color_181717),
            )
          ],
        )),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              "频次：",
              style: TextStyle(fontSize: 12, color: HiColor.color_181717_A50),
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 120),
              child:

                  ///0：每天，1：周一，2：周二，3：周三，4：周四，5：周五，6：周六，7：周日
                  Text(
                frequencys,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style:
                    const TextStyle(fontSize: 12, color: HiColor.color_181717),
              ),
            )
          ],
        ))
      ],
    );
  }

  _buildPot(Color color) {
    return Container(
      width: 6,
      height: 6,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(3), color: color),
    );
  }

  //0：未发布，1：已发布，3：已撤回
  String getTextByType() {
    if (item.releaseStatus == 1) {
      return "已发布";
    } else if (item.releaseStatus == 3) {
      return "已撤回";
    } else {
      return "未发布";
    }
  }

  //0：未发布，1：已发布，3：已撤回
  Color _getStatusColor() {
    if (item.releaseStatus == 1) {
      return HiColor.color_00B0F0;
    } else if (item.releaseStatus == 3) {
      return HiColor.red;
    } else {
      return HiColor.color_D8D8D8;
    }
  }
//
// Color getColorByType() {
//   if (type == "3") {
//     return HiColor.color_181717_A50;
//   } else {
//     return HiColor.color_181717;
//   }
// }
}
