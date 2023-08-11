import 'package:chnsmile_flutter/model/attach.dart';
import 'package:chnsmile_flutter/model/notice_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/attach_grid.dart';
import 'package:chnsmile_flutter/widget/hi_picture.dart';
import 'package:chnsmile_flutter/widget/level_text.dart';
import 'package:chnsmile_flutter/widget/oa_attach_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';


class NoticeCard extends StatelessWidget {
  final Notice notice;
  final ValueChanged<Notice> onCellClick;

  const NoticeCard({Key key, this.notice, this.onCellClick}) : super(key: key);

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
              hiSpace(height: 6),
              _buildContent(),
              hiSpace(height: 10),
              _buildAttach(),
              _buildTime()],
          ),
        ));
  }

  void handleClick(BuildContext context) {
    // 显示对话框
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('通知详情', style: TextStyle(fontSize: 18)),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Html(data: notice.content),
                  hiSpace(height: 10),
                  Row(
                    children: [
                      const Text('发布人:',
                          style: TextStyle(
                              fontSize: 13, color: HiColor.dark_text)),
                      Text(notice.publicUserName,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.blue)),
                    ],
                  ),
                  hiSpace(height: 6),
                  Row(
                    children: [
                      const Text('发布时间:',
                          style: TextStyle(fontSize: 13, color: Colors.red)),
                      Text(notice.publicTime ?? '',
                          style: const TextStyle(
                              fontSize: 13, color: HiColor.dark_text)),
                    ],
                  )
                ],
              ),
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    if (notice.userOperateType == 1 && notice.readStatus == 0) {
                      // onRead(notice);
                    }
                    Navigator.of(context).pop();
                  },
                  child: notice.userOperateType == 1
                      ? const Text('确认已阅读',
                          style: TextStyle(fontSize: 16, color: primary))
                      : const Text('关闭',
                          style: TextStyle(fontSize: 16, color: Colors.grey)))
            ],
          );
        });

    // 请求网络 , 未读状态
    if (notice.userOperateType == 0 && notice.readStatus == 0) {
      // onRead(notice);
    }
  }

  _buildContent() {
    return Container(
        alignment: Alignment.centerLeft,
        child:  Text(
          removeHtmlTag(notice.content) ?? '',
          style: const TextStyle(fontSize: 13, color: Colors.grey),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        )
    );
    // return Container(
    //   alignment: Alignment.centerLeft,
    //     child: Html(data: notice.content)
    // );
  }

  //  readStatus 0未读 1 已读 2 确认已读 3 签字已读
  _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        LevelText(level: notice.urgencyType),
        hiSpace(width: 10),
        Expanded(child: Text(
          notice.title ?? '',
          style: const TextStyle(fontSize: 16, color: HiColor.dark_text),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
        Container(
          child: notice.readStatus == 0
              ? buildReadUnReadStatus(isOnlyRead ? '未读' : '未确认', Colors.grey)
              : buildReadUnReadStatus(isOnlyRead ? '已读' : '已确认', Colors.green)
        )
      ],
    );
  }

  bool get isOnlyRead {
    return notice?.userOperateType == 0;
  }

  _buildAttach() {
    if (notice != null &&
        notice.attachInfoList != null &&
        notice.attachInfoList.isNotEmpty) {
      return Container(
        alignment: Alignment.centerLeft,
        child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            children: notice.attachInfoList.map((Attach attach) {
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
        Text('发布人:${notice?.publicUserName ?? ''}',
            style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Text('发布时间:${notice?.publicTime ?? ''}',
            style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }
}
