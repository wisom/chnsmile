import 'dart:io';

import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/model/attach.dart';
import 'package:chnsmile_flutter/model/local_file.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/file_util.dart';
import 'package:chnsmile_flutter/widget/oa_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/view_util.dart';

typedef VoidCallback = void Function(List<LocalFile> items);

class SelectAttach extends StatefulWidget {
  final VoidCallback itemsCallBack;
  final List<Attach> attachs;

  const SelectAttach({Key key, this.attachs, this.itemsCallBack})
      : super(key: key);

  @override
  _SelectAttachState createState() => _SelectAttachState();
}

class _SelectAttachState extends State<SelectAttach> {
  List<LocalFile> items = [];
  LocalFile addFile =
      LocalFile(path: "images/contact_add_button.png", isAdd: true);

  @override
  void initState() {
    super.initState();
    handleAttach();
  }

  void handleAttach() {
    if (widget.attachs != null && widget.attachs.isNotEmpty) {
      widget.attachs.forEach((attach) {
        items.add(LocalFile(
            path: attach.attachUrl,
            name: attach.origionName,
            suffix: attach.attachSuffix));
      });
      if (items.length < 4 && !items.contains(addFile)) {
        items.add(addFile);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: _buildAttach(),
    );
  }

  _buildAttach() {
    if (items.isEmpty) {
      return InkWell(
          onTap: openAttachFile,
          child: Row(
            children: [
              const Image(
                  image: AssetImage("images/contact_add_button.png"),
                  width: 36,
                  height: 36),
              hiSpace(width: 10),
              const Text('添加图片/文件',
                  style: TextStyle(fontSize: 13, color: Colors.black87))
            ],
          ));
    } else {
      return Container(
        height: 80,
        child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            childAspectRatio: 0.8,
            children: items.map((item) => _item(item)).toList()),
      );
    }
  }

  Widget _item(LocalFile attach) {
    return GestureDetector(
      onTap: () {
        BoostNavigator.instance.push(HiConstant.attachment + attach.path);
      },
      child: Stack(
        children: [
          Column(
            children: [
              _buildImage(attach),
              OAText(attach.name),
            ],
          ),
          !attach.isAdd ? GestureDetector(
            onTap: () {
              delete(attach);
            },
            child: Container(
              margin: const EdgeInsets.only(left: 60),
                child: const Image(
                    image: AssetImage('images/delete.png'),
                    width: 20,
                    height: 20)),
          ) : Container()
        ],
      ),
    );
  }

  delete(LocalFile attach) {
    setState(() {
      items.remove(attach);
    });
  }

  _buildImage(LocalFile attach) {
    double width = 60;
    if (attach.isAdd) {
      return InkWell(
          onTap: openAttachFile,
          child: Image(
              width: width, height: width, image: AssetImage(attach.path)));
    } else {
      return buildAttachImage(
          width: 60, suffix: attach.suffix, url: attach.path);
    }
  }

  void openAttachFile() async {
    List<PlatformFile> files = await openFile();

    /// 压缩
    List<LocalFile> temps = [];
    for (var file in files) {
      String suffix = file.path.substring(file.path.lastIndexOf(".") + 1);
      if (!isImageType(suffix)) {
        temps.add(LocalFile(
            path: file.path,
            name: file.name ?? '',
            size: file.size,
            isAdd: false,
            suffix: suffix));
      } else {
        String newPath =
            await FileUtil.getInstance().getSavePath("/upload/") + file.name;
        File compressFile = await compressAndGetFile(file.path, newPath,
            minWidth: 1920, minHeight: 1080);
        temps.add(LocalFile(
            path: compressFile != null ? compressFile.path : file.path,
            name: file.name ?? '',
            size: file.size,
            isAdd: false,
            suffix: suffix));
      }
    }
    setState(() {
      for (var file in temps) {
        if (items.length <= 4) {
          items.remove(addFile);
          items.add(LocalFile(
              path: file.path,
              name: file.name ?? '',
              size: file.size,
              isAdd: false,
              suffix: file.path.substring(file.path.lastIndexOf(".") + 1)));
        }
      }
      if (items.length < 4 && !items.contains(addFile)) {
        items.add(addFile);
      }
    });

    List<LocalFile> temps1 = List.from(items);
    temps1.remove(addFile);
    widget.itemsCallBack(temps1);
  }
}
