import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/format_util.dart';

///带缓存的image
Widget cachedImage(String url, {double width, double height, String placeholder, BoxFit fit}) {
  return CachedNetworkImage(
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      placeholder: (
          BuildContext context,
          String url,
          ) =>
          placeholder != null ? Image(image: AssetImage(placeholder)) : Container(),
      errorWidget: (
          BuildContext context,
          String url,
          dynamic error,
          ) =>
          placeholder != null ? Image(image: AssetImage(placeholder)) : Container(),
      imageUrl: url);
}

///黑色线性渐变
blackLinearGradient({bool fromTop = false}) {
  return LinearGradient(
      begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
      end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
      colors: [
        Colors.black54,
        Colors.black45,
        Colors.black38,
        Colors.black26,
        Colors.black12,
        Colors.transparent
      ]);
}

///带文字的小图标
smallIconText(IconData iconData, var text) {
  var style = TextStyle(fontSize: 12, color: Colors.grey);
  if (text is int) {
    text = countFormat(text);
  }
  return [
    Icon(
      iconData,
      color: Colors.grey,
      size: 12,
    ),
    Text(
      ' $text',
      style: style,
    )
  ];
}

///间距
SizedBox hiSpace({double height: 1, double width: 1}) {
  return SizedBox(height: height, width: width);
}


///间距
Container hiSpaceWithColor(BuildContext context,{Color color:HiColor.color_F7F7F7,double height, double width}) {
  height??8;
  width??MediaQuery.of(context).size.width;
  return Container(color:color,height: height, width: width);
}
