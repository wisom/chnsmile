import 'package:chnsmile_flutter/model/teacher_transcript1_model.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';

class TeacherTranscript1Card extends StatelessWidget {
  final TeacherTranscript1 item;
  final ValueChanged<TeacherTranscript1> onCellClick;

  const TeacherTranscript1Card({Key key, this.item, this.onCellClick})
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
              const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 10),
          child: Column(
            children: [_buildContent()],
          ),
        ));
  }

  _buildContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: Text(
          item.label ?? '',
          style: const TextStyle(fontSize: 15, color: Colors.black87),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
        const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
      ],
    );
  }
}
