import 'package:chnsmile_flutter/model/teacher_transcript2_model.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/base_expandable_content.dart';
import 'package:flutter/material.dart';

class TeacherTranscript2Card extends StatefulWidget {
  final TeacherTranscript2 item;
  final ValueChanged<Student> onCellClick;

  const TeacherTranscript2Card({Key key, this.item, this.onCellClick}) : super(key: key);


  @override
  _TeacherTranscript2CardState createState() => _TeacherTranscript2CardState();
}

class _TeacherTranscript2CardState extends BaseExpandableContentState<TeacherTranscript2Card> {

  @override
  buildContent() {
    if (widget.item == null || widget.item.children == null || widget.item.children.isEmpty) {
      return Container();
    }
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.item.children.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          var item = widget.item.children[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  widget.onCellClick(item);
                },
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: Row(
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
                  ),
                ),
              ),
              index != widget.item.children.length -1 ? boxLine(context) : Container()
            ],
          );
        });
  }

  @override
  buildTop() {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: Text(widget.item.label ?? '', style: const TextStyle(fontSize: 15, color: Colors.black)),
    );
  }

  @override
  double topHeight() {
    return 40;
  }
}

