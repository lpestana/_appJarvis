import 'package:flutter/material.dart';

class MPLogo extends StatelessWidget {
  MPLogo({
    Key key,
    this.fontSize = 40,
  }) : super(key: key);

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: fontSize / 3.5),
          child: Text(
            'Jarvis',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Text(
            'admin',
            style: TextStyle(
              fontSize: fontSize / 2.5,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ],
    );
  }
}
