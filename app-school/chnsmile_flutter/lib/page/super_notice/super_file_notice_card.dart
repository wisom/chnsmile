import 'package:chnsmile_flutter/model/document_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';

import '../../model/super_file_model.dart';
import '../../model/super_notice_model.dart';
import '../../widget/level2_text.dart';

class SuperNoticeListCard extends StatelessWidget {
  final SuperNotice notice;
  final ValueChanged<SuperNotice> onCellClick;
  final String type;

  const SuperNoticeListCard({Key key, this.notice, this.onCellClick, this.type})
      : super(key: key);


  @override
  void initState() {
    print("SuperNoticeListCard==="+notice.toString());
  }

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
              // _buildAttach(),
              // hiSpace(height: 10),
              _buildTime()
            ],
          ),
        ));
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
        _buildTag()
      ],
    );
  }

  _buildTag(){
    if(notice.approveStatus==1){
      return  buildReadUnReadStatus('待读', Colors.grey);
    }else if(notice.approveStatus==2){
      return buildReadUnReadStatus('已读', Colors.green);
    }else if(notice.approveStatus==3){
      return buildReadUnReadStatus('已回复', Colors.green);
    }else {
      return buildReadUnReadStatus('待回复', Colors.grey);
    }
  }

  _buildContent() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(notice.content??"",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, color: Colors.grey)),
    );
  }

  // _buildAttach() {
  //   if (notice != null &&
  //       notice.infoEnclosureList != null &&
  //       notice.infoEnclosureList.isNotEmpty) {
  //     return Container(
  //       alignment: Alignment.centerLeft,
  //       child: Wrap(
  //           direction: Axis.horizontal,
  //           alignment: WrapAlignment.start,
  //           children: notice.infoEnclosureList.map((Attach attach) {
  //             return OAAttachGrid(
  //                 title: attach.origionName,
  //                 suffix: attach.attachSuffix,
  //                 url: attach.attachUrl);
  //           }).toList()),
  //     );
  //   } else {
  //     return Container();
  //   }
  // }

  _buildTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // isSend
        //     ? ((isReplay && notice.notReplyCount != null && notice.notReplyCount > 0)
        //     ?
        Row(
          children: [
            Text('${notice.notReplyCount ?? 0}名老师未确认',
                style: const TextStyle(
                    fontSize: 12, color: Colors.orange)),
          ],
        // )
            // : Container())
        //     : Row(
        //   children: [
        //     Text('发起人: ${notice.createName ?? ''}',
        //         style: const TextStyle(fontSize: 12, color: Colors.grey)),
        //   ],
        ),
        Row(
          children: [
            Text('发布时间: ${notice.createTime ?? ''}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}