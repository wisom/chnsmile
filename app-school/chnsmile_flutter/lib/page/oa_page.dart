import 'dart:async';
import 'dart:collection';

import 'package:badges/badges.dart';
import 'package:chnsmile_flutter/http/dao/home_dao.dart';
import 'package:chnsmile_flutter/model/home_message.dart';
import 'package:chnsmile_flutter/model/oa_mark_model.dart';
import 'package:chnsmile_flutter/model/oa_permission_model.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/list_utils.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/hi_badge.dart';
import 'package:chnsmile_flutter/widget/hi_badge2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';

class OAPage extends StatefulWidget {
  final Map params;

  const OAPage({Key key, this.params}) : super(key: key);

  @override
  _OAPageState createState() => _OAPageState();
}

class _OAPageState extends State<OAPage> with PageVisibilityObserver {
  List<HomeMessage> items0 = [];
  List<HomeMessage> items1 = [];
  List<HomeMessage> items2 = [];
  List<HomeMessage> items3 = [];
  bool isLoaded = false;
  List<String> pemissions = [];
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
    // items1.clear();
    // items2.clear();
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
      appBar: appBar('移动办公',
          showBackButton: widget.params["isFromNative"] ? false : true),
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        child: !isLoaded ? ListView(
          shrinkWrap: true,
          children: [
            _buildTopText("上级传文"),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              children: _items(items0),
            ),
            _buildTopText("移动OA"),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              children: _items(items1),
            ),_buildTopText("财务管理"),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              children: _items(items2),
            ),
            _buildTopText("家校协作"),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              children: _items(items3),
            )
          ],
        ) : Container(),
      ),
    );
  }

  _buildTopText(String title) {
    return Container(
      padding: const EdgeInsets.only(left: 20, bottom: 10, top: 0),
      child: Text(title, style: const TextStyle(fontSize: 16, color: primary)),
    );
  }

  List<Widget> _items(List<HomeMessage> items) {
    return items.map((HomeMessage item) {
      return GestureDetector(
        onTap: () {
          BoostNavigator.instance.push(item.page,
              arguments: {"isFromOA": true, "pemissions": pemissions},
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

  void _loadData2() async {
    try {
      OAMarkModel result = await HomeDao.getAllMark();
      setState(() {
        var lists = HashMap();
        if (result != null && result.list.isNotEmpty) {
          for (var item in result.list) {
            lists[item.module] = item.count;
          }
          for (var item in items1) {
            item.unCountMessage = lists[item.tag2] ?? 0;
          }
        }
      });
    } catch (e) {
      print("error: $e");
    }
  }

  void _loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      isLoaded = true;
      OAPermissionModel result = await HomeDao.getOAPermission();
      isLoaded = false;
      if (result != null && result.list.isNotEmpty) {
        pemissions = result.list;
      }
      EasyLoading.dismiss(animation: false);
      setState(() {
        items0.add(HomeMessage("上级信息", "superiors_info.png", "super_notice_list_page", tag2: "SJXX"));
        items0.add(HomeMessage("上级文件", "superiors_file.png", "super_file_list_page", tag2: "SJWJ"));
        items0.add(HomeMessage("上报文件", "report_file.png", "file_report_page", tag2: "SBWJ"));

        if (result != null && result.list.isNotEmpty) {
          if (result.list.contains("school_affairs_notice")) items1.add(HomeMessage("校务通知", "school_notice.png", "school_notice_page", tag: "school_affairs_notice", tag2: "XWTZ"));
          if (result.list.contains("official_document_management")) items1.add(HomeMessage("公文流转", "official_document.png", "official_document_page", tag: "official_document_management", tag2: "GWLZ"));
          if (result.list.contains("teacher_leave_management")) items1.add(HomeMessage("请假", "vacation.png", "vacation_page", tag: "teacher_leave_management", tag2: "QJ"));
          if (result.list.contains("academic_affairs_adjustment")) items1.add(HomeMessage("调课", "class_transfer.png", "class_transfer_home_page", tag: "academic_affairs_adjustment", tag2: "DK"));
          // items1.add(HomeMessage("工资", "salary.png", "salary_page", tag2: "GZ"));
          if (result.list.contains("warranty_management")) items1.add(HomeMessage("报修", "repair.png", "repair_page", unCountMessage: 0, tag: "warranty_management", tag2: "BX"));
        } else {
          // items1.add(HomeMessage("工资", "salary.png", "salary_page",tag2: "GZ"));
        }
        items1.add(HomeMessage("校务投票", "school_vote.png", "school_vote_page", tag2: "XWTP"));
        items1.add(HomeMessage("信息采集", "info_collection.png", "info_collection_page", tag2: "XXCJ"));

        items2.add(
            HomeMessage("经费管理", "fund_manager.png", "fund_manager_page", tag2: "JFGL"));
        items2.add(
            HomeMessage("报销管理", "reimburse_manager.png", "reimbursement_page", tag2: "BXGL"));
        items2.add(
            HomeMessage("工资", "salary.png", "salary_page", tag2: "GZ"));


        items3.add(
            HomeMessage("通知", "notice.png", "teacher_notice_page", tag2: "TZ"));
        items3.add(HomeMessage("作业", "home_work.png", "teacher_home_work_page", tag2: "ZY"));
        items3.add(HomeMessage("成绩单", "transcript.png", "teacher_transcript_page", tag2: "CJD"));
        items3.add(HomeMessage(
            "在校表现", "school_performance.png", "teacher_performance_page", tag2: "ZXBX"));
        items3.add(HomeMessage("成长档案", "growth_file.png", "teacher_growth_new_page", tag2: "CZDA"));
        items3.add(HomeMessage("每周食谱", "weekly_recipe.png", "weekly_recipe_page", tag2: "MZXP"));
        items3.add(HomeMessage("每周竞赛", "weekly_contest.png", "weekly_contest_page", tag2: "MZJS"));
        items3.add(HomeMessage("学生请假", "student_leave.png", "student_leave_page", tag2: "XSQJ"));
        items3.add(HomeMessage("学生早退", "student_leave_early.png", "student_leave_early_page", tag2: "XSZT"));
        items3.add(HomeMessage("打卡", "clock_in.png", "clock_in_page", tag2: "DK"));
        items3.add(HomeMessage("班级相册", "class_album.png", "class_album_page", tag2: "BJXC"));

      });
      _loadData2();
    } catch (e) {
      isLoaded = false;
      EasyLoading.dismiss(animation: false);
      showWarnToast(e.message);
    }
  }
}
