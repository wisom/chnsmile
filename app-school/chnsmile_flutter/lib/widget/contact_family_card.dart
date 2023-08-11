import 'package:chnsmile_flutter/model/contact_family_model.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:chnsmile_flutter/widget/base_expandable_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';

typedef VoidCallback = void Function(String classId, String userId, String studentId, bool isSelected);

class ContactFamilyCard extends StatefulWidget {
  final ClassInfo item;
  final List<StudentParentInfo> subItems;
  final VoidCallback itemPress;

  const ContactFamilyCard({Key key, this.item, this.subItems, this.itemPress}) : super(key: key);

  @override
  _ContactFamilyCardState createState() => _ContactFamilyCardState();
}

class _ContactFamilyCardState extends BaseExpandableContentState<ContactFamilyCard> {

  @override
  double topHeight() {
    return 40;
  }

  @override
  double marginLR() {
    return 0;
  }

  @override
  buildContent() {
    if (widget.subItems == null) return Container();
    return Column(
      children: widget.subItems.asMap().entries.map((entry) {
      int index = entry.key;
      StudentParentInfo item = entry.value;
        return Container(
          height: 50,
          decoration: BoxDecoration(
            border: (index != widget.subItems.length - 1) ? borderLine(context) : const Border(bottom: BorderSide.none)
          ),
          child: Row(
            children: [
              Checkbox(value: item.selected ?? false, onChanged: (value) {
                widget.itemPress("", item.userId, item.studentId, value);
              }),
              showAvatorIcon(avatarImg: item.avatarImg, name: item.studentName, width: 30, fontSize: 15),
              hiSpace(width: 10),
              Text('${item.studentName} - ${item.relations} (${item.parentName})', style: const TextStyle(fontSize: 13, color: Colors.black87))
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  buildTop() {
    return Row(
      children: [
        Checkbox(value: widget.item.selected ?? false, onChanged: (value) {
          setState(() {
            widget.item.selected = !widget.item.selected;
          });
          widget.itemPress(widget.item.classId, "", "", value);
        }),
        Text(
          '${widget.item.classGradeName} ${widget.item.className}家长',
          style: const TextStyle(fontSize: 13, color: Colors.black),
        )
      ],
    );
  }
}
