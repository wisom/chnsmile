import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/widget/hi_button.dart';
import 'package:chnsmile_flutter/widget/normal_multi_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

import 'normal_input.dart';

typedef VoidDialogCallback = void Function(
    String content, String result, String report);

class OAApproveDialog extends Dialog {
  final VoidDialogCallback onLeftPress;
  final VoidDialogCallback onRightPress;
  final Function onClosePress;
  final isShowBottomContent;
  final String titleTip;
  final String tipContent;
  final int maxLength;
  String content = "";
  String result = "";
  String report = "";

  OAApproveDialog({this.onLeftPress, this.onRightPress, this.onClosePress, this.maxLength = 0, this.titleTip = '审批', this.tipContent = '请输入审批内容', this.isShowBottomContent = true});

  @override
  Widget get child => contentWidget();

  // Positioned(child: Icon(Icons.close, size: 20, color: Colors.grey), right: 0,)
  /// 内容区域
  contentWidget() {
    return Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          height: isShowBottomContent ? 330 : 250,
          child: Stack(
            children: [
              Positioned(
                child: InkWell(
                    onTap:  onClosePress,
                    child: const Icon(Icons.close, size: 22, color: Colors.grey)),
                right: 0,
              ),
              Column(
                children: [
                   Text(
                    titleTip,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  hiSpace(height: 20),
                  NormalMultiInput(
                      hint: tipContent,
                      maxLength: maxLength,
                      minLines: 5,
                      maxLines: 5,
                      onChanged: (text) {
                        content = text;
                      }),
                  hiSpace(height: 10),
                  isShowBottomContent ? Row(
                    children: [
                      const Text('维修结果:',
                          style: TextStyle(fontSize: 13, color: Colors.black)),
                      Expanded(
                        child: NormalInput(
                          hint: "可选填",
                          onChanged: (text) {
                            result = text;
                          },
                        ),
                      )
                    ],
                  ) : Container(),
                  hiSpace(height: 10),
                  isShowBottomContent ? Row(
                    children: [
                      const Text('维修报告:',
                          style: TextStyle(fontSize: 13, color: Colors.black)),
                      Expanded(
                        child: NormalInput(
                          hint: "可选填",
                          onChanged: (text) {
                            report = text;
                          },
                        ),
                      )
                    ],
                  ) : Container(),
                  hiSpace(height: 10),
                  Row(
                    children: [
                      HiButton("同意", bgColor: primary, onPressed: () {
                        if (isEmpty(content)) {
                          showWarnToast('请填写内容');
                          return;
                        }
                        onLeftPress(content, result, report);
                      }),
                      hiSpace(width: 40),
                      HiButton("拒绝", bgColor: Colors.green, onPressed: () {
                        if (isEmpty(content)) {
                          showWarnToast('请输入审批内容');
                          return;
                        }
                        onRightPress(content, result, report);
                      })
                    ],
                  ),
                  hiSpace(height: 10)
                ],
              )
            ],
          ),
        ));
  }
}
