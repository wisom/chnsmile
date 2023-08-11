import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/dao/vote_dao.dart';
import 'package:chnsmile_flutter/model/vote_school_detail_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/utils.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:ele_progress/ele_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class SchoolVoteDetailPage extends StatefulWidget {
  final Map params;
  String voteId;

  SchoolVoteDetailPage({Key key, this.params}) : super(key: key) {
    voteId = params['voteId'];
  }

  @override
  _SchoolVoteDetailPageState createState() => _SchoolVoteDetailPageState();
}

class _SchoolVoteDetailPageState extends HiState<SchoolVoteDetailPage> {
  VoteSchoolDetailModel voteDetailModel;
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
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: voteDetailModel != null
            ? ListView(
                children: [
                  _buildTime(),
                  hiSpace(height: 10),
                  _buildTitle(),
                  _buildContent1(),
                  _buildRadio()
                ],
              )
            : Container(),
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
              child: Text('0人',
                  style: const TextStyle(fontSize: 12, color: Colors.white)),
            ),
            Text(voteDetailModel?.voteTitle ?? '',
                style: const TextStyle(fontSize: 13, color: HiColor.dark_text))
          ],
        ),
        Container(
          width: Utils.width - 100,
          child: Text(
              buildSchoolVoteStatus(voteDetailModel.voteStatus)[1],
              maxLines: 10,
              style: TextStyle(
                  color: buildSchoolVoteStatus(voteDetailModel.voteStatus)[0])),
        )
      ],
    );
  }

  _buildContent1() {
    return Container(
        alignment: Alignment.topLeft,
        child: Html(data: voteDetailModel.voteDesc ?? ''));
  }

  _buildTime() {
    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            child:  Text(voteDetailModel.voteType == 0 ? '单选' : '多选',
                style: const TextStyle(fontSize: 12, color: Colors.red))),
        hiSpace(height: 3),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Text(
                        '开始时间:${dateYearMothAndDayAndMinutes(voteDetailModel.startTime.replaceAll(".000", ""))}',
                        style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                )),
            Expanded(
                flex: 1,
                child: Text(
                    '结束时间:${dateYearMothAndDayAndMinutes(voteDetailModel.endTime.replaceAll(".000", ""))}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 11, color: Colors.grey)))
          ],
        )
      ],
    );
  }

  void _loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      VoteSchoolDetailModel result =
          await VoteDao.voteSchoolDetail(widget.voteId);
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
    return false;
  }

  bool get isVoteEnd {
    return voteDetailModel.voteStatus == 2;
  }

  _buildContent() {
    return (isVoted || isVoteEnd) ? _buildOptionsResult() : _buildOptions();
  }

  _buildOptions() {
    return voteDetailModel?.voteOptions?.map((VoteOptions option) {
      int index = voteDetailModel.voteOptions.indexOf(option);
      return voteDetailModel.voteType == 0
          ? RadioListTile(
              activeColor: primary,
              contentPadding: const EdgeInsets.only(left: 10, top: 0),
              title: Text('${option.voteName}',
                  style:
                      const TextStyle(color: HiColor.dark_text, fontSize: 15)),
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
              title: Text('${option.voteName}',
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
              Text('${option.voteName}',
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
                        progress: _process())),
                hiSpace(width: 3),
                Text('x人',
                    style: const TextStyle(fontSize: 12, color: Colors.black54))
              ],
            ),
          )
        ],
      );
    })?.toList();
  }

  int _process() {
    // try {
    //   if (option == null || int.parse(option.voteCount) == 0) {
    //     return 0;
    //   }
    //   double t1 = double.parse(option.userSum);
    //   double t2 = double.parse(option.voteCount);
    //   return ((t1 / t2) * 100).toInt();
    // } catch (e) {
    //   return 0;
    // }
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
    ]);
  }

  onChanged(v) {
    setState(() {
      optionValue = v;
    });
  }
}
