import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bubblebrain/feature/core/presentation/theme/theme.dart';

class BottomBarCore extends StatefulWidget {
  final WebViewController controller;
  final ValueNotifier<Color> urlNotifierBack;
  final ValueNotifier<Color> urlNotifierForward;
  final Uri homeUrl;

  const BottomBarCore({
    super.key,
    required this.controller,
    required this.urlNotifierBack,
    required this.urlNotifierForward,
    required this.homeUrl,
  });

  @override
  State<BottomBarCore> createState() => _BottomBarCoreState();
}

class _BottomBarCoreState extends State<BottomBarCore> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: widget.urlNotifierBack,
      builder: (context, backColor, child) {
        return ValueListenableBuilder<Color>(
          valueListenable: widget.urlNotifierForward,
          builder: (context, forwardColor, child) {
            return CupertinoTabBar(
              backgroundColor: CoreTheme.color.bottomBarBackgroundColor,
              height: kToolbarHeight + 8,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: backColor,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: CoreTheme.color.activeIconColor,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: forwardColor,
                  ),
                  label: '',
                ),
              ],
              onTap: (int index) {
                switch (index) {
                  case 0:
                    if (backColor == CoreTheme.color.activeIconColor) {
                      widget.controller.goBack();
                    }
                  case 1:
                    widget.controller.loadRequest(widget.homeUrl);
                  case 2:
                    if (forwardColor == CoreTheme.color.activeIconColor) {
                      widget.controller.goForward();
                    }
                }
              },
            );
          },
        );
      },
    );
  }
}
