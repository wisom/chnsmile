import 'dart:async';

import 'package:chnsmile_flutter/model/attach.dart';
import 'package:chnsmile_flutter/model/teacher_home_work_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/oa_attach_grid.dart';
import 'package:chnsmile_flutter/widget/player_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/view_util.dart';

class TeacherHomeWorkCard extends StatelessWidget {
  final HomeWork item;
  final StreamController streamController;
  List<String> audioList = [];

  TeacherHomeWorkCard({Key key, this.item, this.streamController})
      : super(key: key) {
    if (item.attachInfoList != null && item.attachInfoList.isNotEmpty) {
      item.attachInfoList.forEach((item) {
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
        if (item.status == 0) {
          // 未发布
          BoostNavigator.instance
              .push('teacher_home_work_add_page', arguments: {"id": item.id});
        } else {
          BoostNavigator.instance.push('teacher_home_work_detail_page',
              arguments: {"id": item.id});
        }
      },
      child: Container(
        decoration: BoxDecoration(border: borderLine(context)),
        padding:
            const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
        child: Column(
          children: [_buildContent(), hiSpace(height: 10), _buildTime()],
        ),
      ),
    );
  }

  _buildContent() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          hiSpace(height: 10),
          item.content != null ? _contentText() : Container(),
          // audioList.isNotEmpty ? _contentAudio() : Container(),
          hiSpace(height: 10),
          _buildAttach()
        ],
      ),
    );
  }

  _buildAttach() {
    if (item != null &&
        item.attachInfoList != null &&
        item.attachInfoList.isNotEmpty) {
      List<Attach> attachs = [];
      item?.attachInfoList?.forEach((attach) {
        if (!isAudioType(attach.attachSuffix)) {
          attachs.add(attach);
        }
      });
      return Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          children: attachs.map((Attach attach) {
            return OAAttachGrid(
              width: 50,
                        title: attach.origionName,
                        suffix: attach.attachSuffix,
                        url: attach.attachUrl);
          }).toList());
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
      child: PlayerWidget(audioList[0], onTap: () {
        BoostNavigator.instance
            .push('teacher_home_work_detail_page', arguments: {"id": item.id});
      }, streamController: streamController),
    );
  }

  _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          item.title ?? '',
          style: const TextStyle(fontSize: 15, color: Colors.black),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  _contentText() {
    return Row(
      children: [
        Expanded(
            child: Text(
              removeHtmlTag(item.content ?? ''),
          style: const TextStyle(fontSize: 13, color: Colors.grey),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ))
      ],
    );
  }

  _buildTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            item.status != 0
                ? item.updateTime != null && item.updateTime != ""
                    ? Text(
                        '修改于: ${dateYearMothAndDayAndMinutes(item.updateTime ?? '')}',
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey))
                    : Text(
                        '发布时间: ${dateYearMothAndDayAndMinutes(item.publicTime ?? '')}',
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey))
                : Container(),
          ],
        ),
        item.status == 1
            ? item.userOperateType == 1
                ? Text(
                    '已确认${item.noticeUserReadNum ?? 0}人 确认率${item.readRecent ?? '0%'}',
                    style: const TextStyle(fontSize: 12, color: Colors.orange))
                : Text(
                    '已查看${item.noticeUserReadNum ?? 0}人 查看率${item.readRecent ?? '0%'}',
                    style: const TextStyle(fontSize: 12, color: Colors.blue))
            : Text(
                buildSchoolVoteStatus(item.status)[1],
                style: TextStyle(
                    fontSize: 13, color: buildSchoolVoteStatus(item.status)[0]),
              )
      ],
    );
  }
}
