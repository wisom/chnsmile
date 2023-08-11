import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

import '../../core/hi_state.dart';
import '../../model/reimbursement_detail_model.dart';

typedef VoidCallback = void Function(
    String classId, String userId, bool isSelected);

class ReimbursementDetailCard extends StatefulWidget {
  final ItemList item;
  final List<ItemList> subItems;

  const ReimbursementDetailCard({Key key, this.item, this.subItems})
      : super(key: key);

  @override
  _ReimbursementDetailCardState createState() => _ReimbursementDetailCardState();
}

class _ReimbursementDetailCardState extends HiState<ReimbursementDetailCard> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
          child: Row(
            children: [
              Expanded(
                  child: Row(
                    children: [
                      const Text(
                        "报销类型：",
                        style: TextStyle(fontSize: 12, color: HiColor.color_787777),
                      ),
                      Text(
                        widget.item.reimbursementType ?? "",
                        style: TextStyle(fontSize: 12, color: HiColor.color_00B0F0),
                      )
                    ],
                  )),
              Expanded(
                  child: Row(
                    children: [
                      const Text(
                        "发票数量：",
                        style: TextStyle(fontSize: 12, color: HiColor.color_787777),
                      ),
                      Text(
                        (widget.item.count ?? 0).toString(),
                        style: const TextStyle(
                            fontSize: 12, color: HiColor.color_181717),
                      ),
                    ],
                  ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 18),
          child: Row(
            children: [
              Expanded(
                  child: Row(
                    children: [
                      const Text(
                        "报销金额：",
                        style: TextStyle(fontSize: 12, color: HiColor.color_787777),
                      ),
                      Text(
                        (widget.item.amount ?? 0.0).toString(),
                        style: const TextStyle(
                            fontSize: 12, color: HiColor.color_181717),
                      ),
                    ],
                  )),
              Expanded(child: Container())
            ],
          ),
        ),
        line(context),
      ],
    );
  }

}
