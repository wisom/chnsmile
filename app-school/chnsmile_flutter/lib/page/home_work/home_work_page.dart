import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:chnsmile_flutter/core/oa_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/home_work_dao.dart';
import 'package:chnsmile_flutter/model/event_notice.dart';
import 'package:chnsmile_flutter/model/home_work_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/home_work/home_work_card.dart';
import 'package:chnsmile_flutter/widget/loading_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HomeWorkPage extends StatefulWidget {
  final Map params;
  bool isFromOA = false;

  HomeWorkPage({Key key, this.params}) : super(key: key) {
    isFromOA = params.isNotEmpty ? params['isFromOA'] : false;
  }

  @override
  _HomeWorkPageState createState() => _HomeWorkPageState();
}

class _HomeWorkPageState
    extends OABaseTabState<HomeWorkModel, HomeWork, HomeWorkPage> {
  StreamController<AudioPlayer> _streamController =
      StreamController.broadcast();
  AudioPlayer _audioPlayer; // 音频播放器

  @override
  void initState() {
    super.initState();
    _streamController.stream.listen((event) {
      //当前控制器ID != 传递过来的标识 说明当前传递的是新的标识
      if (_audioPlayer != null && _audioPlayer.playerId != event.playerId) {
        _audioPlayer.pause();
      }
      _audioPlayer = event;
      print("接收到消息${_audioPlayer.playerId}");
    });

    eventBus.on<EventNotice>().listen((event) {
      setState(() {
        dataList.forEach((element) {
          if (element.id == event.formId) {
            element.readStatus = 1;
          }
        });
      });
    });
  }

  @override
  void onPageShow() {}

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
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
        rightTitle: widget.isFromOA ? "添加" : "",
        rightButtonClick: onAddClick());
  }

  onAddClick() {}

  @override
  get contentChild => ListView.builder(
      itemCount: dataList?.length,
      physics: const AlwaysScrollableScrollPhysics(),
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) => HomeWorkCard(
          homeWork: dataList[index], streamController: _streamController));

  @override
  Future<HomeWorkModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    try {
      HomeWorkModel result = await HomeWorkDao.getList(pageIndex: pageIndex);
      print("result: ${result}");
      EasyLoading.dismiss(animation: false);
      return result;
    } catch (e) {
      EasyLoading.dismiss(animation: false);
    }
  }

  @override
  List<HomeWork> parseList(HomeWorkModel result) {
    return result.rows;
  }
}
