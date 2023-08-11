import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/view_util.dart';

class ItemTag extends StatelessWidget {
  final String image;
  final String title;
  final String url;

  const ItemTag({Key key, this.image, this.title, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = 100;
    return GestureDetector(
      onTap: () {
        BoostNavigator.instance.push(HiConstant.webview + url);
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey[400], width: 1),
                borderRadius: BorderRadius.circular(4)),
            child: cachedImage(image,
                width: height * 16 / 13, height: height),
          ),
          hiSpace(height: 5),
          Text(title,
              style:
              const TextStyle(color: Colors.grey, fontSize: 13))
        ],
      ),
    );

    //   InkWell(
    //   onTap: (){
    //     print('xxxx111');
    //   },
    //   child: Column(
    //     children: [
    //       Container(
    //         margin: const EdgeInsets.all(5),
    //         decoration: BoxDecoration(
    //             border: Border.all(
    //                 color: Colors.grey[400], width: 1),
    //             borderRadius: BorderRadius.circular(4)),
    //         child: cachedImage(image,
    //             width: height * 16 / 13, height: height),
    //       ),
    //       hiSpace(height: 5),
    //       Text(title,
    //           style:
    //           const TextStyle(color: Colors.grey, fontSize: 16))
    //     ],
    //   ),
    // );
  }
}
