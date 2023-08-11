import 'dart:convert';

import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/dao/weekly_contest_dao.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/model/weekly_contest_detail_model.dart';
import 'package:chnsmile_flutter/model/weekly_contest_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/utils.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/weekly_contest_card.dart';
import 'package:ele_progress/ele_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class WeeklyContestDetailPage extends StatefulWidget {
  final Map params;
  String id;

  WeeklyContestDetailPage({Key key, this.params}) : super(key: key) {
    id = params['id'];
  }

  @override
  _WeeklyContestDetailPageState createState() => _WeeklyContestDetailPageState();
}

class _WeeklyContestDetailPageState extends HiState<WeeklyContestDetailPage> {
  WeeklyContestDetailModel model;
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
      appBar: _buildAppBar(),
      body: Container(
        color: Colors.white,
        child: model != null
            ? ListView(
          children: [_buildTop(), boxLine(context), hiSpace(height: 10), _buildRadio()],
        )
            : Container(),
      ),
    );
  }

  _buildAppBar() {
    var title = "";
    if (model == null || isVoteEnd || isVoted || isVoteUnBegin) {
      title = "";
    } else {
      title = "提交";
    }
    return appBar('每周竞赛', rightTitle: title, rightButtonClick: () {
      if (title == "提交") {
        onVote();
      }
    });
  }

  void _loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      WeeklyContestDetailModel result = await WeeklyContestDao.detail(widget.id);
      setState(() {
        model = result;
        isChecks = List.filled(model.voteOptions?.length, false);
      });
      EasyLoading.dismiss(animation: false);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
      EasyLoading.dismiss(animation: false);
    }
  }

  bool get isVoted {
    if (model == null) return false;
    return model?.voteUserOptions?.isNotEmpty;
  }

  bool get isVoteEnd {
    if (model == null) return false;
    return model.vote?.voteStatusLabel?.contains("结束");
  }

  /// 未开始
  bool get isVoteUnBegin {
    if (model == null) return false;
    return model.vote?.voteStatusLabel?.contains("未开始");
  }

  _buildTop() {
    if (model == null) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  model.vote?.voteType == 0 ? buildReadUnReadStatus('单选', Colors.red) : buildReadUnReadStatus('多选', Colors.red),
                  hiSpace(width: 4),
                  Container(
                    width: Utils.width - 150,
                    child: Text(model.vote.voteTitle ?? '',
                        style: const TextStyle(fontSize: 13, color: Colors.black)),
                  )

                ],
              ),
              buildReadUnReadStatus(model.vote.voteStatusLabel, isVoteEnd ? Colors.grey : primary)
              // buildReadUnReadStatus(model.vote.hasSubmitAns == 1 ? '已参加' : '未参加', item.hasSubmitAns == 1 ? Colors.green : primary)

            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            alignment: Alignment.topLeft,
            child: Html(data: model.vote?.voteDesc ?? ''),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('发布部门:${model.vote.author}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text('发布时间:${dateYearMothAndDayAndMinutes(model.vote.publicTime.replaceAll(".000", ""))}', style: const TextStyle(fontSize: 12, color: Colors.grey))
            ],
          )
        ],
      ),
    );
  }

  _buildContent() {
    return (isVoted || isVoteEnd || isVoteUnBegin)  ? _buildOptionsResult() : _buildOptions();
  }

  _buildOptions() {
    return model?.voteOptions?.map((VoteOptions option) {
      int index = model.voteOptions.indexOf(option);
      return model?.vote?.voteType == 0
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
    return model?.voteOptions?.map((VoteOptions option) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Radio(value: option.id, groupValue: 0, onChanged: null),
              Container(
                width: Utils.width - 100,
                child: Text('${option.voteLabel}  ${option.voteName}',
                    style:
                    const TextStyle(color: HiColor.dark_text, fontSize: 13)),
              )
            ],
          ),
          Container(
            width: Utils.width,
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Row(
              children: [
                Expanded(child: EProgress(
                    textInside: true,
                    strokeWidth: 12,
                    strokeCap: StrokeCap.square,
                    colors: const [primary],
                    progress: _process(option.optionSumDetailResult))),
                hiSpace(width: 3),
                Text('${option.optionSumDetailResult?.userSum ?? 0}人', style: const TextStyle(fontSize: 12, color: Colors.black54))
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
      return ((t1/t2)*100).toInt();
    } catch (e) {
      return 0;
    }
  }

  _buildRadio() {
    return Column(children: [
      Container(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
            children: model != null
                ? _buildContent()
                : [const Text('加载中...')]),
      ),
      // Container(
      //   margin: const EdgeInsets.only(left: 10, top: 10),
      //   child: (isVoted || isVoteEnd)  ? Container() :_buildBottom(),
      // )
    ]);
  }

  _buildBottom() {
    return Row(
      children: [
        RaisedButton(
          onPressed: onVote,
          color: primary,
          child: const Text(
            '提交',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        hiSpace(width: 20),
        RaisedButton(
          onPressed: (){
            if (!isVoted) {
              showWarnToast("提交了之后才能查看结果哦~");
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
        showWarnToast("请选择答案后提交");
        return;
      }

      EasyLoading.show(status: '加载中...');
      List options = [];
      for (int i = 0; i < selectedOptions.length; i++) {
        Map<String, dynamic> option = {};
        option['voteId'] = model.vote.id;
        option['voteOptionId'] = selectedOptions[i].id;
        option['voteLabel'] = selectedOptions[i].voteLabel;
        options.add(option);
      }
      var jsons = json.encode(options);
      var result = await WeeklyContestDao.submit(jsons);
      print(result);
      var bus = EventNotice();
      bus.formId = widget.id;
      eventBus.fire(bus);
      EasyLoading.dismiss(animation: false);
      _loadData();
    } catch (e) {
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

