import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';

class LevelText extends StatelessWidget {
  final int level;

  const LevelText({Key key, this.level}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildText();
  }

  _buildText() {
    double width = 18;
    if (level == 2) {
      return Container(
        alignment: Alignment.center,
        width: width,
        height: width,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(2)
        ),
        child: const Text('急', style: TextStyle(color: Colors.white, fontSize: 12)),
      );
    } else if (level == 1) {
      return Container(
        alignment: Alignment.center,
        width: width,
        height: width,
        decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(2)
        ),
        child: const Text('重', style: TextStyle(color: Colors.white, fontSize: 12)),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        width: width,
        height: width,
        decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(2)
        ),
        child: const Text('普', style: TextStyle(color: Colors.white, fontSize: 12)),
      );
    }
  }
}
