import 'package:amplitude_flutter/amplitude.dart';
import 'package:bubblebrain/core/constants/app_constants.dart';
import 'package:bubblebrain/core/utils/log.dart';
import 'package:bubblebrain/core/utils/app_event.dart';

class AmplitudeUtil {
  static final Amplitude _analytics =
      Amplitude.getInstance(instanceName: 'project');

  static Future<void> initializeAmplitude() async {
    try {
      await _analytics.init(AppConstants.amplitudeKey);
    } catch (e) {
      logger.e(e);
    }
  }

  static Future<void> log(
    AppEvent event,
  ) async {
    try {
      await _analytics.logEvent(
        event.eventName,
        eventProperties: event.parameters,
      );
    } catch (e) {
      logger.e(e);
    }
  }

  
  static Future<void> setUserId(String userId) async {
    await _analytics.setUserId(userId);
  }

  static Future<void> logFailure(
    Failure failure,
    String condition,
    StackTrace? stackTrace,
  ) async {
    try {
      await _analytics.logEvent(
        failure == Failure.exception ? 'Exception' : 'Error',
        eventProperties: {
          'Condition': condition,
          'Stack trace': stackTrace.toString(),
        },
      );
    } catch (e) {
      logger.e(e.toString());
    }
  }
}

enum Failure { exception, error }
