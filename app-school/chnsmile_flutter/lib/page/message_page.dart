import 'dart:async';
import 'dart:collection';

import 'package:badges/badges.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/model/home_message.dart';
import 'package:chnsmile_flutter/model/oa_mark_model.dart';
import 'package:chnsmile_flutter/utils/list_utils.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_badge2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class MessagePage extends StatefulWidget {
  final Map params;

  const MessagePage({Key key, this.params}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> with PageVisibilityObserver {
  List<HomeMessage> items = [];
  List<HomeMessage> items2 = [];
  VoidCallback imListener;
  Timer timer;

  @override
  void initState() {
    super.initState();
    ListUtils.cleanSelecter();
    _loadData();

    imListener = BoostChannel.instance.addEventListener("triggerUnRead", (key, arguments) {
      _loadData2();
      return;
    });
  }

  @override
  void onPageShow() {
    super.onPageShow();
    _loadData2();
    timer = Timer.periodic(const Duration(milliseconds: 3000), (timer) {
      _loadData2();
    });
  }

  @override
  void onPageHide() {
    super.onPageHide();
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ///注册监听器
    PageVisibilityBinding.instance.addObserver(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    ///移除监听器
    PageVisibilityBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('消息', showBackButton: widget.params["isFromNative"] ? false : true),
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        child: ListView(
          shrinkWrap: true,
          children: [
            _buildTopText("消息"),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              children: _items2(items),
            ),
            hiSpace(height: 18),
            _buildTopText("家校协作"),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              children: _items2(items2),
            ),
          ],
        )
      )
      // Column(
      //   children: [
      //     // _buildTopText("消息"),
      //
      //     // _buildTopText("家校协作"),
      //     // GridView.count(
      //     //   shrinkWrap: true,
      //     //   physics: const NeverScrollableScrollPhysics(),
      //     //   crossAxisCount: 4,
      //     //   childAspectRatio: 0.8,
      //     //   children: _items2(items2),
      //     // )
      //   ],
      // )
    );
  }

  List<Widget> _items2(List<HomeMessage> items) {
    return items.map((HomeMessage item) {
      return GestureDetector(
        onTap: () {
          BoostNavigator.instance.push(item.page,
              arguments: {"isFromOA": false},
              withContainer: widget.params['isFromNative']);
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 10, top: 10, bottom: 3, left: 10),
              child: item.unCountMessage > 0 ? HiBadge2(unCountMessage: item.unCountMessage, child: Image(
                image: AssetImage('images/${item.iconPath}'),
                width: 72,
                height: 72,
              )) : Image(
                image: AssetImage('images/${item.iconPath}'),
                width: 72,
                height: 72,
              ),
            ),
            Text(item.name,
                style:
                const TextStyle(fontSize: 13, color: HiColor.common_text)),
          ],
        ),
      );
    }).toList();
  }


  _buildTopText(String title) {
    return Container(
      padding: const EdgeInsets.only(left: 20, bottom: 10, top: 0),
      child: Text(title, style: const TextStyle(fontSize: 16, color: primary)),
    );
  }

  List<Widget> _items() {
    print("widget.params['isFromNative']: ${widget.params['isFromNative']}");
    return items.map((HomeMessage item) {
      return GestureDetector(
        onTap: () {
          BoostNavigator.instance.push(item.page, withContainer: widget.params['isFromNative']);
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 10, bottom: 3, left: 10),
              child: item.unCountMessage > 0 ? HiBadge2(unCountMessage: item.unCountMessage, child: Image(
                image: AssetImage('images/${item.iconPath}'),
                width: 72,
                height: 72,
              )) : Image(
                image: AssetImage('images/${item.iconPath}'),
                width: 72,
                height: 72,
              ),
            ),
            Text(item.name,
                style: const TextStyle(
                    fontSize: 13, color: HiColor.common_text)),
          ],
        ),
      );
    }).toList();
  }

  void _loadData2() async {
    try {
      OAMarkModel result = await HomeDao.getAllMark();
      setState(() {
        var lists = HashMap();
        if (result != null && result.list.isNotEmpty) {
          for (var item in result.list) {
            lists[item.module] = item.count;
          }
          for (var item in items) {
            item.unCountMessage = lists[item.tag2] ?? 0;
          }
        }


      });
    } catch (e) {
      print("error: $e");
    }
  }

  void _loadData() {
    items.add(
        HomeMessage("通知", "notice.png", "notice_page", tag2: "TZ"));
    items.add(HomeMessage("作业", "home_work.png", "home_work_page", tag2: "ZY"));
    items.add(HomeMessage("成绩单", "transcript.png", "transcript_page", tag2: "CJD"));
    items.add(HomeMessage(
        "在校表现", "school_performance.png", "school_performance_page", tag2: "ZXBX"));
    items.add(HomeMessage("成长档案", "growth_file.png", "growth_file_page", tag2: "CZDA"));
    items.add(HomeMessage("学生请假", "student_leave.png", "student_leave_page", tag2: "XSQJ"));
    items.add(HomeMessage("每周食谱", "weekly_recipe.png", "weekly_recipe_page", tag2: "MZXP"));

    items2.add(HomeMessage("学生早退", "student_leave_early.png", "student_leave_early_page", tag2: "XSZT"));
    items2.add(HomeMessage("打卡", "clock_in.png", "clock_in_page", tag2: "DK"));
    items2.add(HomeMessage("信息采集", "info_collection.png", "info_collection_page", tag2: "XXCJ"));
    items2.add(HomeMessage("校园投票", "vote.png", "vote_home_page", tag2: "XYTP"));
    items2.add(HomeMessage("每周竞赛", "weekly_contest.png", "weekly_contest_page", tag2: "MZJS"));
    items2.add(HomeMessage("班级相册", "class_album.png", "class_album_page", tag2: "BJXC"));
    _loadData2();
  }
}
