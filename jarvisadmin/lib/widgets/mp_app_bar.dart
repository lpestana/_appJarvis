import 'package:flutter/material.dart';

import 'mp_button_icon.dart';

class MPAppBar extends PreferredSize {
  MPAppBar({
    this.title,
    this.withLeading = true,
    this.actions,
  });

  final Widget title;
  final bool withLeading;
  final List<Widget> actions;

  @override
  Size get preferredSize => Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: preferredSize.height,
        child: AppBar(
          automaticallyImplyLeading: false,
          title: title,
          leadingWidth: 40,
          leading: !withLeading ? null : MPButtonIcon(
            iconData: Icons.chevron_left,
            onTap: () => Navigator.of(context).pop(),
          ),
          actions: actions,
        ),
      ),
    );
  }
}
