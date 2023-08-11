import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';

import '../../model/clock_in_times_model.dart';

class ClockInTimesSelectCard extends StatelessWidget {
  final ClockInTimesModel item;
  final ValueChanged<ClockInTimesModel> onCellClick;

  const ClockInTimesSelectCard({Key key, this.item, this.onCellClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onCellClick(item);
        },
        child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Column(children: [
              Expanded(
                child: Center(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(22, 0, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.content ?? "",
                              style: const TextStyle(
                                  fontSize: 14, color: HiColor.color_181717),
                            ),
                            Image(
                                width: 16,
                                height: 16,
                                image: item.isSelect
                                    ? const AssetImage(
                                        'images/ic_circle_check.png')
                                    : const AssetImage(
                                        'images/ic_circle_uncheck.png'))
                          ],
                        ))),
              ),
              line(context, margin: const EdgeInsets.fromLTRB(22, 0, 0, 0))
            ])));
  }
}
