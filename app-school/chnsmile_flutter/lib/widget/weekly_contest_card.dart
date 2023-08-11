import 'package:chnsmile_flutter/model/weekly_contest_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class WeeklyContestCard extends StatelessWidget {
  final WeeklyContest item;

  const WeeklyContestCard({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          handleClick(item);
        },
        child: Container(
          decoration: BoxDecoration(border: borderLine(context)),
          padding:
              const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
          child: Column(
            children: [_buildTitle(), _buildContent(), _buildBottom()],
          ),
        ));
  }

  void handleClick(WeeklyContest item) {
    BoostNavigator.instance
        .push('weekly_contest_detail_page', arguments: {"id": item.voteId});
  }

  _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(item?.voteTitle ?? '',
            style: const TextStyle(fontSize: 13, color: Colors.black)),
        buildReadUnReadStatus(item.submitAnsLabel, item.hasSubmitAns == 0 ? Colors.red : primary)
      ],
    );
  }

  _buildContent() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      alignment: Alignment.topLeft,
      child: Text(
        removeHtmlTag(item?.voteDesc) ?? '',
        style: const TextStyle(fontSize: 13, color: Colors.black),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      )
    );
  }

  _buildBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text('发布部门:${item.publicOrgName ?? ''}', style: const TextStyle(fontSize: 13, color: Colors.grey)),],
        ),
        Text(_buildStatusText(), style: const TextStyle(fontSize: 13, color: Colors.grey))
      ],
    );
  }

  _buildStatusText() {
      if (item.updateTime != null) {
        return "修改时间: ${item.updateTime!=null ? dateYearMothAndDayAndMinutes(item.updateTime.replaceAll(".000", "") ?? '') : ''}";
      } else {
        return "发布时间: ${dateYearMothAndDayAndMinutes(item.publicTime.replaceAll(".000", "") ?? '')}";
      }
  }
}
