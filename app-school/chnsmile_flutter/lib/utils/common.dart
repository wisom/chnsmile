import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:crypto/crypto.dart';
import 'package:event_bus/event_bus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';
import 'package:hi_cache/hi_cache.dart';

var eventBus = EventBus();

/// 去掉HTML标签
removeHtmlTag(String htmlStr) {
  //定义script的正则表达式，去除js可以防止注入
  var scriptRegex=RegExp("<script[^>]*?>[\\s\\S]*?<\\/script>");
  //定义style的正则表达式，去除style样式，防止css代码过多时只截取到css样式代码
  var styleRegex=RegExp("<style[^>]*?>[\\s\\S]*?<\\/style>");
  //定义HTML标签的正则表达式，去除标签，只提取文字内容
  var htmlRegex=RegExp("<[^>]+>");
  //定义空格,回车,换行符,制表符
  var spaceRegex = RegExp("\\s*|\t|\r|\n");
  // 过滤script标签
  htmlStr = htmlStr.replaceAll(scriptRegex, "");
  // 过滤style标签
  htmlStr = htmlStr.replaceAll(styleRegex, "");
  // 过滤html标签
  htmlStr = htmlStr.replaceAll(htmlRegex, "");
  // 过滤空格等
  htmlStr = htmlStr.replaceAll(spaceRegex, "");
  htmlStr = htmlStr.replaceAll("&nbsp;", "");
  print("html:${htmlStr}");
  return htmlStr.trim(); // 返回文本字符串
}

/// 去掉HTML2标签
removeHtmlTag2(String htmlStr) {
  htmlStr = htmlStr.replaceAll("&nbsp;", "");
  print("html:${htmlStr}");
  return htmlStr.trim(); // 返回文本字符串
}

/// 获取用户Id
String getUserId() {
  return HiCache.getInstance().get(HiConstant.spUserId);
}

/// 打开文件
Future<List<PlatformFile>> openFile() async {
  FilePickerResult result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    type: FileType.custom,
    allowedExtensions: ['pdf', "doc", "xls", "ppt", "jpg", 'png', "jpeg"],
  );
  return result.files;
}

/// 打开文件
Future<PlatformFile> openImage() async {
  FilePickerResult result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    type: FileType.image,
  );
  return result.files[0];
}

/// 是否是图片类型
isImageType(String suffix) {
  if (suffix.contains(RegExp("jpg|png|jpeg|gif|webp|bmp|wbmp"))) {
    return true;
  } else {
    return false;
  }
}

/// 是否是audio类型
isAudioType(String suffix) {
  if (suffix.contains(RegExp("mp3|mp4|wav|aac|3gp|wmv|m4v", caseSensitive: false))) {
    return true;
  } else {
    return false;
  }
}

/// 是否是xls类型
isXLSType(String suffix) {
  if (suffix.contains(RegExp("xlsx|xls"))) {
    return true;
  } else {
    return false;
  }
}

/// 是否是doc类型
isDocType(String suffix) {
  if (suffix.contains(RegExp("docx|doc|txt"))) {
    return true;
  } else {
    return false;
  }
}

/// 列表中显示附件
Widget buildAttachImage({String suffix, String url, double width = 80}) {
  if (isXLSType(suffix)) {
    return Image(
        width: width,
        height: width,
        image: const AssetImage('images/icon_excel.png'));
  } else if (suffix == 'pdf') {
    return Image(
        width: width,
        height: width,
        image: const AssetImage('images/icon_pdf.png'));
  } else if (isDocType(suffix)) {
    return Image(
        width: width,
        height: width,
        image: const AssetImage('images/icon_word.png'));
  } else {
    if (url != null) {
      if (url.startsWith("http") || url.startsWith("file")) {
        return cachedImage(url,
            placeholder: "images/default_img.png", width: width, height: width);
      } else {
        return Image.file(File(url),
            width: width, height: width, fit: BoxFit.cover);
      }
    } else {
      return cachedImage(url,
          placeholder: "images/default_img.png", width: width, height: width);
    }
  }
}

/// 校园投票voteStatus 0 未发布 1 已发布 3 已撤回
buildTeacherSchoolVoteStatus(int type) {
  if (type == 0) {
    return [Colors.grey, "未发布"];
  } else if (type == 1) {
    return [primary, "已发布"];
  } else if (type == 3) {
    return [Colors.red, "通知已撤回"];
  } else {
    return [primary, "未发布"];
  }
}

/// 校园投票voteStatus 0 未发布 1 已发布 3 已撤回
buildSchoolVoteStatus(int type) {
  if (type == 0) {
    return [Colors.grey, "未发布"];
  } else if (type == 1) {
    return [primary, "已发布"];
  } else if (type == 3) {
    return [Colors.red, "已撤回"];
  } else {
    return [primary, "未发布"];
  }
}

/// 每周竞赛status 1 进行中 2 已结束 4 未开始
buildWeeklyContestStatus(int type) {
  if (type == 1) {
    return [primary, "进行中"];
  } else if (type == 2) {
    return [Colors.orangeAccent, "已结束"];
  } else if (type == 4) {
    return [Colors.grey, "未开始"];
  } else {
    return [primary, "进行中"];
  }
}

/// 打卡status 0 未发布 1 已发布 3 已撤回
buildClockInStatus(int type) {
  if (type == 0) {
    return [Colors.grey, "未发布"];
  } else if (type == 1) {
    return [Colors.green, "已发布"];
  } else if (type == 3) {
    return [Colors.red, "已撤回"];
  } else {
    return [primary, "未发布"];
  }
}

/// 调课status状态（状态（0未发送、1确认中、2已确认、3已拒绝）
buildClassTransferStatus(int type) {
  if (type == 0) {
    return [Colors.grey, "未发送"];
  } else if (type == 1) {
    return [Colors.orangeAccent, "确认中"];
  } else if (type == 2) {
    return [primary, "已备案"];
  } else if (type == 3) {
    return [Colors.red, "已拒绝"];
  } else {
    return [primary, "未知"];
  }
}

/// reviewStatus状态（0等待、1待批/待读、2已批/已读、3拒批）
buildOAApplyNoticeStatus(int type) {
  if (type == 0) {
    return [Colors.grey, "等待"];
  } else if (type == 2) {
    return [primary, "已读"];
  } else {
    return [Colors.grey, "待读"];
  }
}

/// reviewStatus状态（待确认，已确认）
buildOAClassStatus(int type) {
   if (type == 1) {
    return [Colors.orangeAccent, "待确认"];
  } else if (type == 2) {
    return [primary, "已确认"];
   } else if (type == 3) {
     return [Colors.red, "已拒绝"];
  } else {
    return [Colors.grey, "未知"];
  }
}

/// reviewStatus状态（0等待、1待批/待读、2已批/已读、3拒批）
buildOAApplyStatus(int type) {
  if (type == 0) {
    return [Colors.grey, "等待"];
  } else if (type == 1) {
    return [Colors.orangeAccent, "待批"];
  } else if (type == 2) {
    return [primary, "已批"];
  } else if (type == 3) {
    return [Colors.red, "拒批"];
  } else {
    return [Colors.grey, "已阅"];
  }
}

/// reviewStatus状态（0：待回复、1待读、2已读、3：已回复）
buildOAApplyStatus2(int type) {
  if (type == 1) {
    return [Colors.orangeAccent, "待读"];
  } else if (type == 2) {
    return [primary, "已读"];
  } else if (type == 3) {
    return [Colors.red, "已回复"];
  } else {
    return [Colors.grey, "待回复"];
  }
}

/// 返回可编辑的状态
getEditStatus(int type) {
  if (type == 0) {
    return true;
  }
  return false;
}

/// 0未发送、1批阅中、2已备案、3已拒绝
buildClassOAStatus(int type) {
  if (type == 0) {
    return [Colors.grey, "未发出"];
  } else if (type == 1) {
    return [Colors.orangeAccent, "确认中"];
  } else if (type == 2) {
    return [primary, "已备案"];
  } else if (type == 3) {
    return [Colors.red, "已拒绝"];
  } else {
    return [Colors.grey, "待确认"];
  }
}

/// 0未发送、1批阅中、2已备案、3已拒绝
buildClassOAStatus1(int type) {
  if (type == 0) {
    return [Colors.grey, "未发出"];
  } else if (type == 1) {
    return [Colors.orangeAccent, "确认中"];
  } else if (type == 2) {
    return [primary, "已备案"];
  } else if (type == 3) {
    return [Colors.red, "已拒绝"];
  } else {
    return [Colors.grey, "等待"];
  }
}

/// 0未发送、1批阅中、2已备案、3已拒绝
buildOAStatus(int type) {
  if (type == 0) {
    return [Colors.grey, "未发出"];
  } else if (type == 1) {
    return [Colors.orangeAccent, "审批中"];
  } else if (type == 2) {
    return [primary, "已备案"];
  } else if (type == 3) {
    return [Colors.red, "已拒绝"];
  } else {
    return [Colors.grey, "未知"];
  }
}

///0：未发布，1：已发布，3：已撤回
buildInfoCollectionStatus(int type) {
  if (type == 0) {
    return [HiColor.color_D8D8D8, "未发布"];
  } else if (type == 1) {
    return [HiColor.color_00B0F0, "已发布"];
  } else if (type == 3) {
    return [Colors.grey, "已撤回"];
  } else {
    return [Colors.grey, "未知"];
  }
}

buildSmallButton(String text, Color color, {Function onClick}) {
  return InkWell(
      onTap: onClick,
      child: Container(
        alignment: Alignment.center,
        width: 42,
        height: 24,
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: Text(text,
            style: const TextStyle(fontSize: 11, color: Colors.white)),
      ));
}

buildReadUnReadStatus(String text, Color color) {
  return Container(
    alignment: Alignment.center,
    width: 50,
    height: 24,
    decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(12))),
    child:
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.white)),
  );
}

Future<List<int>> compressFile(File file) async {
  try {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 200,
      minHeight: 300,
      quality: 80,
    );
    print(file.lengthSync());
    print(result.length);
    return result;
  } catch (e) {
    print('e => ${e.toString()}');
    return null;
  }
}

Future<File> compressAndGetFile(String filePath, String targetPath,
    {int minWidth = 200, int minHeight = 200}) async {
  try {
    var result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      targetPath,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: 85,
    );
    print("result: $result");
    return result;
  } catch (e) {
    print('e => ${e.toString()}');
    return null;
  }
}

int currentTimeMillis() {
  return DateTime.now().millisecondsSinceEpoch;
}

String generateMd5(String data) {
  var content = const Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  return digest.toString();
}

buildRemark(String content) {
  return Container(
    padding: const EdgeInsets.all(10),
    width: double.infinity,
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300], width: 0.5)
    ),
    child: Text(content, style: const TextStyle(fontSize: 13, color: Colors.black)),
  );
}

Widget showAvatorIcon(
    {String avatarImg, String name, double width = 40, double fontSize = 18}) {
  if (avatarImg == null) {
    return Container(
        width: width,
        height: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.lightGreen, borderRadius: BorderRadius.circular(20)),
        child: Text(name != null ? name.substring(0, 1) : '空',
            style: TextStyle(fontSize: fontSize, color: Colors.white)));
  } else {
    return ClipOval(
      child: cachedImage(avatarImg,
          placeholder: "images/default_avator.png",
          width: width,
          height: width),
    );
  }
}

showListDialog(BuildContext context,
    {String title,
    List<String> list,
    double height = 0,
    Function onItemClick}) {
  showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          insetAnimationDuration: Duration.zero,
            insetAnimationCurve: Curves.fastLinearToSlowEaseIn,
          title: Text(title),
          content: height == 0
              ? SingleChildScrollView(
                  child: Column(
                    children: list.asMap().entries.map((entry) {
                      int index = entry.key;
                      String name = entry.value;
                      return InkWell(
                        onTap: () {
                          onItemClick(name, index);
                          // onButtonClick(type, name);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 10),
                          height: 42,
                          decoration:
                              BoxDecoration(border: borderLine(context)),
                          child: Text(name,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black87)),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : Container(
                  height: height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: list.asMap().entries.map((entry) {
                        int index = entry.key;
                        String name = entry.value;
                        return InkWell(
                          onTap: () {
                            onItemClick(name, index);
                            // onButtonClick(type, name);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.only(top: 10),
                            height: 42,
                            decoration:
                                BoxDecoration(border: borderLine(context)),
                            child: Text(name,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('取消',
                    style: TextStyle(fontSize: 16, color: Colors.grey))),
          ],
        );
      });
}

Color randomColor() {
  return Color.fromARGB(255, Random().nextInt(256) + 0,
      Random().nextInt(256) + 0, Random().nextInt(256) + 0);
}
