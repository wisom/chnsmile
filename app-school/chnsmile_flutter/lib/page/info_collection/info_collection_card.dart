import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

import '../../model/info_collection_model.dart';

class InfoCollectionCard extends StatelessWidget {
  final InfoCollection item;
  final String type;
  final ValueChanged<InfoCollection> onCellClick;

  const InfoCollectionCard({Key key, this.item, this.type, this.onCellClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onCellClick(item);
        },
        child: Container(
          child: Column(
            children: [_buildContent(), hiSpace(height: 8),hiSpaceWithColor(context,height: 8)],
          ),
        ));
  }

  _buildContent() {
    return Padding(padding: const EdgeInsets.only(
        left: 15, right: 15, bottom: 15, top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(item.statisticsName, style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: HiColor.color_181717)),
                  ],
                ),
                hiSpace(height: 14),
                Row(
                  children: [
                    const Text('参与采集:',
                        style: TextStyle(
                            fontSize: 10, color: HiColor.color_181717_A50)),
                    hiSpace(height: 6),
                    Text(
                        item.gradClass.map((group) => group).toList().join("、"),
                        style: const TextStyle(
                            fontSize: 10, color: HiColor.color_181717)),
                  ],
                ),
                hiSpace(height: 6),
                Row(
                  children: [
                    const Text('有效时间:',
                        style: TextStyle(
                            fontSize: 10, color: HiColor.color_181717_A50)),
                    hiSpace(height: 6),
                    Text(item.startTime,
                        style: const TextStyle(
                            fontSize: 10, color: HiColor.color_181717)),
                    const Text(" - ",
                        style:
                        TextStyle(fontSize: 10, color: HiColor.color_181717)),
                    Text(item.endTime,
                        style: const TextStyle(
                            fontSize: 10, color: HiColor.color_181717)),
                  ],
                )
              ],
            ),
            Container(
              height: 20,
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: buildInfoCollectionStatus(item.releaseStatus)[0],
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                buildInfoCollectionStatus(item.releaseStatus)[1],
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
            )
          ],
        ),
    );
  }

// _buildTime() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.end,
//     children: [
//       Text('报修日期:${dateYearMothAndDay(item.ddate.replaceAll(".000", ""))}',
//           style: const TextStyle(fontSize: 10, color: Colors.grey)),
//     ],
//   );
// }
}
