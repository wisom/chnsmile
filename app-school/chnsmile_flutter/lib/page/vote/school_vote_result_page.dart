import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/dao/vote_dao.dart';
import 'package:chnsmile_flutter/model/school_vote_result_model.dart';
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

class SchoolVoteResultPage extends StatefulWidget {
  final Map params;
  String voteId;

  SchoolVoteResultPage({Key key, this.params}) : super(key: key) {
    voteId = params['voteId'];
  }

  @override
  _SchoolVoteResultPageState createState() => _SchoolVoteResultPageState();
}

class _SchoolVoteResultPageState extends HiState<SchoolVoteResultPage> {
  SchoolVoteResultModel model;
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
      appBar: appBar('校园投票结果'),
      body: Container(
        child: model != null
            ? Column(
                children: [_buildVoteContent(), _buildRadio()],
              )
            : Container(),
      ),
    );
  }

  void _loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await VoteDao.schoolVoteResult(widget.voteId);
      setState(() {
        model = result;
        isChecks = List.filled(model.voteOptions?.length, false);
        EasyLoading.dismiss(animation: false);
      });
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
      EasyLoading.dismiss(animation: false);
    }
  }

  _buildVoteContent() {
    return  Container(
      decoration: BoxDecoration(border: borderLine(context)),
      padding:
      const EdgeInsets.all(15),
      child: Column(
        children: [_buildTime(), hiSpace(height: 10), _buildTitle(), _buildContent()],
      ),
    );
  }

  _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 10),
              width: 48,
              height: 24,
              decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Text('${model?.vote?.noticeUserSum ?? '0'}人',
                  style: const TextStyle(fontSize: 12, color: Colors.white)),
            ),
            Text(model?.vote?.voteTitle??'',
                style: const TextStyle(fontSize: 13, color: HiColor.dark_text))
          ],
        ),
        Container(
          color: Colors.red,
          width: 88,
          height: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.equalizer, color: Colors.white),
              Text(model.vote?.voteStatusLabel,
                  style: const TextStyle(fontSize: 13, color: Colors.white))
            ],
          ),
        )
      ],
    );
  }

  _buildContent() {
    return Container(
        alignment: Alignment.topLeft,
        child: Html(data: model.vote?.voteDesc??'')
    );
  }

  _buildTime() {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Row(
              children: [
                Text(model.vote?.voteType == 0 ? '单选' : '多选', style: const TextStyle(fontSize: 12, color: Colors.red)),
                hiSpace(width: 4),
                Text('开始时间:${dateYearMothAndDayAndMinutes(model.vote.startTime.replaceAll(".000", ""))}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            )),
        Expanded(
            flex: 1,
            child:Text('结束时间:${dateYearMothAndDayAndMinutes(model.vote.endTime.replaceAll(".000", ""))}',
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 11, color: Colors.grey)))
      ],
    );
  }

  _buildOptionsResult() {
    return model?.voteOptions?.map((VoteOptions option) {
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
                Expanded(
                    child: EProgress(
                        textInside: true,
                        strokeWidth: 12,
                        strokeCap: StrokeCap.square,
                        colors: const [primary],
                        progress: _process(option.optionSumDetailResult))),
                hiSpace(width: 3),
                Text('${option.optionSumDetailResult?.userSum}人',
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
            children:
                model != null ? _buildOptionsResult() : [const Text('加载中...')]),
      )
    ]);
  }
}
