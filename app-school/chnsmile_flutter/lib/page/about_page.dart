import 'package:chnsmile_flutter/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("关于中国微校"),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            _logo(),
            _text("    将传统实体学校提升为最前沿的移动、智慧的现代虚拟的“云中学校”，实现依法办学、民主办学、人文办学；同时实现学校的办公、管理、家校联系等信息一体化，实现办学效率最大化。"),
            _text("    家校一对一：遵守《个人信息保护法》，保护师生、家长、学生个人信息与隐私，家长与老师一对一沟通交流。"),
            _text("    校务投票：为民主办学，师生、家长对学校各项事务、决策可以进行投票。"),
            _text("    学业追踪：实现对学生学业、素养评估追踪。"),
            _text("    移动办公：学校实现校务通知、公文管理、教师请假管理、教务调课管理、报修管理、工资管理移动办公。"),
            _text("    家校联系：家校通知、作业、成绩单、在校表现、成长档案、每周食谱、每周竞赛等。"),
            _text("    校园资讯：教师学生家长可以即时了解校园资讯。"),
            _text("    专家论坛：全国各大高校各领域专家博导以论坛形式对学生家长老师传播最新的教育理念、教学方法、学习方法、学科理解。"),
          ],
        ),
      ),
    );
  }

  Widget _logo() {
    return const Image(
      image: AssetImage('images/about_logo.png'),
    );
  }

  Widget _text(String text) {
    return Container(
      padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.black, fontFamily: "SimSum"),
      ),
    );
  }
}
