import 'package:chnsmile_flutter/model/attach.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/widget/audio/remote_player.dart';
import 'package:chnsmile_flutter/widget/oa_attach_grid.dart';
import 'package:chnsmile_flutter/widget/oa_attach_list.dart';
import 'package:chnsmile_flutter/widget/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';

class OAAttachDetail extends StatelessWidget {
  final List<Attach> items;
  List<Attach> imageItems = [];
  List<Attach> audioItems = [];
  List<Attach> otherItems = [];

  OAAttachDetail({Key key, this.items}) : super(key: key) {
    for (var attach in items) {
      if (isImageType(attach.attachSuffix)) {
        imageItems.add(attach);
      } else if (isAudioType(attach.attachSuffix)) {
        audioItems.add(attach);
      } else {
        otherItems.add(attach);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: imageItems.map((attach) {
            return OAAttachGrid(
                title: attach.origionName,
                suffix: attach.attachSuffix,
                url: attach.attachUrl);
          }).toList(),
        ),
        hiSpace(height: 12),
        Column(
          children: otherItems.map((attach) {
            return OAAttachList(
                title: attach.origionName,
                suffix: attach.attachSuffix,
                url: attach.attachUrl);
          }).toList(),
        ),
        // audioItems.isNotEmpty ? _contentAudio() : Container()
      ],
    );
  }

  _contentAudio() {
    return Column(
      children: audioItems.map((item) {
        return Container(
          margin: const EdgeInsets.only(top: 6),
          height: 40,
          padding: const EdgeInsets.only(left: 6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(width: 0.5, color: Colors.grey[300])),
          // child: RemotePlayer(),
          child: PlayerWidget(item.attachUrl),
        );
      }).toList(),
    );
  }
}
