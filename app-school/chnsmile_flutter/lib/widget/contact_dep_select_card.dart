import 'package:chnsmile_flutter/model/contact_depart_model.dart';
import 'package:chnsmile_flutter/model/contact_select.dart';
import 'package:chnsmile_flutter/utils/list_utils.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hi_base/color.dart';

class ContactDepSelectCard extends StatefulWidget {
  final DeptInfo item;
  final String router;
  final bool isShowDepCheck;
  final bool isNeedFloor;
  final ValueChanged<DeptInfo> onItemSelect;

  const ContactDepSelectCard(
      {Key key, this.item, this.router, this.isShowDepCheck = true, this.isNeedFloor = false, this.onItemSelect})
      : super(key: key);

  @override
  _ContactDepSelectCardState createState() => _ContactDepSelectCardState();
}

class _ContactDepSelectCardState extends State<ContactDepSelectCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          BoostNavigator.instance.push("teacher_select_page", arguments: {
            "pid": widget.item.id,
            "router": widget.router,
            "isShowDepCheck": widget.isShowDepCheck,
            "isNeedFloor": widget.isNeedFloor
          });
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(border: borderLine(context)),
          child: _buildContent(),
        ));
  }

  _buildContent() {
    return Row(
      children: [
        widget.isShowDepCheck ? InkWell(
          onTap: () {
            setState(() {
              widget.item.selected = !widget.item.selected;
              // 点击组织，不单单要移除组织，还要移除里面的人员
              ListUtils.selecters
                  .removeWhere((e) => !e.isDep && e.parentId == widget.item.id);
              ListUtils.addOrRemoveContact(
                  ContactSelect(widget.item.id, widget.item.title, true, widget.item.parentId, orgName: widget.item.title));
            });
            if (widget.onItemSelect != null) {
              widget.onItemSelect(widget.item);
            }
          },
          child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: widget.item.selected
                  ? const Icon(Icons.check_circle_outlined,
                      color: primary, size: 24)
                  : const Icon(Icons.radio_button_unchecked_outlined,
                      color: Colors.grey, size: 24)),
        ) : Container(),
        Expanded(
            child: Text(
          widget.item.title,
          style: const TextStyle(fontSize: 15, color: Colors.black),
        )),
        const Icon(Icons.arrow_forward_ios_rounded,
            size: 16, color: Colors.grey)
      ],
    );
  }
}
