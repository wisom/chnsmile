import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/core/hi_state.dart';
import 'package:chnsmile_flutter/http/dao/attach_dao.dart';
import 'package:chnsmile_flutter/http/dao/default_apply_dao.dart';
import 'package:chnsmile_flutter/http/dao/repair_dao.dart';
import 'package:chnsmile_flutter/model/default_apply_model.dart';
import 'package:chnsmile_flutter/model/local_file.dart';
import 'package:chnsmile_flutter/model/oa_people.dart';
import 'package:chnsmile_flutter/model/repair_detail_model.dart';
import 'package:chnsmile_flutter/model/sys_org_model.dart';
import 'package:chnsmile_flutter/model/upload_attach.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/hi_toast.dart';
import 'package:chnsmile_flutter/utils/list_utils.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:chnsmile_flutter/widget/border_time_line.dart';
import 'package:chnsmile_flutter/widget/normal_input.dart';
import 'package:chnsmile_flutter/widget/normal_multi_input.dart';
import 'package:chnsmile_flutter/widget/normal_select.dart';
import 'package:chnsmile_flutter/widget/oa_submit_button.dart';
import 'package:chnsmile_flutter/widget/select_attach.dart';
import 'package:chnsmile_flutter/widget/star.dart';
import 'package:chnsmile_flutter/widget/w_pop/w_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/string_util.dart';
import 'package:hi_base/view_util.dart';
import 'package:hi_cache/hi_cache.dart';
import 'package:path/path.dart';

import '../../widget/hi_button.dart';

class InfoCollectionNewPage extends StatefulWidget {
  final Map params;
  String id;
  List<String> list = ["", ""];

  InfoCollectionNewPage({Key key, this.params}) : super(key: key) {
    id = params['id'];
  }

  @override
  _InfoCollectionNewPageState createState() => _InfoCollectionNewPageState();
}

class _InfoCollectionNewPageState extends HiState<InfoCollectionNewPage> {
  RepairDetailModel model;
  bool isLoaded = false;
  final TextEditingController _controller = TextEditingController();
  ValueChanged<bool> needSelect;
  int need = 0;

  @override
  void initState() {
    super.initState();
    loadDefaultData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadDefaultData() async {
    try {
      EasyLoading.show(status: '加载中...');
      var result = await DefaultApplyDao.get();
      // if (isEdit) {
      //   var result1 = await RepairDao.detail(widget.id);
      //   setState(() {});
      //   isLoaded = true;
      // }
      setState(() {});
      SysOrgModel rs = await RepairDao.getSysOrg();
      setState(() {
        if (rs == null || rs.list.isEmpty) {
          showWarnToast("部门数据为空，请联系管理员添加");
        }
      });
      isLoaded = true;
      EasyLoading.dismiss(animation: false);
    } catch (e) {
      isLoaded = true;
      print(e);
      EasyLoading.dismiss(animation: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HiColor.color_F7F7F7,
      appBar: _buildAppBar(),
      body: isLoaded ? _buildTop(context) : Container(),
    );
  }

  SingleChildScrollView _buildTop(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(19, 19, 19, 76),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12, 17, 12, 21),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: [
                const Text(
                  "学生健康码收集",
                  textAlign: TextAlign.start,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      color: HiColor.color_181717,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  margin: const EdgeInsets.fromLTRB(0, 12, 0, 10),
                  decoration: const BoxDecoration(
                      color: HiColor.color_F2F2F7,
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 11),
                  ),
                ),
                _buildRange(),
                line(context),
                hiSpace(height: 20),
                _buildTime()
              ],
            ),
          ),
          hiSpace(height: 17),
          _buildSelectQuestion(context),
          hiSpace(height: 12),
          _buildFillQuestion(context),
          hiSpace(height: 12),
          _buildAddQuestion(),
          hiSpace(height: 12),
          _buildButton(),
          hiSpace(height: 40),
        ],
      ),
    ));
  }

  _buildButton() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          HiButton("保存",
              bgColor: Colors.green, enabled: true, onPressed: () {}),
          hiSpace(width: 20),
          HiButton("发布", onPressed: () {})
        ],
      ),
    );
  }

  _buildSelectQuestion(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(children: [
        _buildFillTop(),
        _buildList(),
        _buildAddOption(),
        line(context),
        _buildBottom()
      ]),
    );
  }

  _buildFillQuestion(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(children: [_buildFillTop(), _buildDesc(), _buildBottom()]),
    );
  }

  _buildDesc() {
    return Container(
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        decoration: const BoxDecoration(
            color: HiColor.color_F2F2F7,
            borderRadius: BorderRadius.all(Radius.circular(6))),
        height: 46,
        width: double.infinity,
        child: const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "输入填写说明",
              hintStyle:
                  TextStyle(fontSize: 11, color: HiColor.color_black_A20),
              border: InputBorder.none,
            ),
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 11, color: HiColor.color_black_A80),
          ),
        ));
  }

  _buildBottom() {
    return Row(
      children: [
        const Expanded(
            child: Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Text("单选",
              style: TextStyle(
                fontSize: 12,
                color: HiColor.color_5A5A5A,
              )),
        )),
        Radio(
          // 按钮的值
          value: 1,
          // 改变事件
          onChanged: (value) {
            setState(() {
              need = value;
            });
          },
          // 按钮组的值
          groupValue: need,
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 13, 0),
          child: Text(
            "必选",
            style: TextStyle(fontSize: 12, color: HiColor.color_5A5A5A),
          ),
        )
      ],
    );
  }

  _buildList() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.list.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          var item = widget.list[index];
          return Column(children: [
            hiSpace(height: 7.5),
            Row(
              children: [
                const InkWell(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(9, 0, 12, 0),
                    child: Icon(Icons.remove_circle_outline,
                        size: 24, color: HiColor.color_black_A60),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      height: 35,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: HiColor.color_F2F2F7,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: TextField(
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            hintText: "请填写说明",
                            hintStyle: TextStyle(
                                fontSize: 10,
                                color: HiColor.color_black_A20,
                                fontWeight: FontWeight.w100),
                            border: InputBorder.none,
                          ),
                          // decoration: InputDecoration(
                          // contentPadding: const EdgeInsets.only(left: 20, right: 20),
                          // border: InputBorder.none,
                          // hintText: widget.hint ?? '',
                          // counterText: '',
                          // hintStyle: const TextStyle(fontSize: 16, color: Colors.grey)),
                          // ),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w100),
                        ),
                      ),
                    )),
                const InkWell(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(9, 0, 12, 0),
                    child:
                        Icon(Icons.menu, size: 24, color: HiColor.color_5A5A5A),
                  ),
                ),
              ],
            ),
            hiSpace(height: 7.5)
          ]);
        });
  }

  InkWell _buildAddOption() {
    return InkWell(
        onTap: () {},
        child: Row(
          children: const [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 10, 11, 16),
              child: Icon(Icons.add, size: 24, color: HiColor.color_5A5A5A),
            ),
            Text(
              "新增选项",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: HiColor.color_5A5A5A),
            )
          ],
        ));
  }

  Row _buildFillTop() {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 17, 0, 15),
          child: Row(
            children: const [
              Text(
                "01.",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: HiColor.color_00B0F0),
              ),
              Text(
                "是否有外出经历",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: HiColor.color_181717),
              ),
            ],
          ),
        )),
        const Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Icon(Icons.delete, size: 20, color: HiColor.color_00B0F0),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Icon(Icons.menu, size: 20, color: HiColor.color_00B0F0),
        ),
        const SizedBox(
          width: 13,
        )
      ],
    );
  }

  InkWell _buildAddQuestion() {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: const [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 17, 11, 17),
              child: Icon(Icons.add, size: 20, color: HiColor.color_00B0F0),
            ),
            Text(
              "添加问题",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: HiColor.color_00B0F0),
            )
          ],
        ),
      ),
    );
  }

  // showDepartDialog(BuildContext context) {
  //   FocusManager.instance.primaryFocus?.unfocus();
  //   // List<QuestionType> list = ["","",""];
  //   // for (var item in sysorgs) {
  //   //   list.add(item.name);
  //   // }
  //
  //   print("list:$list");
  //   showListDialog(context, title: '请选择问题类型', list: list,
  //       onItemClick: (String type, int index) {
  //         setState(() {
  //           // SysOrg item = sysorgs[index];
  //           // orgName = item.name;
  //           // orgId = item.id;
  //         });
  //       });
  // }


  Padding _buildRange() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "参与范围",
              style: TextStyle(
                color: HiColor.color_181717,
                fontSize: 12,
              ),
            ),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                  child: Text(
                    "初一三班-班级群、初一三班-班级群初一三班-班级群、初一三班-班级群初一三班-班级群、初一三班-班级群初一三班-班级群、初一三班-班级群",
                    textDirection: TextDirection.rtl,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: HiColor.color_181717,
                      fontSize: 12,
                    ),
                  ),
                )),
            Icon(Icons.keyboard_arrow_right,
                size: 24, color: HiColor.color_787777)
          ],
        ));
  }

  Column _buildTime() {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text(
            "有效时间",
            style: TextStyle(
              fontSize: 12,
              color: HiColor.color_181717,
            ),
          ),
          const Expanded(
              flex: 1,
              child: Text(
                "开始",
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 12, color: HiColor.color_181717),
              )),
          Container(
            margin: const EdgeInsets.fromLTRB(13, 0, 0, 0),
            height: 27,
            width: 127,
            decoration: const BoxDecoration(
              color: HiColor.color_F7F7F7,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: const Center(
              child: Text(
                "2040 - 03 - 01 12:17",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                ),
              ),
            ),
          )
        ]),
        hiSpace(height: 11),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                "结束",
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 12, color: HiColor.color_181717),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(13, 0, 0, 0),
              height: 27,
              width: 127,
              decoration: BoxDecoration(
                color: HiColor.color_F7F7F7,
                border: Border.all(width: 1, color: HiColor.color_D8D8D8),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              child: const Center(
                child: Text(
                  "2040 - 03 - 01 12:17",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  /// 未发出状态
  bool get isUnSend {
    if (model?.schoolOaRepair == null) {
      return false;
    }
    return model?.schoolOaRepair?.status == 0;
  }

  _buildAppBar() {
    return appBar('新建信息采集表', rightTitle: '', rightButtonClick: () {});
  }
}
