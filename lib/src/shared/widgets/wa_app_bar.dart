import 'package:flutter/material.dart';

class WaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;

  const WaAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      leading: leading,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
