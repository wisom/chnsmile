import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hi_base/string_util.dart';

class NormalSelect extends StatelessWidget {
  final double width;
  final double height;
  final double margin;
  final String hint;
  final Function onSelectPress;
  final String text;
  final Widget rightWidget;
  final bool isEnable;

  const NormalSelect({Key key,
    this.hint,
    this.width,
    this.height,
    this.onSelectPress,
    this.text,
    this.margin = 10,
    this.isEnable = true,
    this.rightWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: isEnable ? onSelectPress : null,
        child: Container(
          margin: EdgeInsets.only(left: margin, right: margin),
          padding: const EdgeInsets.all(10),
          width: width,
          height: height ?? 42,
          decoration: BoxDecoration(
            color: !isEnable ? Colors.grey[100] : Colors.white,
              border: Border.all(
                  color: Colors.grey[200],
                  width: 0.5,
                  style: BorderStyle.solid)),
          child: Row(
            children: [
              Expanded(
                  child: Text(isEmpty(text) ? hint : text,
                      style: TextStyle(
                          fontSize: 13,
                          color: isEmpty(text) ? Colors.grey : Colors.black))),
              rightWidget ??
                  const Icon(Icons.keyboard_arrow_down,
                      size: 24, color: Colors.black54)
            ],
          ),
        ));
  }
}
