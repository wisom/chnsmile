import 'package:flutter/material.dart';

class PublishTime extends StatelessWidget {
  final String time;

  const PublishTime({Key key, this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('发布时间:',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
