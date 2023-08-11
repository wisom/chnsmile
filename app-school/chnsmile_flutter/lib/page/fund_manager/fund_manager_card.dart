import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

import '../../model/fund_manager_model.dart';

class FundManagerCard extends StatelessWidget {
  final FundManager item;
  final String type;
  final ValueChanged<FundManager> onCellClick;

  const FundManagerCard({Key key, this.item, this.type, this.onCellClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return InkWell(
    //     onTap: () {
    //       onCellClick(item);
    //     },
    //     child: Container(
    //       child: Column(
    //         children: [
    //           // _buildContent(),
    //           hiSpace(height: 8),
    //           hiSpaceWithColor(context, height: 8)
    //         ],
    //       ),
    //     ));

    return InkWell(
      onTap: () {
        onCellClick(item);
      },
      child: _buildBody(context, item),
    );
  }

  // _buildContent() {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               children: [
  //                 Text(item.statisticsName,
  //                     style: const TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 14,
  //                         color: HiColor.color_181717)),
  //               ],
  //             ),
  //             hiSpace(height: 14),
  //             Row(
  //               children: [
  //                 const Text('参与采集:',
  //                     style: TextStyle(
  //                         fontSize: 10, color: HiColor.color_181717_A50)),
  //                 hiSpace(height: 6),
  //                 Text(item.gradClass.map((group) => group).toList().join("、"),
  //                     style: const TextStyle(
  //                         fontSize: 10, color: HiColor.color_181717)),
  //               ],
  //             ),
  //             hiSpace(height: 6),
  //             Row(
  //               children: [
  //                 const Text('有效时间:',
  //                     style: TextStyle(
  //                         fontSize: 10, color: HiColor.color_181717_A50)),
  //                 hiSpace(height: 6),
  //                 Text(item.startTime,
  //                     style: const TextStyle(
  //                         fontSize: 10, color: HiColor.color_181717)),
  //                 const Text(" - ",
  //                     style:
  //                     TextStyle(fontSize: 10, color: HiColor.color_181717)),
  //                 Text(item.endTime,
  //                     style: const TextStyle(
  //                         fontSize: 10, color: HiColor.color_181717)),
  //               ],
  //             )
  //           ],
  //         ),
  //         Container(
  //           height: 20,
  //           width: 60,
  //           alignment: Alignment.center,
  //           decoration: BoxDecoration(
  //               color: buildInfoCollectionStatus(item.releaseStatus)[0],
  //               borderRadius: BorderRadius.circular(10)),
  //           child: Text(
  //             buildInfoCollectionStatus(item.releaseStatus)[1],
  //             style: const TextStyle(fontSize: 10, color: Colors.white),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

// _buildTime() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.end,
//     children: [
//       Text('报修日期:${dateYearMothAndDay(item.ddate.replaceAll(".000", ""))}',
//           style: const TextStyle(fontSize: 10, color: Colors.grey)),
//     ],
//   );
// }

  _buildBody(BuildContext context, FundManager item) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.fromLTRB(14, 11, 14, 13),
            child: Column(
              children: [
                _buildTopInfo(item),
                hiSpace(height: 8),
                _buildMoney(item),
                hiSpace(height: 13),
                line(context),
                hiSpace(height: 11),
                _buildBottomInfo(item)
              ],
            )),
        line(context)
      ],
    );
  }

  _buildBottomInfo(FundManager item) {
    return Row(
      children: [
        const Text(
          "表单编号",
          style: TextStyle(
            fontSize: 10,
            color: HiColor.color_181717_A50,
          ),
        ),
        Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Text(
                item.formId ?? "",
                style: const TextStyle(
                  fontSize: 10,
                  color: HiColor.color_181717_A50,
                ),
              ),
            )),
        Text("发起日期  ${item.needDate}",
            style: const TextStyle(
              fontSize: 10,
              color: HiColor.color_181717_A50,
            ))
      ],
    );
  }

  _buildMoney(FundManager item) {
    return Row(
      children: [
        const Text(
          "预计总额",
          style: TextStyle(
            fontSize: 14,
            color: HiColor.color_181717_A50,
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
            child: Text(
              (item.budget ?? 0.0).toString(),
              style: const TextStyle(
                fontSize: 14,
                color: HiColor.color_00B0F0,
              ),
            )),
      ],
    );
  }

  _buildTopInfo(FundManager item) {
    return Row(
      children: [
        Expanded(
            child: Text(
              item.content,
              style: const TextStyle(
                  fontSize: 14,
                  color: HiColor.color_181717,
                  fontWeight: FontWeight.bold),
            )),
        Container(
          width: 61,
          height: 19,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(9.5)),
              color: _getTypeColor()),
          child: Center(
            child: Text(
              _getTypeStr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  ///状态（0未发送、1批阅中、2已备案、3已拒绝）
  _getTypeStr() {
    if (item.status == 1) {
      return "批阅中";
    } else if (item.status == 2) {
      return "已备案";
    } else if (item.status == 3) {
      return "已拒绝";
    } else {
      return "未发送";
    }
  }

  ///状态（0未发送、1批阅中、2已备案、3已拒绝）
  _getTypeColor() {
    if (item.status == 1) {
      return HiColor.color_FFC41B;
    } else if (item.status == 2) {
      return HiColor.color_00B0F0;
    } else if (item.status == 3) {
      return HiColor.color_FA0000;
    } else {
      return HiColor.color_D8D8D8;
    }
  }


}
