import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class HiBadge extends StatelessWidget {
  final int unCountMessage;
  final Widget child;

  const HiBadge({Key key, this.unCountMessage = 0, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Badge(
        toAnimate: false,
        showBadge: unCountMessage > 0,
        borderRadius: BorderRadius.circular(20),
        padding: const EdgeInsets.only(left: 6, right: 6, top: 3, bottom: 3),
        shape: BadgeShape.circle,
        position: BadgePosition.topEnd(),
        badgeContent: Text('$unCountMessage',
            style:
            const TextStyle(fontSize: 11, color: Colors.white)),
        child: child);
  }
}
