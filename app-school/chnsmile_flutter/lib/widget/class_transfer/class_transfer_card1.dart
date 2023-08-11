import 'package:chnsmile_flutter/model/class_transfer_model1.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class ClassTransferCard1 extends StatelessWidget {
  final ClassTransfer item;
  final ValueChanged<ClassTransfer> onCellClick;

  const ClassTransferCard1({Key key, this.item, this.onCellClick})
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
              const EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
          child: _buildContent(),
        ));
  }

  _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(item.reason ?? '', textAlign: TextAlign.left, style: const TextStyle(fontSize: 13, color: Colors.black))),
            Container(
              height: 24,
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: buildClassOAStatus(item.status)[0],
                  borderRadius: BorderRadius.circular(12)),
              child: Text(
                buildClassOAStatus(item.status)[1],
                style: const TextStyle(fontSize: 13, color: Colors.white),
              ),
            )
          ],
        ),
        hiSpace(height: 10),
        Text('表单编号: ${item.formId ?? ''}', style: const TextStyle(fontSize: 13, color:Colors.grey)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
          Text('建立日期: ${dateYearMothAndDay(item.createTime.replaceAll(".000", "")) ?? ''}', style: const TextStyle(fontSize: 13, color:Colors.grey))
          ],
        ),
      ],
    );
  }
}
