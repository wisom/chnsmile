import 'package:chnsmile_flutter/model/transcript_model.dart';
import 'package:chnsmile_flutter/utils/utils.dart';
import 'package:chnsmile_flutter/widget/base_expandable_content.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

///可展开的widget
class TranscriptExpandableContent extends StatefulWidget {
  final Score score;
  final int index;

  const TranscriptExpandableContent({Key key, @required this.score, this.index})
      : super(key: key);

  @override
  _TranscriptExpandableContentState createState() =>
      _TranscriptExpandableContentState();
}

class _TranscriptExpandableContentState
    extends BaseExpandableContentState<TranscriptExpandableContent> {
  @override
  buildTop() {
    return Row(
      children: [
        Container(
          height: 30,
          padding: const EdgeInsets.only(left: 5, right: 5),
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: widget.index == 0 ? Colors.lightGreen : primary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.score.examStartDate,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.white))
            ],
          ),
        ),
        Container(
          width: Utils.width - 150,
          child: Text(widget.score.examName,
              style: const TextStyle(fontSize: 13, color: HiColor.dark_text)),
        ),
      ],
    );
  }

  @override
  double marginLR() {
    return 10;
  }

  @override
  buildContent() {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: widget.score.scoreList.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 10, crossAxisCount: 2, childAspectRatio: 8),
        itemBuilder: (BuildContext context, int index) {
          var score = widget.score.scoreList[index];
          return Container(
            child: Row(
              children: [
                Text('${score.courseName} : ',
                    style: const TextStyle(fontSize: 13, color: HiColor.dark_text)),
                Text('${score.courseScore}',
                    style: const TextStyle(fontSize: 13, color: Colors.red)),
                hiSpace(width: 6),
                score.type == 1 ? Icon(Icons.upload_rounded, size: 16, color: Colors.green) : const Icon(Icons.file_download, size: 16, color: Colors.red)
              ],
            ),
          );
        });
  }
}
