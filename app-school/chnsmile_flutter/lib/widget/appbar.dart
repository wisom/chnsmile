import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';

appBar(String title, {String rightTitle, bool isEnable = true, bool showBackButton = true, VoidCallback rightButtonClick}) {
  return AppBar(
    centerTitle: true,
    titleSpacing: 0,
    leading: showBackButton ? IconButton(onPressed: (){
      BoostNavigator.instance.pop();
    },icon: const Icon(Icons.arrow_back_ios)): Container(),
    title: Text(title, style: const TextStyle(fontSize: 20)),
    actions: [
      isNotEmpty(rightTitle) ?
      InkWell(
        onTap: isEnable ? rightButtonClick : null,
        child: Container(
          padding: const EdgeInsets.only(left: 15, right: 15),
          alignment: Alignment.center,
          child: Container(
            alignment: Alignment.center,
            width: 60,
            height: 28,
            decoration: BoxDecoration(
              color: isEnable ? Colors.white : Colors.grey[400],
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              rightTitle ?? '',
              style: const TextStyle(fontSize: 12, color: primary),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      )
          : Container()
    ],
  );
}

appBar2(String title, {String rightTitle, bool showBackButton = true}) {
  return AppBar(
    centerTitle: true,
    titleSpacing: 0,
    leading: showBackButton ? IconButton(onPressed: (){
      BoostNavigator.instance.pop();
    },icon: const Icon(Icons.arrow_back_ios)): Container(),
    title: Text(title, style: const TextStyle(fontSize: 22)),
    actions: [
      Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          height: 24,
          child: Text(
            rightTitle ?? '',
            style: const TextStyle(fontSize: 13, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      )
    ],
  );
}

appBar3(String title, {bool showBackButton = true, bool isShow = false, VoidCallback rightButtonClick}) {
  return AppBar(
    centerTitle: true,
    titleSpacing: 0,
    leading: showBackButton ? IconButton(onPressed: (){
      BoostNavigator.instance.pop();
    },icon: const Icon(Icons.arrow_back_ios)): Container(),
    title: Text(title, style: const TextStyle(fontSize: 20)),
    actions: [
      isShow ? InkWell(
        onTap: rightButtonClick,
        child: Container(
          padding: const EdgeInsets.only(left: 15),
          alignment: Alignment.center,
          child: Container(
            alignment: Alignment.center,
            width: 60,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.more_horiz_outlined, size: 26, color: Colors.white),
          ),
        ),
      ) : Container()
    ],
  );
}