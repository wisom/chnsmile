import 'package:chnsmile_flutter/model/class_transfer_item.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/utils.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class ClassTransferWidget extends StatefulWidget {
  final ClassTransferItem item;
  final Function delete;

  const ClassTransferWidget({Key key, this.item, this.delete}) : super(key: key);

  @override
  _ClassTransferWidgetState createState() => _ClassTransferWidgetState();
}

class _ClassTransferWidgetState extends State<ClassTransferWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left:0, right:0, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Row(
                    children: [
                      Text('教师: ${widget.item.tealName}',
                          style:
                          const TextStyle(fontSize: 12, color: Colors.black)),
                      hiSpace(width: 4),
                      Text('班级: ${widget.item.clazzName}',
                          style:
                          const TextStyle(fontSize: 12, color: Colors.black)),
                      hiSpace(width: 4),
                      Text('学科: ${widget.item.courseName}',
                          style:
                          const TextStyle(fontSize: 12, color: Colors.black)),
                    ],
                  )),
              widget.delete != null ? buildSmallButton('删除', Colors.red, onClick: () {
                widget.delete();
              }) : Container(),
            ],
          ),
          hiSpace(height: 10),
          Row(
            children: [
              Container(
                width: 36,
                height: 66,
                decoration: BoxDecoration(
                    color: primary, borderRadius: BorderRadius.circular(2)),
                child:
                const Icon(Icons.swap_horiz, color: Colors.white, size: 24),
              ),
              Expanded(child: Container(
                height: 66,
                padding: const EdgeInsets.only(left: 4, top: 5, bottom: 5),
                color: Colors.grey[200],
                child: Column(
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            const Text('原始日期:',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            hiSpace(width: 2),
                            Text(widget.item.oldDate,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black)),
                          ],
                        ),
                        hiSpace(width: 6),
                        Row(
                          children: [
                            const Text('原始课程:',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            hiSpace(width: 2),
                            Text(widget.item?.oldNoName,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black)),
                          ],
                        ),
                      ],
                    ),
                    boxLine(context),
                    hiSpace(height: 6),
                    Row(
                      children: [
                        Row(
                          children: [
                            const Text('调整日期:',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            hiSpace(width: 3),
                            Text(widget.item.newDate,
                                style: const TextStyle(
                                    fontSize: 12, color: primary)),
                          ],
                        ),
                        hiSpace(width: 6),
                        Row(
                          children: [
                            const Text('调整课程:',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            hiSpace(width: 3),
                            Text(widget.item.newNoName,
                                style: const TextStyle(
                                    fontSize: 12, color: primary)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )),
              Container(
                height: 66,
                width: 48,
                alignment: Alignment.center,
                color: Colors.grey[200],
                child: Text(widget.item.approveRemark, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.black)),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            color: Colors.orange[100],
            child: Row(
              children: [
                Expanded(
                    child: Row(
                      children: [
                        Text('${widget.item.kinds == "1" ? "确认" : "通知"}人: ${widget.item.approveName ?? ''}',
                            style:
                            const TextStyle(fontSize: 12, color: Colors.black)),
                        hiSpace(width: 10),
                        Text(
                          _buildTypeText(),
                          style: const TextStyle(fontSize: 12, color: Colors.black),
                        ),
                        hiSpace(width: 10),
                        widget.item.status == 2 ? Text('${widget.item.kinds == "1" ? "确认" : "阅读"}时间: ${dateYearMothAndDayAndMinutes(widget.item.approveDate) ?? ''}',
                            style:
                            const TextStyle(fontSize: 12, color: Colors.black)) : Container(),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 状态 0等待、1待批/待读、2已批/已读、3拒批
  String _buildTypeText() {
    if (widget.item.type == 0) {
      return "";
    } else if (widget.item.type == 1) {
      return "等待";
    } else {
      if (widget.item.status == 1) {
        if (widget.item.kinds == "1") {
          return "待确认";
        } else {
          return "待读";
        }
      } else if (widget.item.status == 2) {
        if (widget.item.kinds == "1") {
          return "已确认";
        } else {
          return "已读";
        }
      }
    }
    return buildClassOAStatus1(widget.item.status)[1];
  }
}
