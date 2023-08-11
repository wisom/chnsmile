import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/http/dao/home_work_dao.dart';
import 'package:chnsmile_flutter/model/event_notice2.dart';
import 'package:chnsmile_flutter/model/teacher_home_work_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/list_utils.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/home_work/teacher_home_work_card.dart';
import 'package:chnsmile_flutter/widget/loading_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TeacherHomeWorkPage extends StatefulWidget {

  TeacherHomeWorkPage({Key key}) : super(key: key);

  @override
  _TeacherHomeWorkPageState createState() => _TeacherHomeWorkPageState();
}

class _TeacherHomeWorkPageState
    extends OABaseTabState<TeacherHomeWorkModel, HomeWork, TeacherHomeWorkPage> {
  StreamController<AudioPlayer> _streamController =
      StreamController.broadcast();
  AudioPlayer _audioPlayer; // 音频播放器

  bool isEnable = false;

  void loadDefaultData() async {
    var result = await HomeDao.getP(HomeDao.schoolHomeworkNoticeAdd);
    setState(() {
      isEnable = result;
    });
  }

  @override
  void initState() {
    super.initState();
    loadDefaultData();
    _streamController.stream.listen((event) {
      //当前控制器ID != 传递过来的标识 说明当前传递的是新的标识
      if (_audioPlayer != null && _audioPlayer.playerId != event.playerId) {
        _audioPlayer.pause();
      }
      _audioPlayer = event;
      print("接收到消息${_audioPlayer.playerId}");
    });
    eventBus.on<EventNotice2>().listen((event) {
      setState(() {
        loadData();
      });
    });
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  void onPageShow() {
    ListUtils.cleanSelecter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: LoadingContainer(
            isEmpty: isEmpty,
            isLoading: false,
            child: Column(children: [Expanded(child: super.build(context))])));
  }

  _appBar() {
    return appBar("作业",
        isEnable: isEnable,
        rightTitle: "添加",
        rightButtonClick: onAddClick);
  }

  onAddClick() async {
      BoostNavigator.instance.push('teacher_home_work_add_page').then((value){
        if (value == "success") {
          loadData();
        }
      });
  }

  @override
  get contentChild => ListView.builder(
      itemCount: dataList?.length,
      physics: const AlwaysScrollableScrollPhysics(),
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) => TeacherHomeWorkCard(
          item: dataList[index],
          streamController: _streamController));

  @override
  Future<TeacherHomeWorkModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      TeacherHomeWorkModel result = await HomeWorkDao.getTeacherList(pageIndex: pageIndex);
      EasyLoading.dismiss(animation: false);
      return result;
    } catch (e) {
      EasyLoading.dismiss(animation: false);
    }
  }

  @override
  List<HomeWork> parseList(TeacherHomeWorkModel result) {
    return result != null ? result.rows : [];
  }
}
