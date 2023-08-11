import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/dao/file_dao.dart';
import 'package:chnsmile_flutter/http/dao/home_work_dao.dart';
import 'package:chnsmile_flutter/model/attach.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/model/home_work_detail_model.dart';
import 'package:chnsmile_flutter/model/home_work_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/attach_list.dart';
import 'package:chnsmile_flutter/widget/audio/demo_common.dart';
import 'package:chnsmile_flutter/widget/audio/temp_file.dart';
import 'package:chnsmile_flutter/widget/hi_button.dart';
import 'package:chnsmile_flutter/widget/hi_button2.dart';
import 'package:chnsmile_flutter/widget/hi_picture.dart';
import 'package:chnsmile_flutter/widget/login_button.dart';
import 'package:chnsmile_flutter/widget/oa_attach_detail.dart';
import 'package:chnsmile_flutter/widget/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:chnsmile_flutter/flutter_sound/flutter_sound.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

class HomeWorkDetailPage extends StatefulWidget {
  final Map params;
  String id;
  bool isFromOA = false;

  HomeWorkDetailPage({Key key, this.params}) : super(key: key) {
    id = params['id'];
    isFromOA = params['isFromOA'];
  }

  @override
  _HomeWorkDetailPageState createState() => _HomeWorkDetailPageState();
}

class _HomeWorkDetailPageState extends HiState<HomeWorkDetailPage> {
  HomeWorkDetailModel model;
  Track track;
  String audioPath;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: Container(
          color: Colors.white,
          child: RefreshIndicator(
              child: ListView(
                children: [
                  hiSpace(height: 10),
                  _buildContent(),
                  hiSpace(height: 10),
                  isNeedReed ? _buildButton() : Container()
                ],
              ),
              onRefresh: loadData),
        ));
  }

  // 需要家长点击确认
  bool get isNeedReed {
    return model?.userOperateType == 1;
  }

  // 家长以及确认
  bool get isReed {
    return model?.readStatus == 2;
  }

  // 需要未读
  bool get isUnRead {
    return model?.readStatus == 0;
  }

  _buildButton() {
    return isReed ? Container() : Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
      child: LoginButton("确认已阅读",
          height: 40, onPressed: () {
            _onChangeStatus(status: 2);
          }),
    );
  }

  _onChangeStatus({int status = 1}) async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await HomeWorkDao.read(model.id, status);
      var bus = EventNotice();
      bus.formId = model.id;
      eventBus.fire(bus);
      print(result);
      EasyLoading.dismiss(animation: false);
      if (isNeedReed) {
        BoostNavigator.instance.pop();
      }
    } on NeedAuth catch (e) {
      EasyLoading.dismiss(animation: false);
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      EasyLoading.dismiss(animation: false);
      print(e);
      showWarnToast(e.message);
    }
  }

  Future<void> loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await HomeWorkDao.detail(widget.id);
      // 下载
      if (result != null &&
          result.attachInfoList != null &&
          result.attachInfoList.isNotEmpty) {
        List<Attach> audioItems = [];
        for (var attach in result.attachInfoList) {
          if (isAudioType(attach.attachSuffix) && isNotEmpty(attach.attachUrl)) {
            audioItems.add(attach);
          }
        }
        if (audioItems.isNotEmpty) {
          for(var item in audioItems) {
            tempFile(fileName: item.origionName).then((path) {
              print("path: $path");
              if (!fileExists(path)) {
                print("path1: $path");
                var r = FileDao.download(item.attachUrl, path);
              }
              item.attachUrl = path;
              audioPath = path;

              setState(() {
                model = result;
                track = Track(trackPath: audioPath);
              });
              EasyLoading.dismiss(animation: false);
            });

          }
        } else {
          setState(() {
            model = result;
          });
        }
      } else {
        setState(() {
          model = result;
        });
      }
      // 无需操作 , 未读状态
      if (model.userOperateType == 0) {
        _onChangeStatus();
      }
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      print(e);
      showWarnToast(e.message);
    }
  }

  _buildAppBar() {
    return appBar('作业详情');
  }

  _buildTop() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
      decoration: BoxDecoration(border: borderLine(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '发布人@${model?.publicUserName}',
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          Text(model?.publicTime ?? '',
              style: const TextStyle(fontSize: 12, color: Colors.grey))
        ],
      ),
    );
  }

  _buildContent() {
    if (model == null) return Container();
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model?.title ?? '',
            style: const TextStyle(
                fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          hiSpace(height: 12),
          Text(
            model?.content ?? '',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          hiSpace(height: 12),
          _buildAttach(),
          _buildAudio(),
          hiSpace(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '发布人: ${model?.publicUserName ?? ''}',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              Text(
                '发布时间: ${model?.publicTime ?? ''}',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildAudio() {
    if (track == null) return Container();
    return SoundPlayerUI.fromTrack(
      track,
      showTitle: true,
      audioFocus: AudioFocus.requestFocusAndDuckOthers,
    );
  }

  _buildAttach() {
    if (model != null &&
        model.attachInfoList != null &&
        model.attachInfoList.isNotEmpty) {
      return OAAttachDetail(items: model.attachInfoList);
    } else {
      return Container();
    }
  }
}
