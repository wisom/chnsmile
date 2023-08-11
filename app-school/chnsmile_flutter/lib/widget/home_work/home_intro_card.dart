import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/model/home_model.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class HomeIntroCard extends StatelessWidget {
  final SchoolProfile schoolProfile;

  const HomeIntroCard(this.schoolProfile, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: Colors.white, border: borderLine(context)),
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
      child: Row(
        children: [_itemImage(), _buildContent(context)],
      ),
    );
  }

  _itemImage() {
    double height = 90;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Stack(
        children: [
          schoolProfile?.topImg != null
              ? cachedImage(schoolProfile?.topImg,
                  width: height, height: height, fit: BoxFit.fill)
              : Image(
                  image: const AssetImage('images/school_intro.png'),
                  fit: BoxFit.fitWidth,
                  width: height,
                  height: height),
        ],
      ),
    );
  }

  _buildContent(BuildContext context) {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.only(left: 8, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                schoolProfile?.title ?? "",
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              InkWell(
                onTap: () {
                  if (schoolProfile?.pageUrl != null) {
                    print('${HiConstant.webview + schoolProfile?.pageUrl}');
                    BoostNavigator.instance
                        .push(HiConstant.webview + schoolProfile?.pageUrl);
                  }
                },
                child: const Text(
                  '详情>>',
                  style: TextStyle(fontSize: 13, color: primary),
                ),
              ),
            ],
          ),
          hiSpace(height: 5),
          Text(
            schoolProfile?.intro ?? "",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    ));
  }
}
