import 'package:chnsmile_flutter/model/vote_model1.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/utils.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class VoteCard1 extends StatefulWidget {
  final Vote vote;

  const VoteCard1({Key key, this.vote}) : super(key: key);

  @override
  State<VoteCard1> createState() => _VoteCard1State();
}

class _VoteCard1State extends State<VoteCard1> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          handleClick(widget.vote);
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
    // voteStatus 0 未发布 1 已发布 3 已撤回
    BoostNavigator.instance
        .push('school_vote_add_page', arguments: {"voteId": vote.id});
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
              child: Text('${widget.vote?.noticeUserSum}人',
                  style: const TextStyle(fontSize: 12, color: Colors.white)),
            ),
            Container(
              width: Utils.width - 130,
              child: Text(widget.vote?.voteTitle ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: HiColor.dark_text)),
            )

          ],
        )),
        Text(
          buildSchoolVoteStatus(widget.vote?.voteStatus)[1],
          style: TextStyle(
              fontSize: 13,
              color: buildSchoolVoteStatus(widget.vote?.voteStatus)[0]),
        )
      ],
    );
  }

  _buildContent() {
    return Container(
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child:Text(
          removeHtmlTag(widget.vote?.voteDesc ?? '') ?? '',
          style: const TextStyle(fontSize: 13, color: Colors.black),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ));
  }

  _buildTime() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            child: Text(widget.vote?.voteType == 0 ? '单选' : '多选',
            style: const TextStyle(fontSize: 12, color: Colors.red))),
        hiSpace(height: 4),
        Row(
          children: [
            Expanded(
                child: Row(
                  children: [
                    Text(
                        '开始时间:${dateYearMothAndDayAndMinutes(widget.vote.startTime.replaceAll(".000", ""))}',
                        style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                )),
            Expanded(
                child: Text(
                    '结束时间:${dateYearMothAndDayAndMinutes(widget.vote.endTime.replaceAll(".000", ""))}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 11, color: Colors.grey)))
          ],
        )
      ],
    );
  }

  _buildBottom() {
    if (widget.vote.publicTime == null) return Container();
    return Row(
      children: [
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
    if (widget.vote?.voteStatus == 3) {
      return "撤回时间: ${widget.vote.cancelTime!=null ? dateYearMothAndDayAndMinutes(widget.vote.cancelTime.replaceAll(".000", "")) : ''}";
    } else {
      if (widget.vote.updateTime != null) {
        return "修改时间: ${widget.vote.updateTime!=null ? dateYearMothAndDayAndMinutes(widget.vote.updateTime.replaceAll(".000", "") ?? '') : ''}";
      } else {
        return "发布时间: ${dateYearMothAndDayAndMinutes(widget.vote.publicTime.replaceAll(".000", "") ?? '')}";
      }
    }
  }
}
