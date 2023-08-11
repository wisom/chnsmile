import 'package:chnsmile_flutter/model/class_transfer_model2.dart';
import 'package:chnsmile_flutter/model/class_transfer_model3.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class ClassTransferCard3 extends StatelessWidget {
  final ClassTransfer3 item;
  final ValueChanged<ClassTransfer3> onCellClick;

  const ClassTransferCard3({Key key, this.item, this.onCellClick}) : super(key: key);

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
            children: [_buildContent(context), hiSpace(height: 10), _buildBottom()],
          ),
        ));
  }

  _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Row(
              children: [
                Text('${item.cname}发出的调课申请  ',
                    style: const TextStyle(fontSize: 12, color: Colors.black)),
                Text('${buildOAStatus(item.status)[1]}',
                    style: TextStyle(
                        fontSize: 12, color: buildOAStatus(item.status)[0])),
              ],
            )),
            item.reviewStatus == 2 ? buildReadUnReadStatus('已读', Colors.green) : buildReadUnReadStatus('未读', Colors.red)
          ],
        ),
        hiSpace(height: 4),
        Row(
          children: [
            Text('调课原因:${item.reason}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  _buildBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('表单编号:${item.formId}',
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text('通知时间:${dateYearMothAndDayAndMinutes(item.ddate.replaceAll(".000", ""))}',
            style: const TextStyle(fontSize: 12, color: Colors.grey))
      ]
    );
  }
}