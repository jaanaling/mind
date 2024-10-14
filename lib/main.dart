import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/dependency_injection.dart';
import 'core/utils/amplitude.dart';
import 'feature/app/presentation/app_root.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    setupDependencyInjection();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await Firebase.initializeApp();
    FirebaseMessaging.instance;

    await AmplitudeUtil.initializeAmplitude();

    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
    };

    runApp(
      EasyLocalization(
        startLocale: const Locale('de'),
        supportedLocales: const [
          Locale('en'),
          Locale('de'),
          Locale('it'),
          Locale('es'),
          Locale('fr'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const AppRoot(),
      ),
    );
  }, (Object error, StackTrace stackTrace) {
    _handleAsyncError(error, stackTrace);
  });
}

void _handleFlutterError(FlutterErrorDetails details) {
  AmplitudeUtil.logFailure(
    details.exception is Exception ? Failure.exception : Failure.error,
    details.exception.toString(),
    details.stack,
  );
}

void _handleAsyncError(Object error, StackTrace stackTrace) {
  AmplitudeUtil.logFailure(
    error is Exception ? Failure.exception : Failure.error,
    error.toString(),
    stackTrace,
  );
}
