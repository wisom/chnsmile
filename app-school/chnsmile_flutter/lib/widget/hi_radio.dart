import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';

class HiRadio extends StatefulWidget {
  final String title;
  final bool selected;
  final bool enabled;
  final Function onCheckPress;

  const HiRadio({Key key, this.title, this.selected = false, this.enabled = true, this.onCheckPress}) : super(key: key);

  @override
  _HiRadioState createState() => _HiRadioState();
}

class _HiRadioState extends State<HiRadio> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onCheckPress,
      child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 10, right: 5),
              child: widget.selected
                  ? Icon(Icons.check_circle_outlined,
                  color: widget.enabled ? primary : Colors.grey, size: 22)
                  : Icon(Icons.radio_button_unchecked_outlined,
                  color: widget.enabled ? Colors.grey : Colors.grey[200], size: 22)),
          Text(
            widget.title,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          )
        ],
      ),
    );
  }
}



