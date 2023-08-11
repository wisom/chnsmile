import 'package:chnsmile_flutter/model/repair_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';

class RepairCard extends StatelessWidget {
  final Repair item;
  final ValueChanged<Repair> onCellClick;

  const RepairCard({Key key, this.item, this.onCellClick}) : super(key: key);

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
            children: [_buildContent(), hiSpace(height: 6), _buildTime()],
          ),
        ));
  }

  _buildContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('表单编号:',
                    style: TextStyle(fontSize: 12, color: Colors.black87)),
                hiSpace(height: 6),
                Text(item.formId,
                    style: const TextStyle(fontSize: 12, color: Colors.black87)),
              ],
            ),
            hiSpace(height: 3),
            Row(
              children: [
                const Text('报修物品:',
                    style: TextStyle(fontSize: 12, color: Colors.black87)),
                hiSpace(height: 6),
                Text(item.repairMer,
                    style: const TextStyle(fontSize: 12, color: Colors.black87)),
              ],
            )
          ],
        ),
        Container(
          height: 24,
          width: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: buildOAStatus(item.status)[0],
              borderRadius: BorderRadius.circular(12)),
          child: Text(
            buildOAStatus(item.status)[1],
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        )
      ],
    );
  }

  _buildTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('报修日期:${dateYearMothAndDay(item.ddate.replaceAll(".000", ""))}',
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
