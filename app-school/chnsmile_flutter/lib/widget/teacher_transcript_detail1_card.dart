import 'package:chnsmile_flutter/model/teacher_transcript_detail1_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/base_expandable_content.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';

class TeacherTranscriptDetail1Card extends StatefulWidget {
  final TeacherTranscriptDetail1 item;

  const TeacherTranscriptDetail1Card({Key key, this.item}) : super(key: key);

  @override
  _TeacherTranscriptDetail1CardState createState() =>
      _TeacherTranscriptDetail1CardState();
}

class _TeacherTranscriptDetail1CardState
    extends BaseExpandableContentState<TeacherTranscriptDetail1Card> {
  @override
  buildContent() {
    if (widget.item == null ||
        widget.item.studentScoreList == null ||
        widget.item.studentScoreList.isEmpty) {
      return Container();
    }
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.item.studentScoreList.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          var item = widget.item.studentScoreList[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 36,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildRating(index, item),
                    hiSpace(width: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(19),
                      child: Stack(
                        children: [
                          cachedImage(item.studentAvatar,
                              width: 32,
                              height: 32,
                              placeholder: "images/default_avator.png")
                        ],
                      ),
                    ),
                    hiSpace(width: 10),
                    Expanded(
                        child: Text(
                      item.studentName ?? '',
                      style:
                          const TextStyle(fontSize: 15, color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                    Text('${item.totalScore}分',
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black87))
                  ],
                ),
              ),
              index != widget.item.studentScoreList.length - 1
                  ? boxLine(context)
                  : Container()
            ],
          );
        });
  }

  @override
  buildTop() {
    return Row(
      children: [
        Container(
            width: 100,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: randomColor(), borderRadius: BorderRadius.circular(3)),
            child: Text(
              widget.item.courseName ?? '',
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ))
      ],
    );
  }

  @override
  double topHeight() {
    return 40;
  }

  _buildRating(int index, StudentScoreList item) {
    if (index == 0 || index == 1 || index == 2) {
      return Image(
          image: AssetImage('images/icon_rating_${index + 1}.png'),
          width: 20,
          height: 20);
    } else {
      return Container(
        child: Text('${index + 1}',
            style: const TextStyle(fontSize: 16, color: Colors.black87)),
        padding: const EdgeInsets.only(left: 10, right: 10),
      );
    }
  }
}
