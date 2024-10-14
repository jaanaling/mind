import 'package:bubblebrain/core/components/app_logic/bloc/core_bloc.dart';
import 'package:bubblebrain/core/dependency_injection.dart';
import 'package:bubblebrain/core/utils/amplitude.dart';
import 'package:bubblebrain/core/utils/app_event.dart';
import 'package:bubblebrain/feature/core/presentation/screens/widgets/bottom_bar_core.dart';
import 'package:bubblebrain/routes/route_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bubblebrain/feature/core/presentation/theme/theme.dart';

class CoreScreen extends StatefulWidget {
  const CoreScreen({super.key});

  @override
  State<CoreScreen> createState() => _CoreScreenState();
}

class _CoreScreenState extends State<CoreScreen> {
  late final WebViewController _controller;
  final _coreBloc = locator<CoreBloc>();
  late DateTime _startLoadTime;
  late DateTime _endLoadTime;
  final ValueNotifier<Color> _urlNotifierBack =
      ValueNotifier<Color>(CoreTheme.color.unActiveIconColor);
  final ValueNotifier<Color> _urlNotifierForward =
      ValueNotifier<Color>(CoreTheme.color.unActiveIconColor);

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

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) {
            if (change.url != null) {
              _coreBloc.add(UrlChangedEvent(url: change.url ?? ''));
              if (change.url!.contains('github.com')) {
                context.go(RouteValue.mindMap.path);
              }
            }
            _controller.canGoBack().then(
                  (value) => _urlNotifierBack.value = value
                      ? CoreTheme.color.activeIconColor
                      : CoreTheme.color.unActiveIconColor,
                );
            _controller.canGoForward().then(
                  (value) => _urlNotifierForward.value = value
                      ? CoreTheme.color.activeIconColor
                      : CoreTheme.color.unActiveIconColor,
                );
          },
          onPageStarted: (String url) {
            if (isFirstPage) {
              _startLoadTime = DateTime.now();
            }
          },
          onPageFinished: (String url) {
            if (isFirstPage) {
              _endLoadTime = DateTime.now();
              final loadTime = _endLoadTime.difference(_startLoadTime);
              AmplitudeUtil.log(
                AppEvent.firstPageTime(
                  url: url,
                  seconds: loadTime.inMicroseconds / 1000000.0,
                ),
              );
            }
            isFirstPage = false;
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _coreBloc
        ..add(GetCoreData())
        ..add(SendEvents()),
      child: BlocBuilder<CoreBloc, CoreState>(
        builder: (context, state) {
          if (state is CoreDataLoadedState) {
            return CupertinoPageScaffold(
              backgroundColor: state.backgroundColor ?? Colors.transparent,
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: WebViewWidget(
                        controller: _controller
                          ..loadRequest(state.lastUrl)
                          ..setBackgroundColor(
                            state.backgroundColor ?? Colors.transparent,
                          ),
                      ),
                    ),
                    Visibility(
                      visible: state.isNavBarEnabled,
                      child: BottomBarCore(
                        controller: _controller,
                        urlNotifierBack: _urlNotifierBack,
                        urlNotifierForward: _urlNotifierForward,
                        homeUrl: state.targetUrl,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const CupertinoPageScaffold(
              backgroundColor: CupertinoColors.black,
              child: Center(
                child: CupertinoActivityIndicator(
                  color: CupertinoColors.white,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
