import 'package:chnsmile_flutter/model/class_transfer_model2.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class ClassTransferCard2 extends StatelessWidget {
  final ClassTransfer2 item;
  final ValueChanged<ClassTransfer2> onCellClick;

  const ClassTransferCard2({Key key, this.item, this.onCellClick}) : super(key: key);

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
            Expanded(child:
            Text('表单编号:${item.formId}',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ),
            Container(
              height: 24,
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: buildOAClassStatus(item.status)[0],
                  borderRadius: BorderRadius.circular(12)),
              child: Text(
                buildOAClassStatus(item.status)[1],
                style: const TextStyle(fontSize: 13, color: Colors.white),
              ),
            )
          ],
        ),
        hiSpace(height: 6),
        Row(
          children: [
            Text('调课原因:${item.reason ?? ''}',
                style: const TextStyle(fontSize: 13, color: Colors.black)),
          ],
        )
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
      mainAxisAlignment: MainAxisAlignment.end,
      children:[
        const Text('建立日期:',
            style: TextStyle(fontSize: 13, color: Colors.grey)),
        Text(dateYearMothAndDay(item.ddate.replaceAll(".000", "")),
            style: const TextStyle(fontSize: 13, color: Colors.black87)),
      ],
    );
  }
}
