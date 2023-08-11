import 'package:chnsmile_flutter/model/salary_model.dart';
import 'package:chnsmile_flutter/utils/format_util.dart';
import 'package:chnsmile_flutter/utils/utils.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/base_expandable_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class SalaryCard extends StatefulWidget {
  final Salary salary;

  const SalaryCard({Key key, this.salary}) : super(key: key);

  @override
  _SalaryCardState createState() => _SalaryCardState();
}

class _SalaryCardState extends BaseExpandableContentState<SalaryCard> {
  @override
  buildContent() {
    return Container(
      decoration: BoxDecoration(color: Colors.white,
      borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Colors.grey[300], width: 0.5)
      ),
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: widget.salary.tableHead.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, childAspectRatio: 1.2),
          itemBuilder: (BuildContext context, int index) {
            var item = widget.salary.tableHead[index];
            return Container(
              child: Column(
                children: [
                  Container(
                    width: Utils.width / 4,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 6, bottom: 6),
                    decoration: const BoxDecoration(color: primary),
                    child: Text(item.title??'/', style: const TextStyle(fontSize: 13, color: Colors.black)),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 6, left: 20, right: 20, bottom: 6),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Text(item.data??'/', maxLines: 2, style: const TextStyle(fontSize: 12, color: Colors.black)),
                  )
                ],
              ),
            );
          }),
      );
  }

  @override
  double marginLR() {
    return 10;
  }

  @override
  buildTop() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.salary.title,
              style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black)),
          hiSpace(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 160,
                child: Text('发布人:${widget.salary.author ?? ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ),
              Text('发布时间:${dateYearMothAndDayAndMinutes(widget.salary.createTime)}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }
}
