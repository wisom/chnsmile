import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';

class HiBanner extends StatelessWidget {
  final List<BannerModel> bannerList;
  final double bannerHeight;
  final EdgeInsetsGeometry padding;

  const HiBanner(this.bannerList,
      {Key key, this.bannerHeight = 160, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: bannerHeight,
      child: _banner(),
    );
  }

  _banner() {
    var right = 10 + (padding?.horizontal ?? 0) / 2;
    return Swiper(
      itemCount: bannerList.length,
      autoplay: true,
      itemBuilder: (BuildContext context, int index) {
        return _image(bannerList[index]);
      },
      //自定义指示器
      pagination: SwiperPagination(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(right: right, bottom: 10),
          builder: const DotSwiperPaginationBuilder(
              color: Colors.white60, size: 6, activeSize: 6)),
    );
  }

  _image(BannerModel bannerMo) {
    return InkWell(
      onTap: () {
        handleBannerClick(bannerMo);
      },
      child: Container(
        padding: padding,
        child: ClipRRect(
          child: cachedImage(bannerMo.imgUrl),
        ),
      ),
    );
  }
}

///banner点击跳转
void handleBannerClick(BannerModel bannerMo) {
  if (isNotEmpty(bannerMo.linkUrl)) {
    print("url: ${bannerMo.linkUrl}" );
    BoostNavigator.instance.push(HiConstant.webview + bannerMo.linkUrl);
  }
}
