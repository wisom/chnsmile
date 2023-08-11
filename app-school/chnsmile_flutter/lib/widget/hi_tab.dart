import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:underline_indicator/underline_indicator.dart';

///顶部tab切换组件
class HiTab extends StatelessWidget {
  final List<Widget> tabs;
  final TabController controller;
  final double fontSize;
  final double borderWidth;
  final double insets;
  final Color unselectedLabelColor;
  final bool isScrollable;

  const HiTab(this.tabs,
      {Key key,
        this.controller,
        this.fontSize = 16,
        this.borderWidth = 2,
        this.insets = 15,
        this.unselectedLabelColor = Colors.grey, this.isScrollable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _unselectedLabelColor = Colors.black54;
    return TabBar(
        controller: controller,
        labelColor: primary,
        isScrollable: isScrollable,
        unselectedLabelColor: _unselectedLabelColor,
        labelStyle: TextStyle(fontSize: fontSize),
        indicator: UnderlineIndicator(
            strokeCap: StrokeCap.square,
            borderSide: BorderSide(color: primary, width: borderWidth),
            insets: EdgeInsets.only(left: insets, right: insets)),
        tabs: tabs);
  }
}
