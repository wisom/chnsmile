import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class WxUnbindPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("微信解绑"),
      body: Container(
        color: Colors.white,
        child: _buildList(),
      ),
    );
  }

  _buildList() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 2,
        itemBuilder: (context, index) {
          return Container(
            width: double.infinity,
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    BoostNavigator.instance
                        .push('wxunbind_detail_page', arguments: {"id": 0});
                  },
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 59,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "微信",
                          style: TextStyle(
                            fontSize: 16,
                            color: HiColor.color_black_A60,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "微信名称",
                              style: TextStyle(
                                fontSize: 16,
                                color: HiColor.color_black_A25,
                              ),
                            ),
                            hiSpace(width: 18),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: HiColor.color_black_A25,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                line(context)
              ],
            ),
          );
        });
  }
}
