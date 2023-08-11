import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hi_base/color.dart';

class NormalInput extends StatefulWidget {
  final String hint;
  final String initialValue;
  final int maxLength;
  final double width;
  final double height;
  final bool enabled;
  final bool obscureText;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<bool> focusChanged;
  final TextInputType keyboardType;

  const NormalInput(
      {Key key,
      this.hint,
      this.onChanged,
      this.initialValue,
      this.width,
      this.height,
        this.focusNode,
      this.enabled = true,
      this.obscureText = false,
      this.maxLength,
      this.focusChanged,
      this.keyboardType})
      : super(key: key);

  @override
  _NormalInputState createState() => _NormalInputState();
}

class _NormalInputState extends State<NormalInput> {
  final _focusNode = FocusNode();
  final _textEditingController = TextEditingController();
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

    _textEditingController.text =widget.initialValue ?? '';
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
      margin: const EdgeInsets.only(left: 10, right: 10),
      height: widget.height ?? 40,
      child: _input(),
    );
  }

  _input() {
    return TextField(
      controller: _textEditingController,
      focusNode: widget.focusNode ?? _focusNode,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      enabled: widget.enabled ?? true,
      obscureText: widget.obscureText ?? false,
      // inputFormatters: [BlacklistingTextInputFormatter(regexp)],
      enableInteractiveSelection: false,
      cursorColor: primary,
      style: const TextStyle(
          fontSize: 13, color: Colors.black, fontWeight: FontWeight.w300),
      decoration:
      InputDecoration(
        filled: true,
        fillColor: widget.enabled ? Colors.transparent : Colors.grey[100],
        contentPadding: const EdgeInsets.only(left: 10),
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
