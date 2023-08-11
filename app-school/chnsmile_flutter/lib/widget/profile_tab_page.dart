import 'dart:io';

import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/core/hi_error.dart';
import 'package:chnsmile_flutter/http/dao/profile_dao.dart';
import 'package:chnsmile_flutter/model/family_info.dart';
import 'package:chnsmile_flutter/model/profile_model.dart';
import 'package:chnsmile_flutter/model/student_info.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/file_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/view_util.dart';
import 'package:hi_cache/hi_cache.dart';

class ProfileTabPage extends StatefulWidget {
  final int type;
  final ProfileModel profileModel;
  final Function callback;

  const ProfileTabPage({Key key, this.type, this.profileModel, this.callback})
      : super(key: key);

  @override
  _ProfileTabPageState createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        widget.type == 1 ? _buildFamilyContent() : _buildChildContent()
      ],
    );
  }

  bool get isFamily {
    return widget.type == 1;
  }

  bool get isStudent {
    return widget.type == 3;
  }

  _buildHeader() {
    FamilyInfo family = widget.profileModel?.parentInfo;
    StudentInfo student = widget.profileModel?.studentInfo;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(border: borderLine(context)),
      child: Row(
        children: [
          Column(
            children: [
              GestureDetector(
                  onTap: _openGallery,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: cachedImage(
                        isFamily ? family?.avatarImg : student?.avatarImg,
                        placeholder: 'images/default_avator.png',
                        width: 80, height: 80),
                  )),
              hiSpace(height: 5),
              GestureDetector(
                onTap: _openGallery,
                child: RichText(
                    text: const TextSpan(children: [
                      WidgetSpan(
                          child: Icon(Icons.camera_alt_outlined,
                              size: 18, color: Colors.black87)),
                      TextSpan(
                          text: ' 修改头像',
                          style: TextStyle(
                              fontSize: 13, color: Colors.black87)),
                    ])),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text('姓名:${isFamily ? family?.name : student?.studentName}',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black87)),
                  ],
                ),
                hiSpace(height: 12),
                isFamily ? Text('注册日期:${family?.register}',
                    style:
                    const TextStyle(fontSize: 13, color: Colors.grey)) : Text(
                    '性别:${student?.gender}',
                    style:
                    const TextStyle(fontSize: 13, color: Colors.grey))
              ],
            ),
          )
        ],
      ),
    );
  }

  bool get isTeacher {
    return HiCache.getInstance().get(HiConstant.spIdentity) == "2";
  }

  _buildFamilyContent() {
    return Column(
      children: [
        Container(
          height: 52,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(border: borderLine(context)),
          child: Row(
            children: [
              const Icon(Icons.phone_iphone, size: 20, color: Colors.orange),
              hiSpace(width: 10),
              const Text('绑定手机号',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              Expanded(
                  child: Text(widget.profileModel?.parentInfo?.phone ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 14, color: Colors.grey)))
            ],
          ),
        ),
        Container(
          height: 52,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(border: borderLine(context)),
          child: Row(
            children: [
              const Icon(Icons.masks, size: 20, color: Colors.red),
              hiSpace(width: 10),
              const Text('个性签名',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              Expanded(
                  child: InkWell(
                      onTap: () {
                        changeProfile("remark");
                      },
                      child: RichText(
                          textAlign: TextAlign.right,
                          text: TextSpan(children: [
                            TextSpan(
                                text: widget.profileModel?.parentInfo?.remark ??
                                    '',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                            const WidgetSpan(
                                child: Icon(Icons.arrow_forward_ios_rounded,
                                    size: 20, color: Colors.grey)),
                          ]))))
            ],
          ),
        ),
        isTeacher ?
          Container(
            height: 52,
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(border: borderLine(context)),
            child: Row(children: [
              const Icon(Icons.settings_system_daydream,
                  size: 20, color: Colors.black87),
              hiSpace(width: 10),
              const Text('身份证号码',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              Expanded(
                  child: InkWell(
                      onTap: () {
                        changeProfile("idCard");
                      },
                      child: RichText(
                          textAlign: TextAlign.right,
                          text: TextSpan(children: [
                            TextSpan(
                                text: widget.profileModel?.parentInfo?.idCard ??
                                    '',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                            const WidgetSpan(
                                child: Icon(Icons.arrow_forward_ios_rounded,
                                    size: 20, color: Colors.grey)),
                          ]))))
            ]),
          )
        : Container(
          height: 52,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(border: borderLine(context)),
          child: Row(children: [
            const Icon(Icons.settings_system_daydream,
                size: 20, color: Colors.blue),
            hiSpace(width: 10),
            const Text('身份',
                style: TextStyle(fontSize: 14, color: Colors.black87)),
            Expanded(
              child: InkWell(
                  onTap: () {
                    changeProfile("childRelation");
                  },
                  child: RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(children: [
                        TextSpan(
                            text: widget
                                .profileModel?.parentInfo?.childRelation ??
                                '',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey)),
                        const WidgetSpan(
                            child: Icon(Icons.arrow_forward_ios_rounded,
                                size: 20, color: Colors.grey)),
                      ]))),
            )
          ]),
        ),
        Container(
          height: 52,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(border: borderLine(context)),
          child: Row(
            children: [
              const Icon(Icons.email, size: 20, color: Colors.green),
              hiSpace(width: 10),
              const Text('邮箱',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              Expanded(
                  child: InkWell(
                      onTap: () {
                        changeProfile("email");
                      },
                      child: RichText(
                          textAlign: TextAlign.right,
                          text: TextSpan(children: [
                            TextSpan(
                                text: widget.profileModel?.parentInfo?.email ??
                                    '',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                            const WidgetSpan(
                                child: Icon(Icons.arrow_forward_ios_rounded,
                                    size: 20, color: Colors.grey)),
                          ]))))
            ],
          ),
        ),
      ],
    );
  }

  _buildChildContent() {
    return Column(
      children: [
        Container(
          height: 52,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(border: borderLine(context)),
          child: Row(
            children: [
              const Icon(Icons.phone_iphone, size: 20, color: Colors.orange),
              hiSpace(width: 10),
              const Text('绑定手机号',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              Expanded(
                  child: Text(widget.profileModel.parentInfo?.phone ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 14, color: Colors.grey)))
            ],
          ),
        ),
        Container(
          height: 52,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(border: borderLine(context)),
          child: Row(
            children: [
              const Icon(Icons.school, size: 20, color: Colors.blue),
              hiSpace(width: 10),
              const Text(
                  '学校', style: TextStyle(fontSize: 14, color: Colors.black87)),
              Expanded(
                  child: Text(widget.profileModel?.studentInfo?.schoolName ?? '',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 14, color: Colors.grey)))
            ],
          ),
        ),
        Container(
          height: 52,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(border: borderLine(context)),
          child: Row(
            children: [
              const Icon(Icons.class_, size: 20, color: Colors.green),
              hiSpace(width: 10),
              const Text('年级/班',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              Expanded(
                  child: Text(
                      "${widget.profileModel?.studentInfo?.gradeName ??
                          ''}${widget.profileModel?.studentInfo?.className ??
                          ''}",
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 14, color: Colors.grey)))
            ],
          ),
        ),
        Container(
          height: 52,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(border: borderLine(context)),
          child: Row(
            children: [
              const Icon(Icons.masks, size: 20, color: Colors.yellow),
              hiSpace(width: 10),
              const Text('班主任',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              Expanded(
                  child: Text(
                      widget.profileModel?.studentInfo?.headTeacherName ?? '',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 14, color: Colors.grey)))
            ],
          ),
        ),
        Container(
          height: 52,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(border: borderLine(context)),
          child: Row(
            children: [
              const Icon(Icons.settings_system_daydream,
                  size: 20, color: Colors.red),
              hiSpace(width: 10),
              const Text('生日',
                  style: TextStyle(fontSize: 14, color: Colors.black87)),
              Expanded(
                  child: Text(widget.profileModel?.studentInfo?.birth ?? '',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 14, color: Colors.grey)))
            ],
          ),
        ),
      ],
    );
  }

  void changeProfile(String type) {
    if (type == "childRelation") {
      showConfirmDialog(type);
      return;
    }

    BoostNavigator.instance.push('profile_change_page',
        arguments: {"profile": widget.profileModel, "type": type});
  }

  _openGallery() async {
    try {
      PlatformFile file = await openImage();
      String newPath = await FileUtil.getInstance().getSavePath("/avator/") +
          file.name;
      File compressFile = await compressAndGetFile(file.path, newPath);
      if (compressFile != null) {
        var result = await ProfileDao.uploadAvator(
            type: widget.type, path: compressFile.absolute.path);
        print("result: $result");
        if (result['code'] == 200) {
          widget.callback();
        } else {
          showWarnToast(result['message']);
        }
      }
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    } catch (e) {
      print(e);
    }
  }

  onButtonClick(String type, String text) async {
    try {
      var result = await ProfileDao.submit(
          id: widget.profileModel.parentInfo.userId,
          type: 1,
          changeName: type,
          changeText: text);
      print(result);
      if (result['code'] == 200) {
        // eventBus.fire(ProfileChangeEvent());
        widget.callback();
        print("eventbus-----");
      } else {
        showWarnToast(result['message']);
      }
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }


  showConfirmDialog(String type) {
    List<String> list = ['爸爸', '妈妈', '爷爷', '奶奶'];
    showListDialog(
        context, title: '请选择家长的身份', list: list, onItemClick: (String name, int index) {
      onButtonClick(type, name);
    });
  }
}
