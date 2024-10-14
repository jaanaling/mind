import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bubblebrain/feature/map/bloc/mind_map_bloc.dart';
import 'package:bubblebrain/routes/go_router_config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MindMapBloc()..add(LoadMindMaps()),
      child: CupertinoApp.router(
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          EasyLocalization.of(context)!.delegate,
        ],
        theme: const CupertinoThemeData(
          brightness: Brightness.dark,
          textTheme: CupertinoTextThemeData(),
        ),
        routerConfig: globalRouter,
        color: Colors.white,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
