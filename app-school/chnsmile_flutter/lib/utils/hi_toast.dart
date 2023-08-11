import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///错误提示样式的toast
void showWarnToast(String text) {
  Fluttertoast.showToast(
    msg: text,
    backgroundColor: Colors.white,
    textColor: Colors.black,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
  );
}

///错误提示样式的toast
void showWarnMiddleToast(String text) {
  Fluttertoast.showToast(
    msg: text,
    backgroundColor: Colors.white,
    textColor: Colors.black,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
  );
}


///普通提示样式的toast
void showToast(String text) {
  Fluttertoast.showToast(
    msg: text,
    backgroundColor: Colors.white,
    textColor: Colors.black,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
  );
}
