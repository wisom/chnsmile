import 'dart:convert';

import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/dao/vote_dao.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/model/vote_detail_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/utils.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:ele_progress/ele_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class VoteDetailPage extends StatefulWidget {
  final Map params;
  String voteId;

  VoteDetailPage({Key key, this.params}) : super(key: key) {
    voteId = params['voteId'];
  }

  @override
  _VoteDetailPageState createState() => _VoteDetailPageState();
}

class _VoteDetailPageState extends HiState<VoteDetailPage> {
  VoteDetailModel voteDetailModel;
  String optionValue = "";
  List<VoteOptions> selectedOptions = [];
  List<bool> isChecks = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('校园投票'),
      body: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
        color: Colors.white,
        child: voteDetailModel != null
            ? ListView(
                children: [
                  _buildTime(),
                  hiSpace(height: 10),
                  _buildTitle(),
                  _buildContent1(),
                  _buildBottom2(),
                  boxLine(context),
                  _buildRadio()
                ],
              )
            : Container(),
      ),
    );
  }

  _buildBottom2() {
    return Row(
      children: [
        Text('发布人: ${voteDetailModel.vote.publicUserName ?? ''}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
    if (voteDetailModel.vote?.voteStatus == 3) {
      return "撤回时间: ${voteDetailModel.vote.cancelTime!=null ? dateYearMothAndDayAndMinutes(voteDetailModel.vote.cancelTime.replaceAll(".000", "")) : ''}";
    } else {
      if (voteDetailModel.vote.updateTime != null) {
        return "修改时间: ${voteDetailModel.vote.updateTime!=null ? dateYearMothAndDayAndMinutes(voteDetailModel.vote.updateTime.replaceAll(".000", "") ?? '') : ''}";
      } else {
        return "发布时间: ${dateYearMothAndDayAndMinutes(voteDetailModel.vote.publicTime.replaceAll(".000", "") ?? '')}";
      }
    }
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
              child: Text('${voteDetailModel.vote?.noticeUserSum}人',
                  style: const TextStyle(fontSize: 12, color: Colors.white)),
            ),
            Container(
              width: Utils.width - 130,
              child: Text(voteDetailModel.vote?.voteTitle ?? '',
                  maxLines: 10,
                  style: const TextStyle(fontSize: 13, color: HiColor.dark_text)),
            )
          ],
        )),
        buildReadUnReadStatus(voteDetailModel.vote.voteStatusLabel,
            isVoteEnd ? Colors.grey : primary)
      ],
    );
  }

  _buildContent1() {
    return Container(
        alignment: Alignment.topLeft,
        child: Html(data: voteDetailModel.vote?.voteDesc ?? ''));
  }

  _buildTime() {
    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            child:   Text(voteDetailModel.vote?.voteType == 0 ? '单选' : '多选',
                style: const TextStyle(fontSize: 12, color: Colors.red))),
        hiSpace(height: 3),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Text(
                        '开始时间:${dateYearMothAndDayAndMinutes(voteDetailModel.vote?.startTime.replaceAll(".000", ""))}',
                        style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                )),
            Expanded(
                flex: 1,
                child: Text(
                    '结束时间:${dateYearMothAndDayAndMinutes(voteDetailModel.vote?.endTime.replaceAll(".000", ""))}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey)))
          ],
        )
      ],
    );
  }

  void _loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      VoteDetailModel result = await VoteDao.voteDetail(widget.voteId);
      setState(() {
        voteDetailModel = result;
        isChecks = List.filled(voteDetailModel.voteOptions?.length, false);
      });
      EasyLoading.dismiss(animation: false);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
      EasyLoading.dismiss(animation: false);
    }
  }

  bool get isVoted {
    return voteDetailModel.voteUserOptions.isNotEmpty;
  }

  bool get isVoteEnd {
    return voteDetailModel.vote.voteStatus == 2;
  }

  /// 未开始
  bool get isVoteUnBegin {
    return voteDetailModel.vote.voteStatus == 4;
  }

  _buildContent() {
    return (isVoted || isVoteEnd || isVoteUnBegin) ? _buildOptionsResult() : _buildOptions();
  }

  _buildOptions() {
    return voteDetailModel?.voteOptions?.map((VoteOptions option) {
      int index = voteDetailModel.voteOptions.indexOf(option);
      return voteDetailModel?.vote?.voteType == 0
          ? RadioListTile(
              activeColor: primary,
              contentPadding: const EdgeInsets.only(left: 10, top: 0),
              title: Text('${option.voteLabel}  ${option.voteName}',
                  style:
                      const TextStyle(color: HiColor.dark_text, fontSize: 13)),
              value: option.id,
              groupValue: optionValue,
              onChanged: (optionId) {
                setState(() {
                  selectedOptions.clear();
                  selectedOptions.add(option);
                  optionValue = optionId;
                });
              })
          : CheckboxListTile(
              activeColor: primary,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.only(left: 10, top: 0),
              title: Text('${option.voteLabel}  ${option.voteName}',
                  style:
                      const TextStyle(color: HiColor.dark_text, fontSize: 13)),
              value: isChecks[index],
              onChanged: (value) {
                setState(() {
                  isChecks[index] = value;
                  if (value) {
                    selectedOptions.add(option);
                  } else {
                    selectedOptions.remove(option);
                  }
                });
              });
    })?.toList();
  }

  _buildOptionsResult() {
    return voteDetailModel?.voteOptions?.map((VoteOptions option) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Radio(value: option.id, groupValue: 0, onChanged: null),
              Text('${option.voteLabel}  ${option.voteName}',
                  style:
                      const TextStyle(color: HiColor.dark_text, fontSize: 13))
            ],
          ),
          Container(
            width: Utils.width,
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Row(
              children: [
                Expanded(
                    child: EProgress(
                        textInside: true,
                        strokeWidth: 12,
                        strokeCap: StrokeCap.square,
                        colors: const [primary],
                        progress: _process(option.optionSumDetailResult))),
                hiSpace(width: 3),
                Text('${option.optionSumDetailResult?.userSum ?? 0}人',
                    style: const TextStyle(fontSize: 12, color: Colors.black54))
              ],
            ),
          )
        ],
      );
    })?.toList();
  }

  int _process(OptionSumDetailResult option) {
    try {
      if (option == null || int.parse(option.voteCount) == 0) {
        return 0;
      }
      double t1 = double.parse(option.userSum);
      double t2 = double.parse(option.voteCount);
      return ((t1 / t2) * 100).toInt();
    } catch (e) {
      return 0;
    }
  }

  _buildRadio() {
    return Column(children: [
      Container(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
            children: voteDetailModel != null
                ? _buildContent()
                : [const Text('加载中...')]),
      ),
      Container(
        margin: const EdgeInsets.only(top: 10),
        child: (isVoted || isVoteEnd || isVoteUnBegin) ? Container() : _buildBottom(),
      )
    ]);
  }

  _buildBottom() {
    return Row(
      children: [
        RaisedButton(
          onPressed: onVote,
          color: primary,
          child: const Text(
            '投票',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        hiSpace(width: 20),
        RaisedButton(
          onPressed: () {
            if (!isVoted) {
              showWarnToast("投票了之后才能查看结果哦~");
            }
          },
          color: Colors.grey,
          child: const Text(
            '查看结果',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        )
      ],
    );
  }

  onVote() async {
    try {
      if (selectedOptions.isEmpty) {
        showWarnToast("请选择一个投票项目");
        return;
      }

      EasyLoading.show(status: '加载中...');
      List options = [];
      for (int i = 0; i < selectedOptions.length; i++) {
        Map<String, dynamic> option = {};
        option['voteId'] = voteDetailModel.vote.voteId;
        option['voteOptionId'] = selectedOptions[i].id;
        option['voteLabel'] = selectedOptions[i].voteLabel;
        options.add(option);
      }
      var jsons = json.encode(options);
      var result = await VoteDao.submit(jsons);
      print(result);
      var bus = EventNotice();
      bus.formId = widget.voteId;
      eventBus.fire(bus);
      EasyLoading.dismiss(animation: false);
      _loadData();
    } on HiNetError catch (e) {
      EasyLoading.dismiss(animation: false);
      print(e);
      showWarnToast(e.message);
    }
  }

  onChanged(v) {
    setState(() {
      optionValue = v;
    });
  }
}
