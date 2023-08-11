import 'package:chnsmile_flutter/model/contact_depart_model.dart';
import 'package:chnsmile_flutter/model/contact_select.dart';
import 'package:chnsmile_flutter/utils/common.dart';
import 'package:chnsmile_flutter/utils/list_utils.dart';
import 'package:chnsmile_flutter/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

class ContactUserSelectCard extends StatefulWidget {
  final UserInfo item;
  final String pid;
  final bool isNeedFloor;
  final ValueChanged<UserInfo> onItemSelect;

  const ContactUserSelectCard({Key key, this.item, this.pid, this.isNeedFloor = false,  this.onItemSelect}) : super(key: key);

  @override
  _ContactUserSelectCardState createState() => _ContactUserSelectCardState();
}

class _ContactUserSelectCardState extends State<ContactUserSelectCard> {
  List<String> dropValues = List.filled(20, "1");

  @override
  void initState() {
    super.initState();
    print("isNeedFloor: ${widget.isNeedFloor}");
    for (var i = 0; i < 20; i++) {
      dropValues[i] = (i + 1).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onSelect,
        child: Container(
          height: 50,
          decoration: BoxDecoration(border: borderLine(context)),
          child: _buildContent(),
        ));
  }

  onSelect() {
    setState(() {
      widget.item.selected = !widget.item.selected;
      ListUtils.addOrRemoveContact(ContactSelect(
        widget.item.userId,
        widget.item.userName,
        false,
        widget.item.orgId,
        teacherId: widget.item.teacherId,
        avatorUrl: widget.item.avatarImg,
        floor: widget.item.floor,
        orgName: widget.item.orgName
      ));
      // 点击成员，不单单要移除成员，当所有的组织成员移除后，还要移除里面组织
      if (!widget.item.selected) {
        bool founded = false;
        for (var e in ListUtils.selecters) {
          if (!e.isDep && widget.pid == e.parentId) {
            founded = true;
          }
        }
        if (!founded) {
          print("widget.pid: ${widget.pid}");
          ListUtils.addOrRemoveContact(
              ContactSelect(widget.pid, "", true, "0", floor: widget.item.floor));
        }
      }
      if (widget.onItemSelect != null) {
        widget.onItemSelect(widget.item);
      }
    });
  }

  _buildContent() {
    return Row(
      children: [
        InkWell(
          onTap: onSelect,
          child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: widget.item.selected
                  ? const Icon(Icons.check_circle_outlined,
                      color: primary, size: 24)
                  : const Icon(Icons.radio_button_unchecked_outlined,
                      color: Colors.grey, size: 24)),
        ),
        showAvatorIcon(
            width: 28,
            fontSize: 13,
            avatarImg: widget.item.avatarImg,
            name: widget.item.userName),
        hiSpace(width: 10),
        Expanded(
            child: Text(
          widget.item.userName,
          style: const TextStyle(fontSize: 15, color: Colors.black),
        )),
        widget.isNeedFloor ? _buildSelect() : Container()
      ],
    );
  }

  _buildSelect() {
    return Container(
        width: 40,
        alignment: Alignment.center,
        child: DropdownButton(
            onChanged: (value) {
              setState(() {
                widget.item.floor = value;
                ListUtils.selecters.forEach((item) {
                  if (item.id == widget.item.userId) {
                    item.floor = value;
                  }
                });

              });
            },
            iconSize: 14,
            value: widget.item.floor,
            menuMaxHeight: 300,
            hint: const Text('1',
                style: TextStyle(color: Colors.grey, fontSize: 12)),
            isExpanded: false,
            underline: Container(height: 1, color: Colors.transparent),
            items: dropValues.asMap().entries.map((entry) {
              int index = entry.key;
              return DropdownMenuItem(
                  child: Text((index + 1).toString()),
                  value: (index + 1).toString());
            }).toList()));
  }
}
