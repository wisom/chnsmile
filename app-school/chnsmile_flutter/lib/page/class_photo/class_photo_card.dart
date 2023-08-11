import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

import '../../http/dao/class_photo_dao.dart';
import '../../model/class_photo_model.dart';
import '../../model/fund_manager_model.dart';
import '../../utils/common.dart';

class ClassPhotoCard extends StatelessWidget {
  final ClassPhoto item;
  final String type;
  final ValueChanged<ClassPhoto> onCellClick;

  const ClassPhotoCard({Key key, this.item, this.type, this.onCellClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onCellClick(item);
      },
      child: _buildBody(context, item),
    );
  }

  _buildBody(BuildContext context, ClassPhoto item) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: Column(
              children: [
                hiSpace(height: 19),
                _buildTopInfo(item),
                hiSpace(height: 13),
                _buildCenter(item),
                hiSpace(height: 11),
                _buildBottomInfo(item),
                hiSpace(height: 11),
              ],
            )),
        line(context)
      ],
    );
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
