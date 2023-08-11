import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/model/attach.dart';
import 'package:chnsmile_flutter/model/behavior.dart';
import 'package:chnsmile_flutter/widget/wxtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/view_util.dart';

class BehaviorGrid extends StatelessWidget {

  final List<Behavior> items;

  const BehaviorGrid({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.map((e) => _item(e)).toList(),
    );
  }

  Widget _item(Behavior behavior) {
    return Container(
      padding: const EdgeInsets.only(right: 10, top: 6),
      child: Column(
        children: [
          cachedImage(behavior.behaviorIcon, width: 30, height: 30, placeholder: "images/default_avator.png"),
          Text(behavior.behaviorContent, style: const TextStyle(fontSize: 12, color: Colors.black87))
        ],
      ),
    );
  }
}
