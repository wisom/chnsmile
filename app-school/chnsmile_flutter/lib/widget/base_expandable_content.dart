import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:flutter/material.dart';

///可展开的widget
abstract class BaseExpandableContentState<T extends StatefulWidget> extends HiState<T>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  bool _expand = false;

  //用来管理Animation
  AnimationController _controller;

  //生成动画高度的值
  Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _controller.addListener(() {
      //监听动画值的变化
      print(_heightFactor.value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: marginLR(), right: marginLR(), top: 5, bottom: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: Colors.grey[300], width: 1))),
      child: Column(
        children: [_buildTitle(), _buildDes()],
      ),
    );
  }

  // 头部内容
  buildTop();

  // 内部
  buildContent();

  double marginLR() {
    return 20;
  }

  double topHeight() {
    return 60;
  }

  _buildTitle() {
    return InkWell(
      onTap: _toggleExpand,
      child: Container(
        height: topHeight(),
        alignment: Alignment.center,
        child: Row(
          children: [
            //通过Expanded让Text获得最大宽度，以便显示省略号
            Expanded(child: buildTop()),
            Icon(
              _expand
                  ? Icons.keyboard_arrow_down_rounded
                  : Icons.keyboard_arrow_right_outlined,
              color: Colors.grey,
              size: 24,
            )
          ],
        ),
      ),
    );
  }

  void _toggleExpand() {
    setState(() {
      _expand = !_expand;
      if (_expand) {
        //执行动画
        _controller.forward();
      } else {
        //反向执行动画
        _controller.reverse();
      }
    });
  }

  _buildDes() {
    var child = _expand ? buildContent() : null;
    //构建动画的通用widget
    return AnimatedBuilder(
      animation: _controller.view,
      child: child,
      builder: (BuildContext context, Widget child) {
        return Align(
          heightFactor: _heightFactor.value,
          //fix 从布局之上的位置开始展开
          alignment: Alignment.topCenter,
          child: Container(
            //会撑满宽度后，让内容对其
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 8, bottom: 10),
            child: child,
          ),
        );
      },
    );
  }
}
