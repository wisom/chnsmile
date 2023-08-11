import 'package:chnsmile_flutter/model/document_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/utils.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

import '../../model/file_report_model.dart';
///文件发起-文件审批
class FileReportApproveCard extends StatelessWidget {
  final FileReport item;
  final ValueChanged<FileReport> onCellClick;
  final String type;

  const FileReportApproveCard(
      {Key key, this.item, this.onCellClick, this.type})
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
              const EdgeInsets.only(left: 8, right: 8, bottom: 5, top: 15),
          child: Column(
            children: [
              _buildContent(context),
              hiSpace(height: 5),
              Container(
                height: 32,
                child: _buildTime(),
              )
            ],
          ),
        ));
  }

  /// 公文通知进来的
  bool get isNotice {
    return type == "3";
  }

  /// 公文审批进来的
  bool get isApprove {
    return type == "2";
  }

  _buildContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                isApprove
                    ? Container(
                  width: Utils.width - 120,
                  child: Text(item.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style:
                      const TextStyle(fontSize: 13, color: Colors.black)),
                )
                    : Text('${item.cname}发出的文件流转 ',
                        style:
                            const TextStyle(fontSize: 13, color: Colors.black)),
                hiSpace(width: 6),
                isNotice
                    ? Text('${buildOAStatus(item.status)[1]}',
                        style: TextStyle(
                            fontSize: 12, color: buildOAStatus(item.status)[0]))
                    : Container()
              ],
            ),
            hiSpace(height: 10),
            isApprove ? Row(
              children: [
                Text('表单编号:${item.formId}',
                    style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ) : Container(
              width: Utils.width - 100,
              child: Text(item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
            )
          ],
        )),
        hiSpace(width: 12),
        isNotice ? (item.reviewStatus == 1 ? buildReadUnReadStatus('未读', Colors.red) : buildReadUnReadStatus('已读', Colors.green))
            : Container(
                height: 24,
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: buildOAApplyStatus(item.reviewStatus)[0],
                    borderRadius: BorderRadius.circular(12)),
                child: Text(
                  buildOAApplyStatus(item.reviewStatus)[1],
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              )
      ],
    );
  }

  bool get isRefuse {
    return item.reviewStatus == 3;
  }

  bool get isAgree {
    return item.reviewStatus == 2;
  }

  _buildTime() {
    return isApprove ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('发起人:${item.cname}',
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text('发起时间:${dateYearMothAndDayAndMinutes(item.ddate?.replaceAll(".000", ""))}',
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    ) : Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('表单编号:${item.formId}',
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text('通知时间:${dateYearMothAndDayAndMinutes(item.ddate.replaceAll(".000", ""))}',
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
