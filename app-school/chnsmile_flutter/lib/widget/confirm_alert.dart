import 'package:chnsmile_flutter/widget/my_cupertino_dialog.dart';
import 'package:hi_base/string_util.dart';
import 'package:flutter/material.dart';

typedef VoidCallbackConfirm = void Function(bool isOk);

void confirmAlert<T>(
  BuildContext context,
  VoidCallbackConfirm callBack, {
  int type,
  String tips,
  String okBtn,
  String cancelBtn,
  TextStyle okBtnStyle,
  TextStyle style,
  bool isWarm = false,
  String warmStr,
}) {
  showDialog<T>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      if (isEmpty(okBtn)) okBtn = '确定';
      if (isEmpty(cancelBtn)) cancelBtn = '取消';
      if (isEmpty(warmStr)) warmStr = '温馨提示：';
      return MyCupertinoAlertDialog(
        title: isWarm
            ? Padding(
                padding: EdgeInsets.only(bottom: 20.0, top: 0),
                child: Text(
                  '$warmStr',
                  style: TextStyle(
                      color: Color(0xff343243),
                      fontSize: 19.0,
                      fontWeight: FontWeight.normal),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  '$tips',
                  style: TextStyle(
                      color: Color(0xff343243),
                      fontSize: 19.0,
                      fontWeight: FontWeight.normal),
                ),
              ),
        content: isWarm
            ? Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  '$tips',
                  style: TextStyle(color: Color(0xff888697)),
                ),
              )
            : Container(),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(
              '$cancelBtn',
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
            ),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              callBack(false);
            },
          ),
          CupertinoDialogAction(
            child: Text('$okBtn', style: okBtnStyle),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              callBack(true);
            },
          ),
        ],
      );
    },
  ).then<void>((T value) {});
}
