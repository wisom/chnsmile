import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/view_util.dart';

class HiPicture extends StatelessWidget {
  final List<String> images;

  const HiPicture({Key key, this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int imageSize = images.length;
    double imageWidth = (Utils.width - 20 - 50 - 10) /
        ((imageSize == 3 || imageSize > 4)
            ? 3.0
            : (imageSize == 2 || imageSize == 4)
                ? 2.0
                : 1.5);
    return Container(
        child: imageSize > 1
            ? GridView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: imageSize,
                shrinkWrap: true,
                primary: false,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: imageWidth,
                    crossAxisSpacing: 6.0,
                    mainAxisSpacing: 6.0,
                    childAspectRatio: 1),
                itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      _handleTapImage(images[index]);
                    },
                    child: cachedImage(images[index],
                        width: imageWidth, height: imageWidth)))
            : imageSize == 1
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: GestureDetector(
                        onTap: () {
                          _handleTapImage(images?.first);
                        },
                        child: cachedImage(images?.first,
                            width: Utils.width - 20,
                            height: (Utils.width - 20) * 7 / 16)))
                : SizedBox());
  }

  _handleTapImage(String url) {
    BoostNavigator.instance.push(HiConstant.picture + url);
  }
}
