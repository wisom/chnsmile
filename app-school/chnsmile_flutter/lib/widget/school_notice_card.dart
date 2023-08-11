import 'package:chnsmile_flutter/model/attach.dart';
import 'package:chnsmile_flutter/model/school_notice_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/level2_text.dart';
import 'package:chnsmile_flutter/widget/level_text.dart';
import 'package:chnsmile_flutter/widget/oa_attach_grid.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';

class SchoolNoticeCard extends StatelessWidget {
  final SchoolNotice notice;
  final String type; // 'send' : 'receive';
  final ValueChanged<SchoolNotice> onCellClick;

  const SchoolNoticeCard({Key key, this.notice, this.onCellClick, this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onCellClick(notice);
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

  bool get isSend {
    return type == 'send';
  }

  bool get isReceive {
    return type == 'receive';
  }

  bool get isOnlyRead {
    return notice?.process == 1;
  }

  bool get isReplay {
    return notice?.process == 2;
  }

  _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Level2Text(level: notice.grade),
        hiSpace(width: 10),
        Expanded(
            child: Text(
          notice.title ?? '',
          style: const TextStyle(fontSize: 13, color: Colors.black),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
        isSend
            ? notice.status == 1
                ? buildReadUnReadStatus('已发出', Colors.green)
                : buildReadUnReadStatus('未发出', Colors.grey)
            : notice.approveStatus == 2
                ? buildReadUnReadStatus(isOnlyRead ? '已读' : '已回复', Colors.green)
                : buildReadUnReadStatus(isOnlyRead ? '未读' : '未回复', Colors.red)
      ],
    );
  }

  _buildContent() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(notice.content,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 13, color: Colors.grey)),
    );
  }

  _buildAttach() {
    if (notice != null &&
        notice.infoEnclosureList != null &&
        notice.infoEnclosureList.isNotEmpty) {
      return Container(
        alignment: Alignment.centerLeft,
        child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            children: notice.infoEnclosureList.map((Attach attach) {
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
        isSend
            ? ((isReplay && notice.notReplyCount != null && notice.notReplyCount > 0)
                ? Row(
                    children: [
                      Text('${notice.notReplyCount ?? 0}名老师未${isOnlyRead?'阅读':'回复'}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.orange)),
                    ],
                  )
                : Container())
            : Row(
                children: [
                  Text('发起人: ${notice.cname ?? ''}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
        Row(
          children: [
            Text('发布时间: ${notice.releaseDate ?? ''}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}
