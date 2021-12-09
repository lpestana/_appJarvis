import 'package:flutter/material.dart';

class MPButtonIcon extends StatelessWidget {
  MPButtonIcon({
    this.iconData,
    this.onTap,
  });

  final IconData iconData;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 40,
        height: 40,
        child: Icon(iconData),
      ),
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
    );
  }
}
