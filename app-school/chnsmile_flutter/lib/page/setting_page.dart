import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<Map<String, dynamic>> items = [
    {"name": "隐私", "type": "title"},
    {"name": "相机", "type": "switch", "default": true},
    {"name": "麦克风", "type": "switch", "default": true},
    {"name": "提醒", "type": "title"},
    {"name": "推送通知", "type": "switch", "default": true},
    {"name": "声音", "type": "switch", "default": true},
    {"name": "记录", "type": "title"},
    {"name": "清除缓存", "type": "arrow", "action": "clear"},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('设置'),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return _item(items[index]);
          }),
    );
  }

  Widget _item(item) {
    return item['type'] == 'title'
        ? Container(
            height: 50,
            padding: const EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: grey,
                border: Border(
                    bottom: BorderSide(color: Colors.grey[300], width: 1))),
            child: Text(
              item['name'],
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          )
        : Container(
            height: 50,
            padding: const EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(color: Colors.grey[300], width: 1))),
            child: Row(
              children: [
                Expanded(child: InkWell(
                  onTap: () {
                    click(item);
                  },
                  child: Text(item['name'], style:const TextStyle(fontSize: 16, color: Colors.black54)),)),
                item['type'] == 'arrow'
                    ? const Icon(Icons.arrow_forward_ios_rounded)
                    : CupertinoSwitch(
                        value: item['default'] as bool,
                        onChanged: (newValue) {
                          setState(() {
                            item['default'] = newValue;
                          });
                        },
                      ),
              ],
            ),
          );
  }

  click(item) {
    if (item['action'] == 'clear') {
      EasyLoading.show(status: '清理中,请稍后...');
      Future.delayed(const Duration(seconds: 1), () {
        showWarnToast('清理完成');
        EasyLoading.dismiss(animation: false);
      });
      
    }
  }
}
