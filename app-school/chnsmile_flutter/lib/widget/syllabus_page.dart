import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/model/course_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';
import 'package:hi_cache/hi_cache.dart';

class SyllabusPage extends StatelessWidget {
  final List<Course> list;
  var colorList = [
    const Color.fromARGB(255, 242, 175, 138),
    const Color.fromARGB(255, 169, 218, 116),
    const Color.fromARGB(255, 142, 188, 226),
    const Color.fromARGB(255, 255, 151, 151),
    const Color.fromARGB(255, 255, 214, 103),
    const Color.fromARGB(255, 208, 206, 206),
    const Color.fromARGB(255, 213, 186, 235),
  ];
  var infoList = [];
  var weekList = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];

  var dateList = [];
  var currentWeekIndex = 0;

  SyllabusPage({Key key, this.list}) : super(key: key) {
    infoList = List.filled(84, "");
    if (list.isNotEmpty) {
      // 设置week
      weekList = list.map((Course cource) {
        return cource.weekName;
      }).toList();
      // 设置info
      for (var i1 = 0; i1 < list.length; i1++) {
        Course course = list[i1];
        if (course.subNodeCourses.isNotEmpty) {
          for (var i2 = 0; i2 < course.subNodeCourses.length; i2++) {
            SubNodeCourses sub = course.subNodeCourses[i2];
            var index = i1 + (7 * (sub.classSubNode - 1));
            if (isFamily) {
              infoList[index] = sub.courseName +"\n" + (sub.teacherName ?? '');
            } else {
              infoList[index] = sub.courseName +"\n" + (sub.className ?? '');
            }
          }
        }
      }
    }
  }

  bool get isFamily {
    return HiCache.getInstance().get(HiConstant.spIdentity) == "1";
  }

  bool get isTeacher {
    return HiCache.getInstance().get(HiConstant.spIdentity) == "2";
  }

  @override
  Widget build(BuildContext context) {
    var monday = 1;
    var mondayTime = DateTime.now();

    //获取本周星期一是几号
    while (mondayTime.weekday != monday) {
      mondayTime = mondayTime.subtract(const Duration(days: 1));
    }

    mondayTime.year; //2020 年
    mondayTime.month; //6(这里和js中的月份有区别，js中是从0开始，dart则从1开始，我们无需再进行加一处理) 月
    mondayTime.day; //6 日
    // nowTime.hour ;//6 时
    // nowTime.minute ;//6 分
    // nowTime.second ;//6 秒
    for (int i = 0; i < 7; i++) {
      dateList.add(
          mondayTime.month.toString() + "/" + (mondayTime.day + i).toString());
      if ((mondayTime.day + i) == DateTime.now().day) {
        currentWeekIndex = i + 1;
      }
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MediaQuery.removePadding(
              removeBottom: true,
              context: context,
              child: SizedBox(
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 8,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 8, childAspectRatio: 1 / 1),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        color: index == currentWeekIndex
                            ? const Color(0xf7f7f7)
                            : Colors.white,
                        child: Center(
                          child: index == 0
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("星期",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87)),
                                    hiSpace(height: 5),
                                    const Text("日期",
                                        style: TextStyle(fontSize: 12)),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(weekList[index - 1],
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: index == currentWeekIndex
                                                ? Colors.lightBlue
                                                : Colors.black87)),
                                    hiSpace(height: 5),
                                    Text(dateList[index - 1],
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: index == currentWeekIndex
                                                ? Colors.lightBlue
                                                : Colors.black87)),
                                  ],
                                ),
                        ),
                      );
                    }),
              )),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GridView.builder(
                        shrinkWrap: true,
                        // physics:ClampingScrollPhysics(),
                        itemCount: 12,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1, childAspectRatio: 1 / 2),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              child: Center(
                                child: Text(
                                  (index + 1).toInt().toString(),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xff5ff5),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.black12, width: 0.5),
                                  right: BorderSide(
                                      color: Colors.black12, width: 0.5),
                                ),
                              ));
                        }),
                  ),
                  Expanded(
                    flex: 7,
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 84,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7, childAspectRatio: 1 / 2),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.black12,
                                                  width: 0.5),
                                              right: BorderSide(
                                                  color: Colors.black12,
                                                  width: 0.5),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                Container(
                                    margin: const EdgeInsets.all(0.5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: infoList[index] != "" ? colorList[index % 7] : Colors.white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        infoList[index],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            letterSpacing: 1),
                                      ),
                                    ))
                              ],
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          ),
          _bottomView
        ],
      ),
    );
  }

  @override
  String pageTitle() => "我的课表";

  final Widget _topView = SizedBox(
    height: 30,
    child: Expanded(
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          itemBuilder: (BuildContext context, int index) {
            return Text("dd");
          }),
    ),
  );

  final Widget _centerView = Expanded(
    child: GridView.builder(
        itemCount: 63,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
              // width: 25,
              // height: 80,
              child: Center(
                child: Text(
                  (index + 1).toString(),
                  style: TextStyle(fontSize: 15),
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xff5ff5),
                border: Border.all(color: Colors.black12, width: 0.5),
              ));
        }),
  );

  final Widget _bottomView = SizedBox(
    height: 30,
    child: Row(
      children: [
        //底部view可自行扩充
      ],
    ),
  );
}
