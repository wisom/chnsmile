import 'dart:async';

import 'package:chnsmile_flutter/model/attach.dart';
import 'package:chnsmile_flutter/model/home_work_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/oa_attach_grid.dart';
import 'package:chnsmile_flutter/widget/player_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class HomeWorkCard extends StatelessWidget {
  final HomeWork homeWork;
  final StreamController streamController;
  List<String> audioList = [];

  HomeWorkCard({Key key, this.homeWork, this.streamController})
      : super(key: key) {
    if (homeWork.attachInfoList != null && homeWork.attachInfoList.isNotEmpty) {
      homeWork.attachInfoList.forEach((item) {
        if (isAudioType(item.attachSuffix)) {
          audioList.add(item.attachUrl);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          BoostNavigator.instance
              .push('home_work_detail_page', arguments: {"id": homeWork.id});
        },
        child: Container(
      decoration: BoxDecoration(border: borderLine(context)),
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
      child: Column(
        children: [_buildTitle(), hiSpace(height: 6),_buildContent(), hiSpace(height: 10), _buildTime()],
      ),
    ));
  }

  bool get isOnlyRead {
    return homeWork?.userOperateType == 0;
  }

  // readStatus  状态（字典 0未读 1 已读 2 确认已读 3 签字已读）
  _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(child: Text(
          homeWork.title ?? '',
          style: const TextStyle(fontSize: 16, color: HiColor.dark_text),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
        Container(
            child: homeWork.readStatus == 0
                ? buildReadUnReadStatus(isOnlyRead ? '未读' : '未确认', Colors.grey)
                : buildReadUnReadStatus(isOnlyRead ? '已读' : '已确认', Colors.green)
        )
      ],
    );
  }

  _buildContent() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          homeWork.content != null ? _contentText() : Container(),
          // audioList.isNotEmpty ? _contentAudio() : Container(),
          hiSpace(height: 10),
          _buildAttach()
        ],
      ),
    );
  }

  _buildAttach() {
    if (homeWork != null &&
        homeWork.attachInfoList != null &&
        homeWork.attachInfoList.isNotEmpty) {
      return Container(
        alignment: Alignment.centerLeft,
        child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            children: homeWork.attachInfoList.map((Attach attach) {
              return OAAttachGrid(
                  title: attach.origionName,
                  suffix: attach.attachSuffix,
                  url: attach.attachUrl);
            }).toList()),
      );
    } else {
      return Container();
    }
  }

  _contentAudio() {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      height: 40,
      padding: const EdgeInsets.only(left: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(width: 0.5, color: Colors.grey[300])),
      child: PlayerWidget(audioList[0],
          onTap: () {
            BoostNavigator.instance
                .push('home_work_detail_page', arguments: {"id": homeWork.id});
          },
          streamController: streamController),
    );
  }

  _contentText() {
    return Row(
      children: [
        Expanded(
            child: Text(
              homeWork.content ?? '',
              style: const TextStyle(fontSize: 15, color: Colors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )),
      ],
    );
  }

  _buildTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('发布人:${homeWork?.publicUserName ?? ''}',
            style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Text('发布时间:${homeWork?.publicTime != null ? dateYearMothAndDayAndMinutes(homeWork?.publicTime.replaceAll(".000", "") ?? '') : ""}',
            style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }

}
