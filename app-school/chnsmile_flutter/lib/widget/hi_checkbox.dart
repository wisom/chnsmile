import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';

class HiCheckBox extends StatefulWidget {
  final String title;
  final bool selected;
  final Function onCheckPress;

  const HiCheckBox({Key key, this.title, this.selected = false, this.onCheckPress}) : super(key: key);

  @override
  _HiCheckBoxState createState() => _HiCheckBoxState();
}

class _HiCheckBoxState extends State<HiCheckBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onCheckPress,
      child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 10, right: 5),
              child: widget.selected
                  ? const Icon(Icons.check_box_rounded,
                  color: primary, size: 22)
                  : const Icon(Icons.check_box_outline_blank_outlined,
                  color: Colors.grey, size: 22)),
          Text(
            widget.title,
            style: const TextStyle(fontSize: 13, color: primary),
          )
        ],
      ),
    );
  }
}



