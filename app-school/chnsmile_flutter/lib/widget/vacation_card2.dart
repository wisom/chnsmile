import 'package:chnsmile_flutter/model/repair_model.dart';
import 'package:chnsmile_flutter/model/vacation_model1.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class VacationCard2 extends StatelessWidget {
  final Vacation item;
  final ValueChanged<Vacation> onCellClick;

  const VacationCard2({Key key, this.item, this.onCellClick}) : super(key: key);

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
            children: [_buildContent(context), hiSpace(height: 5), _buildBottom()],
          ),
        ));
  }

  _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text('请假人:${item.leaveName}    请假${item.hours}小时',
                style: const TextStyle(fontSize: 13, color: Colors.black))),
            Container(
              height: 24,
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: buildOAApplyStatus(item.reviewStatus)[0],
                  borderRadius: BorderRadius.circular(12)),
              child: Text(
                buildOAApplyStatus(item.reviewStatus)[1],
                style: const TextStyle(fontSize: 13, color: Colors.white),
              ),
            )
          ],
        ),
        hiSpace(height: 6),
        Row(
          children: [
            Text('请假开始时间:${item.dateStart ?? ''}',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
        hiSpace(height: 6),
        Row(
          children: [
            Text('请假结束时间:${item.dateEnd ?? ''}',
                style: const TextStyle(fontSize: 13, color: Colors.grey))
          ],
        ),
      ],
    );
  }

  bool get isRefuse {
    return item.status == 3;
  }

  bool get isAgree {
    return item.status == 2;
  }

  _buildBottom() {
    return Row(
      children: [
        Expanded(child: Row(children: [
          const Text('请假类型: ',
              style: TextStyle(fontSize: 13, color: Colors.grey)),
          Text(item.kinds,
              style: const TextStyle(fontSize: 13, color: Colors.black87)),

        ])),
        Row(
          children: [
            const Text('申请日期:',
                style: TextStyle(fontSize: 13, color: Colors.grey)),
            Text(dateYearMothAndDay(item.ddate.replaceAll(".000", "")),
                style: const TextStyle(fontSize: 13, color: Colors.black87)),
          ],
        )
        // isRefuse || isAgree
        //     ? const Icon(Icons.arrow_forward_ios_rounded,
        //     size: 16, color: Colors.grey)
        //     : Container(
        //   height: 26,
        //   width: 56,
        //   alignment: Alignment.center,
        //   color: primary,
        //   child: const Text(
        //     '审批',
        //     style: TextStyle(fontSize: 13, color: Colors.white),
        //   ),
        // ),
      ],
    );
  }
}
