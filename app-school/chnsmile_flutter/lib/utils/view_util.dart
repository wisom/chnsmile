import 'package:chnsmile_flutter/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';

///border线
borderLine(BuildContext context, {bottom: true, top: false}) {
  var lineColor = Colors.grey[300];
  BorderSide borderSide = BorderSide(width: 0.5, color: lineColor);
  return Border(
      bottom: bottom ? borderSide : BorderSide.none,
      top: top ? borderSide : BorderSide.none);
}

///底部阴影
BoxDecoration bottomBoxShadow1(BuildContext context) {
  return BoxDecoration(
      color: Colors.white,
      border: Border.all(color: primary),
      borderRadius: BorderRadius.circular(2));
}

///底部阴影
BoxDecoration bottomBoxShadow(BuildContext context) {
  return BoxDecoration(color: Colors.white, boxShadow: [
    BoxShadow(
        color: Colors.grey[100],
        offset: const Offset(0, 5), //xy轴偏移
        blurRadius: 5.0, //阴影模糊程度
        spreadRadius: 1 //阴影扩散程度
        )
  ]);
}

box(BuildContext context,
    {Color color = HiColor.color_F7F7F7, double height = 8}) {
  return Container(
    width: double.infinity,
    height: height,
    decoration: BoxDecoration(color: color),
  );
}

///一根border线
boxLine(BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(top: 5, bottom: 5),
    decoration: BoxDecoration(border: borderLine(context)),
  );
}

///一根border线
line(BuildContext context,
    {Color color = HiColor.color_D8D8D8,
    double width = 0.5,
    EdgeInsetsGeometry margin = const EdgeInsets.fromLTRB(0, 0, 0, 0)}) {
  return Container(
    margin: margin,
    decoration: BoxDecoration(border: Border.all(color: color, width: width)),
  );
}

/// 已批，已读的
Text oaStatusText(int status, {String kinds = "1"}) {
  return Text(
      kinds == "1"
          ? buildOAApplyStatus(status)[1]
          : buildOAApplyNoticeStatus(status)[1],
      style: TextStyle(
          fontSize: 12,
          color: kinds == "1"
              ? buildOAApplyStatus(status)[0]
              : buildOAApplyNoticeStatus(status)[0]));
}

/// 已批，已读的
Text oaClassStatusText(int status, {String kinds = "1"}) {
  return Text(
      kinds == "1"
          ? buildOAApplyStatus(status)[1]
          : buildOAApplyNoticeStatus(status)[1],
      style: TextStyle(
          fontSize: 12,
          color: kinds == "1"
              ? buildOAApplyStatus(status)[0]
              : buildOAApplyNoticeStatus(status)[0]));
}
