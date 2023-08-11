import 'package:chnsmile_flutter/model/vote.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/utils.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class VoteCard2 extends StatelessWidget {
  final Vote vote;
  final bool isFromDetail;

  const VoteCard2({Key key, this.vote, this.isFromDetail = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          handleClick(vote);
        },
        child: Container(
          decoration: BoxDecoration(border: borderLine(context)),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              _buildTime(),
              hiSpace(height: 10),
              _buildTitle(),
              _buildContent(),
              _buildBottom(),
            ],
          ),
        ));
  }

  void handleClick(Vote vote) {
    if (isFromDetail) return;
    BoostNavigator.instance
        .push('vote_detail_page', arguments: {"voteId": vote.voteId});
  }

  _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 10),
              width: 48,
              height: 24,
              decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Text('${vote?.noticeUserSum}人',
                  style: const TextStyle(fontSize: 12, color: Colors.white)),
            ),
            Container(
              width: Utils.width - 130,
              child: Text(vote?.voteTitle ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: HiColor.dark_text)),
            )
          ],
        )),
        buildReadUnReadStatus(vote.submitAnsLabel, vote.hasSumbitAns == 0 ? Colors.red : primary)
      ],
    );
  }

  _buildContent() {
    return Container(
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child:Text(
          removeHtmlTag(vote?.voteDesc ?? '') ?? '',
          style: const TextStyle(fontSize: 12, color: Colors.black),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ));
  }

  _buildTime() {
    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            child:  Text(vote?.voteType == 0 ? '单选' : '多选',
                style: const TextStyle(fontSize: 12, color: Colors.red))),
        hiSpace(height: 3),
        Row(
          children: [
            Expanded(
                child: Row(
                  children: [
                    Text(
                        '开始时间:${dateYearMothAndDayAndMinutes(vote.startTime.replaceAll(".000", ""))}',
                        style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                )),
            Expanded(
                child: Text(
                    '结束时间:${dateYearMothAndDayAndMinutes(vote.endTime.replaceAll(".000", ""))}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 11, color: Colors.grey)))
          ],
        )
      ],
    );
  }

  _buildBottom() {
    if (vote.publicTime == null) return Container();
    return Row(
      children: [
        Text('发布人: ${vote.publicUserName ?? ''}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Expanded(
            flex: 1,
            child: Text(
                _buildStatusText(),
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12, color: Colors.grey)))
      ],
    );
  }

  _buildStatusText() {
    if (vote?.voteStatus == 3) {
      return "撤回时间: ${vote.cancelTime!=null ? dateYearMothAndDayAndMinutes(vote.cancelTime.replaceAll(".000", "")) : ''}";
    } else {
      if (vote.updateTime != null) {
        return "修改时间: ${vote.updateTime!=null ? dateYearMothAndDayAndMinutes(vote.updateTime.replaceAll(".000", "") ?? '') : ''}";
      } else {
        return "发布时间: ${dateYearMothAndDayAndMinutes(vote.publicTime.replaceAll(".000", "") ?? '')}";
      }
    }
  }
}
