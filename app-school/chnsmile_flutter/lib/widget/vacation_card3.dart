import 'package:chnsmile_flutter/model/vacation_model1.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';

class VacationCard3 extends StatelessWidget {
  final Vacation item;
  final ValueChanged<Vacation> onCellClick;

  const VacationCard3({Key key, this.item, this.onCellClick}) : super(key: key);

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
            children: [
              _buildContent(context),
              hiSpace(height: 6),
              _buildBottom()
            ],
          ),
        ));
  }

  _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Row(
              children: [
                Text('${item.applyName}发出的${item.applyKinds}  ',
                    style: const TextStyle(fontSize: 13, color: Colors.black)),
                Text('${buildOAStatus(item.status)[1]}',
                    style: TextStyle(
                        fontSize: 12, color: buildOAStatus(item.status)[0])),
              ],
            )),
            item.reviewStatus == 2
                ? buildReadUnReadStatus('已读', Colors.green)
                : buildReadUnReadStatus('未读', Colors.red)
          ],
        ),
        hiSpace(height: 6),
        Row(
          children: [
            Text('表单编号 ${item.formId}',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        )
      ],
    );
  }

  _buildBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
            '通知时间 ${dateYearMothAndDayAndMinutes(item.ddate.replaceAll(".000", ""))}',
            style: const TextStyle(fontSize: 13, color: Colors.grey))
      ],
    );
  }
}
