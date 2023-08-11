import 'package:flutter/material.dart';

class PublishDepartment extends StatelessWidget {
  final String name;
  final String tips;

  const PublishDepartment({Key key, this.tips = '发布部门:', this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(tips, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Container(
          width: 80,
          child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ),
      ],
    );
  }
}
