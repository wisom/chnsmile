import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/model/news_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/publish_department.dart';
import 'package:chnsmile_flutter/widget/publish_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

class NewsCard extends StatelessWidget {
  final News news;

  const NewsCard({Key key, this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (isNotEmpty(news.pageUrl)) {
            BoostNavigator.instance.push(HiConstant.webview + news.pageUrl);
          }
        },
        child: Container(
          decoration: BoxDecoration(border: borderLine(context)),
          padding:
              const EdgeInsets.only(left: 6, right: 6, bottom: 10, top: 12),
          child: Column(
            children: [_buildTop(), hiSpace(height: 4), _buildBottom()],
          ),
        ));
  }

  _buildTop() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      isNotEmpty(news.topImg) ? _itemImage() : Container(),
      _buildContent(),
    ]);
  }

  _buildBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PublishDepartment(name: news.author ?? '', tips: '作者: ',),
        PublishTime(time: dateYearMothAndDayAndMinutes(news.publishTime.replaceAll(".000", "")))
      ],
    );
  }

  _itemImage() {
    double height = 90;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Stack(
        children: [
          cachedImage(news.topImg, width: height * (16 / 12), height: height)
        ],
      ),
    );
  }

  _buildContent() {
    return Expanded(
        child: Container(
      padding:
          EdgeInsets.only(left: isNotEmpty(news.topImg) ? 8 : 0, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            news.title ?? '',
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          Text(
            removeHtmlTag(news.intro) ?? '',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    ));
  }
}
