import 'dart:convert';

import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/dao/vote_dao.dart';
import 'package:chnsmile_flutter/model/vote_detail_model.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/utils.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/vote_card.dart';
import 'package:ele_progress/ele_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class VoteDetailResultPage extends StatefulWidget {
  final Map params;
  String voteId;

  VoteDetailResultPage({Key key, this.params}) : super(key: key) {
    voteId = params['voteId'];
  }

  @override
  _VoteDetailResultPageState createState() => _VoteDetailResultPageState();
}

class _VoteDetailResultPageState extends HiState<VoteDetailResultPage> {
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
        child: voteDetailModel != null
            ? Column(
          children: [VoteCard(vote: voteDetailModel.vote), _buildRadio()],
        )
            : Container(),
      ),
    );
  }

  void _loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      VoteDetailModel result = await VoteDao.voteDetail(widget.voteId);
      setState(() {
        voteDetailModel = result;
        isChecks = List.filled(voteDetailModel.voteOptions?.length, false);
        EasyLoading.dismiss(animation: false);
      });
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

  _buildContent() {
    return (isVoted || isVoteEnd)  ? _buildOptionsResult() : _buildOptions();
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
              const TextStyle(color: HiColor.dark_text, fontSize: 15)),
          value: option.id,
          groupValue: optionValue,
          onChanged: (optionId) {
            setState(() {
              optionValue = optionId;
            });
          })
          : CheckboxListTile(
          activeColor: primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: const EdgeInsets.only(left: 10, top: 0),
          title: Text('${option.voteLabel}  ${option.voteName}',
              style:
              const TextStyle(color: HiColor.dark_text, fontSize: 15)),
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
                  const TextStyle(color: HiColor.dark_text, fontSize: 15))
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
                Text('${option.optionSumDetailResult?.userSum}人', style: const TextStyle(fontSize: 12, color: Colors.black54))
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
            children: voteDetailModel != null
                ? _buildContent()
                : [const Text('加载中...')]),
      ),
      Container(
        margin: const EdgeInsets.only(left: 10, top: 10),
        child: (isVoted || isVoteEnd)  ? Container() :_buildBottom(),
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
          onPressed: (){
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
      EasyLoading.dismiss(animation: false);
      BoostNavigator.instance.pop();
    } on HiNetError catch (e) {
      EasyLoading.dismiss(animation: false);
      print(e);
      showWarnToast(e.message);
    }
  }

  onVoteDetail() {
    if (!isVoted) {
      showWarnToast("投票了之后才能查看结果哦~");
      return;
    }

    BoostNavigator.instance.push('vote_detail_result_page',
        arguments: {"voteId": voteDetailModel?.vote?.voteId});
  }

  onChanged(v) {
    setState(() {
      optionValue = v;
    });
  }
}
