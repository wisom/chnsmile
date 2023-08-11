import 'package:chnsmile_flutter/flutter_sound/public/util/LogUtil.dart';
import 'package:chnsmile_flutter/http/dao/clock_in_dao.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/hi_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

import '../../core/hi_state.dart';
import '../../model/clock_in_detail_model.dart';
import '../../model/clock_in_model.dart';
import '../../utils/hi_toast.dart';
import '../../widget/appbar.dart';
import 'clock_in_tab_page.dart';

class ClockInDetailRolePage extends StatefulWidget {
  final Map params;
  String isSchool; //(0:查询教师的打卡列表，2：查询学生的打卡列表)
  ClockIn item;

  ClockInDetailRolePage({Key key, this.params}) : super(key: key) {
    item = params['item'];
    isSchool = params['isSchool'];
  }

  @override
  _ClockInDetailRolePageState createState() => _ClockInDetailRolePageState();
}

class _ClockInDetailRolePageState extends HiState<ClockInDetailRolePage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  List<String> _tabs = [];
  var isLoaded = false;
  ClockInDetail model;

  @override
  void initState() {
    super.initState();
    _tabs.add("已打卡");
    _tabs.add("未打卡");
    _controller = TabController(length: _tabs.length, vsync: this);
    loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 进入详情
  void _onCellClick(ClockIn item) {
    if (getEditStatus(item.releaseStatus)) {
      BoostNavigator.instance
          .push('clock_in_add_page', arguments: {"id": item.punchId});
    } else {
      BoostNavigator.instance.push('clock_in_detail_page', arguments: {
        "item": item,
        "type": widget.isSchool,
        "reviewStatus": item.releaseStatus
      });
    }
  }

  Future<void> loadData() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await ClockInDao.detail(widget.item.punchId);
      LogUtil.d("打卡详情", "result=" + result.toString());
      setState(() {
        model = result;
      });
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      EasyLoading.dismiss(animation: false);
      print(e);
      showWarnToast(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: RefreshIndicator(
            child: Container(
              color: Colors.white,
              child: ListView(
                children: [
                  _buildTopInfo(),
                  box(context),
                  _buildCenterInfo(),
                  box(context),
                  _buildTab(),
                  // _buildTabView()
                ],
              ),
            ),
            onRefresh: loadData));
  }

  _buildTabView() {
    return Flexible(
        child: TabBarView(
            controller: _controller,
            children: _tabs.map((tab) {
              return ClockInTabPage(type: _buildType(tab));
            }).toList()));
  }

  _buildType(String tab) {
    if (tab.contains("已打卡")) {
      return "0";
    } else {
      return "1";
    }
  }

  _buildTab() {
    return HiTab(
      _tabs.map<Tab>((tab) {
        return Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(tab, style: const TextStyle(fontSize: 15)),
            ],
          ),
        );
      }).toList(),
      controller: _controller,
    );
  }

  _buildAppBar() {
    return appBar("打卡详情", rightTitle: "", rightButtonClick: () {});
  }

  _buildDay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "已进行${widget.item?.dayAlready ?? 0}天/共${widget.item?.dayTotal}天",
          style: TextStyle(
              fontSize: 13,
              color: HiColor.color_181717,
              fontWeight: FontWeight.bold),
        ),
        Container(
          width: 71,
          height: 20,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: HiColor.color_00B0F0,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: const Text(
            "导出明细",
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        )
      ],
    );
  }

  _buildCenterInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(17, 13, 9, 15),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          _buildDay(),
          hiSpace(height: 23),
          GridView.builder(
            shrinkWrap: true,
            itemCount: 7,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 0, crossAxisCount: 7),
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  const Text(
                    "日",
                    style: TextStyle(
                        fontSize: 12, color: HiColor.color_000000_A25),
                  ),
                  hiSpace(height: 9),
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: HiColor.color_00B0F0,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Text(
                      "27",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }

  _buildTopInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(17, 13, 9, 15),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          _buildFirstLine(),
          hiSpace(height: 12),
          _buildSecondLine(),
          hiSpace(height: 10),
          _buildThirdLine(),
          hiSpace(height: 10),
          _buildForthLine(),
        ],
      ),
    );
  }

  _buildForthLine() {
    return Row(
      children: [
        const Text(
          "打卡时间：",
          style: TextStyle(fontSize: 13, color: HiColor.color_181717_A50),
        ),
        Text(
          "${model?.startDate ?? ""}-${model?.endDate ?? ""}",
          style: const TextStyle(fontSize: 13, color: HiColor.color_181717_A50),
        ),
      ],
    );
  }

  ///打卡频次（0：每天，1：周一，2：周二，3：周三，4：周四，5：周五，6：周六，7：周日）
  _buildWeek(int week) {
    if (week == 0) {
      return "每天";
    } else if (week == 1) {
      return "周一";
    } else if (week == 2) {
      return "周二";
    } else if (week == 3) {
      return "周三";
    } else if (week == 4) {
      return "周四";
    } else if (week == 5) {
      return "周五";
    } else if (week == 6) {
      return "周六";
    } else if (week == 7) {
      return "周日";
    }
  }

  _buildThirdLine() {
    var frequencys = "";
    if (widget.item?.clockFrequencys?.length == 1 &&
        widget.item?.clockFrequencys[0] == 0) {
      frequencys = "每天";
    } else {
      if (widget.item?.clockFrequencys != null &&
          widget.item?.clockFrequencys?.isNotEmpty) {
        for (var i = 0; i < widget.item.clockFrequencys.length; i++) {
          var f = widget.item.clockFrequencys[i];
          frequencys = frequencys + (i == 0 ? "" : "、") + _buildWeek(f);
        }
      }
    }

    return Row(
      children: [
        const Text(
          "打卡频次：",
          style: TextStyle(fontSize: 13, color: HiColor.color_181717_A50),
        ),
        Text(
          frequencys,
          style: const TextStyle(fontSize: 13, color: HiColor.color_181717_A50),
        ),
      ],
    );
  }

  _buildSecondLine() {
    var className = "";
    if (widget.item.gradClass != null && widget.item.gradClass.isNotEmpty) {
      className = widget.item.gradClass.join("、");
    }
    return Row(
      children: [
        const Text(
          "参与范围：",
          style: TextStyle(fontSize: 13, color: HiColor.color_181717_A50),
        ),
        Container(
          constraints: const BoxConstraints(maxWidth: 180),
          child: Text(
            className,
            style:
                const TextStyle(fontSize: 13, color: HiColor.color_181717_A50),
          ),
        ),
      ],
    );
  }

  _buildFirstLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              widget.item?.title ?? "",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: HiColor.color_181717),
            ),
            hiSpace(width: 9),
            Text(
              widget.item?.punchStatusLabel ?? "未开始",
              style: TextStyle(fontSize: 13, color: HiColor.color_181717_A50),
            )
          ],
        ),
        const Icon(
          Icons.arrow_forward_ios_outlined,
          size: 10,
          color: HiColor.color_3D3D3D,
        ),
      ],
    );
  }
}
