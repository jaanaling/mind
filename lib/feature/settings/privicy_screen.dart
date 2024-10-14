import 'package:bubblebrain/ui_kit/base_app_bar/widget/base_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivicyScreen extends StatefulWidget {
  const PrivicyScreen({super.key});

  @override
  State<PrivicyScreen> createState() => _PrivicyScreenState();
}

class _PrivicyScreenState extends State<PrivicyScreen> {
  late final WebViewController _controller;

  bool isFirstPage = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: CupertinoColors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: BaseAppBar(title: "Privacy Policy",),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: WebViewWidget(
                controller: _controller
                  ..loadRequest(
                     Uri.parse("https://bubblebraina.com/privacy.html"))
                  ..setBackgroundColor(
                    Colors.transparent,
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
