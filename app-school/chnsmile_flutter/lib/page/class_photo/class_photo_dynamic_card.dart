import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

import '../../http/dao/class_photo_dao.dart';
import '../../model/class_photo_dynamic_accessory.dart';
import '../../model/class_photo_model.dart';
import '../../utils/common.dart';

class ClassPhotoDynamicCard extends StatefulWidget {
  final ClassPhotoDynamicAccessory item;
  final ValueChanged<ClassPhotoDynamicAccessory> onCellClick;

  const ClassPhotoDynamicCard({Key key, this.item, this.onCellClick})
      : super(key: key);

  @override
  _ClassPhotoDynamicCardState createState() => _ClassPhotoDynamicCardState();
}

class _ClassPhotoDynamicCardState extends State<ClassPhotoDynamicCard> {
  List<ClassPhotoDynamicAccessory> dataList = [];

  @override
  void initState() {
    super.initState();
    dataList.add(widget.item);
    dataList.add(widget.item);
    dataList.add(widget.item);
    dataList.add(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: _buildContent(widget.item),
    );
  }

  _buildContent(ClassPhotoDynamicAccessory item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(9, 17, 9, 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "2023/04/11",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "选择",
                      style:
                          TextStyle(fontSize: 12, color: HiColor.color_00B0F0),
                    )
                  ],
                ),
                hiSpace(height: 8),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "xxx上传了1个影像",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
          hiSpace(height: 3),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            childAspectRatio: 1,
            children: _items(dataList),
          )
        ],
      ),
    );
  }

  List<Widget> _items(List<ClassPhotoDynamicAccessory> items) {
    return items.map((ClassPhotoDynamicAccessory item) {
      return GestureDetector(
          onTap: () {
            BoostNavigator.instance.push("class_album_detail_page",
                arguments: {"id": item.albumId});
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Image.network(
                    "https://img0.baidu.com/it/u=3425868493,3104015061&fm=253&fmt=auto&app=120&f=JPEG?w=1199&h=800",
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover),
                const Positioned(
                    top: 4,
                    right: 4,
                    child: Icon(Icons.radio_button_unchecked_outlined,
                        size: 15, color: Colors.white))
              ],
            ),
          ));
    }).toList();
  }

  _buildBody(BuildContext context, ClassPhotoDynamicAccessory item) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: Column(
              children: [
                _buildBg(),
                hiSpace(height: 19),
// _buildTopInfo(item),
                hiSpace(height: 13),
// _buildCenter(item),
                hiSpace(height: 11),
// _buildBottomInfo(item),
                hiSpace(height: 11),
              ],
            )),
        line(context)
      ],
    );
  }

  _buildBg() {
    return Image.network(
        "https://img0.baidu.com/it/u=3425868493,3104015061&fm=253&fmt=auto&app=120&f=JPEG?w=1199&h=800",
        width: double.infinity);
  }

  _buildCenter(ClassPhoto item) {
    return Image.network(
        "https://img0.baidu.com/it/u=3425868493,3104015061&fm=253&fmt=auto&app=120&f=JPEG?w=1199&h=800",
        width: double.infinity);
  }

  _buildBottomInfo(ClassPhoto item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(children: [
            Text(
              "共${item.count ?? 0}个照片/视频",
              style: const TextStyle(
                fontSize: 12,
                color: HiColor.color_9E9E9E,
              ),
            ),
            Text(
              item.albumName ?? "",
              style: const TextStyle(
                fontSize: 12,
                color: HiColor.color_00B0F0,
              ),
            ),
          ]),
        ),
        const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: HiColor.color_9E9E9E,
        )
      ],
    );
  }

  _buildTopInfo(ClassPhoto item) {
    return Row(
      children: [
        Expanded(
            child: Row(
          children: [
            showAvatorIcon(avatarImg: item.albumCover, name: ""),
            hiSpace(width: 12),
            Column(
              children: [
                Text(
                  item.publishName ?? "",
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                hiSpace(height: 7),
                Text(
                  item.publishTime ?? "",
                  style: const TextStyle(
                      color: HiColor.color_181717_A50, fontSize: 12),
                )
              ],
            )
          ],
        )),
        InkWell(
          onTap: () {
            delete(item.id ?? "");
          },
          child: const Icon(
            Icons.delete_forever_outlined,
            size: 26,
            color: HiColor.color_9E9E9E,
          ),
        )
      ],
    );
  }

  Future<ClassPhotoModel> delete(String ids) async {
    EasyLoading.show(status: '加载中...');
    try {
      var result = await ClassPhotoDao.delete(ids);
      EasyLoading.dismiss(animation: false);
      return result;
    } catch (e) {
      print(e);
      EasyLoading.dismiss(animation: false);
    }
  }
}
