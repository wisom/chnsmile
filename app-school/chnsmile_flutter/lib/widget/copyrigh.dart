import 'package:flutter/material.dart';

class Copyrigh extends StatelessWidget {
  const Copyrigh({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 12,
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: const Text('Copyrigh @ 2021 中国微校 All Rights Reserved', style: TextStyle(fontSize: 12, color: Colors.grey),),
        ));
  }
}
