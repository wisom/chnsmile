import 'package:chnsmile_flutter/widget/painter_cusotm.dart';
import 'package:flutter/material.dart';
///[index]这个属性主要是为了给左边的时间轴画部件来用的 This attribute is primarily to the left of the timeline painted parts to use;
///[timeAxisSize]时间轴的大小必须要的。
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
class HiPaintCirLineItem extends StatefulWidget {
  int index;
  double timeAxisSize;
  double contentLeft;
  Widget leftWidget;
  double lineToLeft;
  Gradient mygradient;
  bool isDash;
  double DottedLineLenght;
  double DottedSpacing;
  double marginLeft;
  Color leftLineColor;
  Alignment alignment;
  Widget centerRightWidget;
  Widget centerLeftWidget;
  Widget cententWight;
  double timeAxisLineWidth;
  HiPaintCirLineItem(this.timeAxisSize,this.index,
      {
        this.contentLeft,
        this.leftWidget,
        this.lineToLeft,
        this.mygradient,
        this.marginLeft = 5,
        this.isDash,
        this.DottedLineLenght = 5.0,
        this.DottedSpacing = 10.0,
        this.leftLineColor,
        this.alignment = Alignment.center,
        this.centerRightWidget,
        this.centerLeftWidget,
        this.cententWight,this.timeAxisLineWidth}) {
    if (lineToLeft == null) {
      this.lineToLeft = timeAxisSize / 2;
    }
    if(contentLeft==null){
      this.contentLeft=lineToLeft+3;
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _HiPaintCirLineItemState();
  }
}

class _HiPaintCirLineItemState extends State<HiPaintCirLineItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: widget.marginLeft, top: 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomPaint(
              painter: MyPainter(
                  paintWidth:widget.timeAxisLineWidth,
                  circleSize: widget.lineToLeft,
                  mygradient: widget.mygradient,
                  isDash: widget.isDash,
                  LineColor: widget.leftLineColor,DottedLineLenght:widget.DottedLineLenght,DottedSpacing:widget.DottedSpacing),
              child: Container(
                padding: EdgeInsets.only(left: widget.contentLeft),
                child: Container(
                  height: 12,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                    width: widget.timeAxisSize, child: widget.leftWidget),
                widget.cententWight,
              ],
            )
          ],
        ));
  }
}
