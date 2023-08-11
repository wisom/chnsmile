import 'package:chnsmile_flutter/model/attach.dart';
import 'package:chnsmile_flutter/model/teacher_notice_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/level_text.dart';
import 'package:chnsmile_flutter/widget/oa_attach_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hi_base/view_util.dart';
import 'package:html/parser.dart';

class TeacherNoticeCard extends StatelessWidget {
  final TeacherNotice item;
  final ValueChanged<TeacherNotice> onCellClick;

  const TeacherNoticeCard({Key key, this.item, this.onCellClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onCellClick(item);
        },
        child: Container(
          decoration: BoxDecoration(border: borderLine(context)),
          padding:
              const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
          child: Column(
            children: [
              _buildTitle(),
              hiSpace(height: 10),
              _buildContent(),
              hiSpace(height: 10),
              _buildAttach(),
              hiSpace(height: 10),
              _buildTime()
            ],
          ),
        ));
  }

  _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        LevelText(level: item.urgencyType),
        hiSpace(width: 10),
        Expanded(
            child: Text(
          item.title ?? '',
          style: const TextStyle(fontSize: 13, color: Colors.black),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        )),
      ],
    );
  }

  _buildContent() {
    return Container(
        alignment: Alignment.centerLeft,
        child:  Text(
          removeHtmlTag(item.content) ?? '',
          style: const TextStyle(fontSize: 13, color: Colors.grey),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        )
    );
    // return Container(
    //   alignment: Alignment.centerLeft,
    //     child: Html(data: item.content)
    // );
  }

  _buildAttach() {
    if (item != null &&
        item.attachInfoList != null &&
        item.attachInfoList.isNotEmpty) {
      return Container(
        alignment: Alignment.centerLeft,
        child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            children: item.attachInfoList.map((Attach attach) {
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

  _buildTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            item.status != 0
                ? item.updateTime != null && item.updateTime != "" ?
                   Text('修改于: ${dateYearMothAndDayAndMinutes(item.updateTime ?? '')}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey))
                  : Text(
                    '发布时间: ${dateYearMothAndDayAndMinutes(item.publicTime ?? '')}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey))
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
          buildTeacherSchoolVoteStatus(item.status)[1],
                style: TextStyle(
                    fontSize: 13, color: buildTeacherSchoolVoteStatus(item.status)[0]),
              )
      ],
    );
  }
}
