import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bubblebrain/core/theme/src/app_text_styles.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final String title;
  final Widget? titleWidget;
  final Widget? leading;

  const BaseAppBar({
    super.key,
    this.actions,
    required this.title,
    this.titleWidget,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      backgroundColor: const Color(0xFF320072),
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),
      toolbarHeight: kToolbarHeight * 1.5,
      title: titleWidget ??
          Text(
            title,
            style: AppTextStyles.appBarText.copyWith(fontFamily: 'Roboto'),
          ).tr(),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 1.5);
}
