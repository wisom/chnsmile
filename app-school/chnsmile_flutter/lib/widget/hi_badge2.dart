import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class HiBadge2 extends StatelessWidget {
  final int unCountMessage;
  final Widget child;

  const HiBadge2({Key key, this.unCountMessage = 0, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Badge(
        toAnimate: false,
        showBadge:  unCountMessage != null ? unCountMessage > 0 : false,
        borderRadius: BorderRadius.circular(20),
        padding: const EdgeInsets.only(left: 7, right: 7, top: 3, bottom: 3),
        shape: BadgeShape.square,
        position: BadgePosition.topEnd(),
        badgeContent: (unCountMessage != null && unCountMessage > 0) ? Text('$unCountMessage',
            style:
            const TextStyle(fontSize: 11, color: Colors.white)) : Container(),
        child: child);
  }
}
