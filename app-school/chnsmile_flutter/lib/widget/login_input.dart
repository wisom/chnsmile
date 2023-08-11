import 'package:chnsmile_flutter/widget/login_form_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hi_base/color.dart';

class LoginInput extends StatefulWidget {
  final String hint;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final ValueChanged<bool> focusChanged;
  final bool obscureText;
  final String rightButtonText;
  final VoidCallback onRightButtonPressed;
  final TextInputType keyboardType;
  final double iconSize;
  final int maxLength;

  const LoginInput(this.hint,
      {Key key,
      this.onChanged,
      this.icon,
      this.focusChanged,
      this.obscureText = false,
      this.iconSize = 30,
      this.maxLength = -1,
      this.keyboardType,
      this.rightButtonText,
      this.onRightButtonPressed})
      : super(key: key);

  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");
      if (widget.focusChanged != null) {
        widget.focusChanged(_focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      height: 52,
      color: Colors.white,
      child: Row(
        children: [
          widget.icon != null
              ? Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 15),
                  child: Icon(
                    widget.icon,
                    size: widget.iconSize,
                    color: Colors.grey[350],
                  ),
                )
              : Container(),
          _input(),
          widget.rightButtonText != null
              ? Container(
                  width: 10,
                  color: grey,
                )
              : Container(),
          widget.rightButtonText != null
              ? Expanded(
                  flex: 3,
                  child:LoginFormCode(onTapCallback: widget.onRightButtonPressed, available: true,)
    )
              : Container()
        ],
      ),
    );
  }

  _input() {
    return Expanded(
        flex: widget.rightButtonText != null ? 5 : 10000,
        child: TextField(
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          autofocus: !widget.obscureText,
          enableInteractiveSelection: false,
          cursorColor: primary,
          maxLength: widget.maxLength,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w300),
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 20, right: 20),
              border: InputBorder.none,
              hintText: widget.hint ?? '',
              counterText: '',
              hintStyle: const TextStyle(fontSize: 16, color: Colors.grey)),
        ));
  }
}
