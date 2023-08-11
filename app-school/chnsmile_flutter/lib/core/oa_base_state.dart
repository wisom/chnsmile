import 'package:flutter/material.dart';

abstract class OABaseState extends StatefulWidget {

  final Map params;
  List<String> pemissions;

  OABaseState({Key key, this.params}) : super(key: key) {
    pemissions = params['pemissions'] != null ? params['pemissions'].cast<String>(): [];
  }

  bool hasPermission(var code) {
    return pemissions.contains(code);
  }
}
