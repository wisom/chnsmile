import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/core/platform_method.dart';
import 'package:chnsmile_flutter/core/platform_response.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/confirm_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/color.dart';
import 'package:hi_cache/hi_cache.dart';
import 'dart:io' show Platform;

class MinePage extends StatefulWidget {
  final Map params;

  const MinePage({Key key, this.params}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  String os = "";
  static const _items = [
    {"name": "我的信息", "page": "profile_page"},
    {"name": "我的孩子", "page": "my_account_page"},
    {"name": "我的课程表", "page": "my_course_page"},
    {"name": "设置", "page": "setting_page"},
    {"name": "修改密码", "page": "change_password_page"},
    {"name": "意见反馈", "page": "feedback_page"},
    {"name": "隐私政策", "page": "jumpNative", "url": HiConstant.privartUrl},
    {"name": "微信解绑", "page": "wxunbind_page"},
    {"name": "关于中国微校", "page": "about_page"}
  ];

  static const _footItems = [
    {"name": "退出登录", "page": "logout"},
  ];

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      print("IOS");
      os = "IOS";
    } else if (Platform.isAndroid) {
      print("安卓");
      os = "安卓";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar('更多',
            showBackButton: widget.params["isFromNative"] ? false : true),
        body: ListView(
          shrinkWrap: true,
          children: [..._listItems(), ..._listEmpty(), ..._listFootItems()],
        ));
  }

  bool get isTeacher {
    return HiCache.getInstance().get(HiConstant.spIdentity) == "2";
  }

  _listItems() {
    return _items.map((item) {
      if (item['page'] == 'my_account_page' && isTeacher) {
        return Container();
      }
      return _item(item);
    }).toList();
  }

  _listEmpty() {
    return [{}].map((item) {
      return Container(
        height: 20,
      );
    }).toList();
  }

  _listFootItems() {
    return _footItems.map((item) {
      return _item(item);
    }).toList();
  }

  Widget _item(item) {
    return InkWell(
      onTap: () {
        _handleClick(item);
      },
      child: Container(
        color: Colors.white,
        alignment: Alignment.centerLeft,
        height: 60,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Colors.grey[100]))),
          child: Row(
            children: [
              Expanded(
                  child: Text(item['name'],
                      style:
                          const TextStyle(fontSize: 13, color: Colors.black))),
              item['action'] == null
                  ? const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.grey, size: 16)
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  void _handleClick(Map<String, String> item) {
    if (item['page'] == "logout") {
      showLogoutDialog();
    } else if (item['page'] == 'jumpNative') {
      BoostNavigator.instance.push(HiConstant.webview + item['url']);
    } else {
      BoostNavigator.instance
          .push(item['page'], withContainer: widget.params['isFromNative']);
    }
  }

  showLogoutDialog() {
    print("os平台=" + os);
    // if (os == "IOS") {
    //   confirmAlert(
    //     context,
    //     (bool) {
    //       // if (bool) {
    //       //   logout();
    //       // }
    //     },
    //     tips: '确认要退出？',
    //     okBtn: '确认',
    //     warmStr: '退出提示',
    //     isWarm: true,
    //     style: const TextStyle(fontWeight: FontWeight.w500),
    //   );
    // }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('确认要退出？',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('取消',
                      style: TextStyle(fontSize: 16, color: Colors.grey))),
              TextButton(
                  onPressed: () {
                    logout();
                    Navigator.of(context).pop();
                  },
                  child: const Text('确认',
                      style: TextStyle(fontSize: 16, color: primary)))
            ],
          );
        });
  }

  logout() async {
    PlatformResponse response = await PlatformMethod.logout();
    print("data: ${response.data}");
  }
}
