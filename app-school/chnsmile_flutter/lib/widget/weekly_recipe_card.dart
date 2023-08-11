import 'package:chnsmile_flutter/model/notice_model.dart';
import 'package:chnsmile_flutter/model/weekly_recipe_model.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/attach_grid.dart';
import 'package:chnsmile_flutter/widget/level_text.dart';
import 'package:chnsmile_flutter/widget/publish_department.dart';
import 'package:chnsmile_flutter/widget/publish_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class WeeklyRecipeCard extends StatelessWidget {
  final WeeklyRecipe weeklyRecipe;
  final ValueChanged<WeeklyRecipe> onCellClick;

  const WeeklyRecipeCard({Key key, this.weeklyRecipe, this.onCellClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onCellClick(weeklyRecipe);
        },
        child: Container(
          decoration: BoxDecoration(border: borderLine(context)),
          padding:
              const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
          child: Column(
            children: [
              _buildTop(),
              hiSpace(height: 10),
              _buildContent(),
            ],
          ),
        ));
  }

  _buildTop() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(weeklyRecipe.title, style: const TextStyle(fontSize: 13, color: Colors.black)),
    );
  }

  _buildContent() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PublishDepartment(name: weeklyRecipe.author),
          PublishTime(time: weeklyRecipe.publishTime)
        ],
      ),
    );
  }

}
