import 'package:chnsmile_flutter/core/hi_base_tab_state.dart';
import 'package:chnsmile_flutter/http/dao/school_performance_dao.dart';
import 'package:chnsmile_flutter/model/school_performance_model.dart';
import 'package:chnsmile_flutter/model/student_info.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/utils.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/behavior_grid.dart';
import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/hi_dashed_line.dart';
import 'package:chnsmile_flutter/widget/hi_time_axis.dart';
import 'package:chnsmile_flutter/widget/loading_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class SchoolPerformancePage extends StatefulWidget {
  final String studentId;

  const SchoolPerformancePage({Key key, this.studentId}) : super(key: key);

  @override
  _SchoolPerformancePageState createState() => _SchoolPerformancePageState();
}

class _SchoolPerformancePageState extends HiBaseTabState<SchoolPerformanceModel,
    Performance, SchoolPerformancePage> {
  StudentInfo _studentInfo;
  bool isLoader = true;

  @override
  void initState() {
    super.initState();
    needLoadMore(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar("在校表现"),
        body: LoadingContainer(
            isLoading: false,
            onRefreshClick: onRefreshClick,
            child: Column(children: [Expanded(child: super.build(context))])));
  }

  _buildHeader() {
    if (_studentInfo == null) return Container();
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      height: 180,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/growth_bg.png"), fit: BoxFit.cover)),
      child: Stack(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: cachedImage(_studentInfo?.avatarImg,
                    width: 80,
                    height: 80,
                    placeholder: "images/default_avator.png"),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text('姓名:${_studentInfo?.studentName}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black)),
                        hiSpace(width: 18),
                        Text('性别:${_studentInfo?.gender}',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black87)),
                      ],
                    ),
                    hiSpace(height: 10),
                    Row(
                      children: [
                        Text(
                            '年级/班:${_studentInfo?.gradeName}${_studentInfo?.className}',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black87))
                      ],
                    ),
                    hiSpace(height: 10),
                    Row(
                      children: [
                        Text('班主任:${_studentInfo?.headTeacherName}',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black87)),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            left: 40,
            bottom: 0,
            child: Container(
                height: 50,
                child: HiDashedLine(
                  axis: Axis.vertical,
                  count: 4,
                  dashedWidth: 2,
                  dashedHeight: 6,
                  color: primary,
                )),
          )
        ],
      ),
    );
  }

  _buildTimeLine() {
    if (dataList != null) {}
    return dataList?.length > 0
        ? ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(right: 6),
            itemCount: dataList?.length,
            itemBuilder: (BuildContext context, int index) {
              return HiPaintCirLineItem(
                100,
                index,
                isDash: true,
                marginLeft: 11,
                leftWidget: _buildTimeTile(dataList[index]),
                leftLineColor: primary,
                DottedLineLenght: 3,
                DottedSpacing: 5,
                alignment: Alignment.centerLeft,
                cententWight: _buildContent(dataList[index]),
                timeAxisLineWidth: 2,
              );
            })
        : !isLoader ? Container(
            alignment: Alignment.center,
            height: 400,
            child: EmptyView(onRefreshClick: () {
              loadData(loadMore: false);
            }),
          ) : Container();
  }

  _buildTimeTile(Performance performance) {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(
          color: const Color(0xffF7F8FE),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 2)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dateYear(performance.createTime),
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(dateMonthAndDay(performance.createTime),
              style: const TextStyle(fontSize: 13, color: Colors.black))
        ],
      ),
    );
  }

  _buildContent(Performance performance) {
    return Container(
        width: Utils.width - 130,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: 6, top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: Colors.grey[300], width: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: performance.title,
                  style:
                      const TextStyle(fontSize: 15, color: HiColor.dark_text)),
              WidgetSpan(
                  child: BehaviorGrid(items: performance.contentResults)),
            ])),
            Container(
              padding: const EdgeInsets.only(top: 3),
              alignment: Alignment.centerRight,
              child: Text('发布人:${performance.teacherName ?? '老师'}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          ],
        ));
  }

  @override
  get contentChild {
    return ListView(children: [_buildHeader(), _buildTimeLine()]);
  }

  @override
  Future<SchoolPerformanceModel> getData(int pageIndex) async {
    EasyLoading.show(status: '加载中...');
    SchoolPerformanceModel result =
        await SchoolPerformanceDao.get(pageIndex: pageIndex, pageSize: 40);
    isLoader = false;
    EasyLoading.dismiss(animation: false);
    return result;
  }

  @override
  List<Performance> parseList(SchoolPerformanceModel result) {
    setState(() {
      _studentInfo = result.studentInfo;
    });
    return result.behavior != null ? result.behavior.rows : [];
  }
}
