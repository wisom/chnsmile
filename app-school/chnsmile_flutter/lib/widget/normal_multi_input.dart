import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hi_base/color.dart';

class NormalMultiInput extends StatefulWidget {
  final String hint;
  final String initialValue;
  final int maxLines;
  final int minLines;
  final int maxLength;
  final double width;
  final double height;
  final double margin;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<bool> focusChanged;

  const NormalMultiInput(
      {Key key,
      this.hint,
      this.initialValue,
      this.onChanged,
      this.width,
      this.height,
        this.focusNode,
      this.minLines,
        this.maxLength = 0,
      this.maxLines,
      this.focusChanged, this.margin = 10})
      : super(key: key);

  @override
  _NormalMultiInputState createState() => _NormalMultiInputState();
}

class _NormalMultiInputState extends State<NormalMultiInput> {
  final _focusNode = FocusNode();
  RegExp regexp=RegExp("[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]");

  @override
  void initState() {
    super.initState();
    // _focusNode.addListener(() {
    //   print("Has focus: ${_focusNode.hasFocus}");
    //   if (widget.focusChanged != null) {
    //     widget.focusChanged(_focusNode.hasFocus);
    //   }
    // });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: EdgeInsets.only(left: widget.margin, right: widget.margin),
      child: _input(),
    );
  }

  _input() {
    return TextFormField(
      focusNode: widget.focusNode ?? _focusNode,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines ?? 1,
      minLines: widget.minLines ?? 1,
      initialValue: widget.initialValue ?? '',
      maxLength: widget.maxLength != 0 ? widget.maxLength : null,
      // inputFormatters: [BlacklistingTextInputFormatter(regexp)],
      cursorColor: primary,
      style: const TextStyle(
            fontSize: 13, color: Colors.black, fontWeight: FontWeight.w300),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 10, top: 16),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0.0),
              borderSide: BorderSide(color: Colors.grey[200], width: 0.5, style: BorderStyle.solid)),
          enabledBorder:OutlineInputBorder(
              borderRadius: BorderRadius.circular(0.0),
              borderSide: BorderSide(color: Colors.grey[200], width: 0.5, style: BorderStyle.solid)),
          focusedBorder:OutlineInputBorder(
              borderRadius: BorderRadius.circular(0.0),
              borderSide: BorderSide(color: Colors.grey[200], width: 0.5, style: BorderStyle.solid)),
          hintText: widget.hint ?? '',
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey)
      ),
    );
  }
}
