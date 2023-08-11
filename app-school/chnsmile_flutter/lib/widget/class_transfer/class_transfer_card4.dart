import 'package:chnsmile_flutter/model/class_transfer_model4.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class ClassTransferCard4 extends StatelessWidget {
  final ClassTransfer4 item;
  final ValueChanged<ClassTransfer4> onCellClick;

  const ClassTransferCard4({Key key, this.item, this.onCellClick})
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
              const EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
          child: Column(
            children: [
              _buildTop(), hiSpace(height: 4), hiSpace(height: 10), _buildContent(context)
            ],
          ),
        ));
  }

  _buildTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          const Text('表单编号:',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          Text(item.formId, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ]),
        Row(children: [
          const Text('建立日期:',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          Text(dateYearMothAndDay(item.ddate.replaceAll(".000", "")),
              style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ])
      ],
    );
  }

  _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 100,
              child: Row(children: [
                const Text('教师:',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(item.tealName, style: const TextStyle(fontSize: 12, color: Colors.black)),
              ]),
            ),
            Container(
              width: 180,
              child: Row(children: [
                const Text('班级:',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(item.clazzName,
                    style: const TextStyle(fontSize: 12, color: Colors.black)),
              ]),
            ),
            Row(children: [
              const Text('学科:',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(item.courseName,
                  style: const TextStyle(fontSize: 12, color: Colors.black)),
            ])
          ],
        ),
        hiSpace(height: 6),
        _buildClassItem(context)
      ],
    );
  }

  _buildClassItem(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 60,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(2)
          ),
          child: const Icon(Icons.swap_horiz, color: Colors.white, size: 24),
        ),
        Column(
          children: [
            Row(
              children: [
                Row(
                  children: [
                    const Text('原始日期:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text('${item.oldDate}', style: const TextStyle(fontSize: 12, color: Colors.black)),
                  ],
                ),
                hiSpace(width: 20),
                Row(
                  children: [
                    const Text('原始课程:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text('${item.oldNo}', style: const TextStyle(fontSize: 12, color: Colors.black)),
                  ],
                ),
              ],
            ),
            boxLine(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('调整日期:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text('${item.newDate}', style: const TextStyle(fontSize: 12, color: primary)),
                  ],
                ),
                hiSpace(width: 20),
                Row(
                  children: [
                    const Text('调整课程:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text('${item.newNo}', style: const TextStyle(fontSize: 12, color: primary)),
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
