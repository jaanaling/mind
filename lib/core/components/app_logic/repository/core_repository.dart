import 'dart:async';
import 'dart:io';
import 'package:advertising_id/advertising_id.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:bubblebrain/core/components/app_logic/models/events_response.dart';
import 'package:bubblebrain/core/components/app_logic/models/stat_request.dart';
import 'package:bubblebrain/core/utils/macros_util.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:bubblebrain/core/utils/amplitude.dart';
import 'package:bubblebrain/core/utils/app_event.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:bubblebrain/core/constants/app_constants.dart';
import 'package:bubblebrain/core/utils/log.dart';
import 'package:bubblebrain/core/components/rest_client/rest_client_dio.dart';
import 'package:bubblebrain/core/components/app_logic/models/app_params.dart';
import 'package:bubblebrain/core/components/app_logic/models/attribute.dart';
import 'package:bubblebrain/core/components/app_logic/models/web_view_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoreRepository {
  String? _idfa;
  final _restClient = RestClientDio();
  final _startQuery = '/start';
  final _attributeQuery = '/attribute';
  final _eventsQuery = '/events/queue';
  final _eventsConfirmQuery = '/events/queue/confirm';
  final _statQuery = '/stat';
  final _uidKey = 'uid';
  final _lastUrlKey = 'lastUrl';
  final _facebookAppEvents = FacebookAppEvents();
  Map<String, dynamic>? _conversionData;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  late AppsflyerSdk _appsflyerSdk;
  late AppParams _appParams;
  late CoreData _coreData;
  String lastUrl = '';
  StatRequest? statRequest;
  String? _fcmToken;
  String? _uid;
  String? _appVersion;
  String? _os;

  CoreData get coreData => _coreData;
  String get uid => _uid ?? '';
  String get appVersion => _appVersion ?? '';
  String get idfa => _idfa ?? '';
  String get os => _os ?? '';

  Future<void> initializeIDFA() async {
    try {
      _idfa = await AdvertisingId.id(true);
      await _setAttributes(idfa: _idfa);
    } on PlatformException {
      _idfa = null;
    }
  }

  Future<bool> checkInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.ethernet);
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  Future<CoreData> start() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      _uid = preferences.getString(_uidKey);

      final packageInfo = await PackageInfo.fromPlatform();
      final appId = packageInfo.packageName;
      _appVersion = packageInfo.version;

      final deviceInfoPlugin = DeviceInfoPlugin();
      String osVersion;
      String deviceName;
      String deviceModel;
      String deviceGeneration;

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        _os = 'Android';
        osVersion = androidInfo.version.release;
        deviceName = androidInfo.brand;
        deviceModel = androidInfo.model;
        deviceGeneration = androidInfo.device;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        _os = 'iOS';
        osVersion = iosInfo.systemVersion;
        deviceName = iosInfo.name;
        deviceModel = iosInfo.utsname.machine;
        deviceGeneration = iosInfo.model;
      } else {
        _os = 'Unknown';
        osVersion = 'Unknown';
        deviceName = 'Unknown';
        deviceModel = 'Unknown';
        deviceGeneration = 'Unknown';
      }

      final screenSize =
          MediaQueryData.fromView(ui.PlatformDispatcher.instance.views.first)
              .size;
      final deviceWidth = screenSize.width;
      final deviceHeight = screenSize.height;

      final locale = Platform.localeName;

      _appParams = AppParams(
        uid: _uid,
        appId: appId,
        appVersion: appVersion,
        locale: locale,
        idfa: _idfa ?? '',
        fcmToken: _fcmToken ?? '',
        os: _os ?? '',
        osVersion: osVersion,
        deviceGeneration: deviceGeneration,
        deviceName: deviceName,
        deviceModel: deviceModel,
        deviceWidth: deviceWidth,
        deviceHeight: deviceHeight,
      );

      logger.i(_idfa);

      AmplitudeUtil.log(
        AppEvent.backendRequestSend(
          backendUrl: AppConstants.apiEndpoint,
          body: _appParams.toJson(),
          fcmToken: _fcmToken ?? '',
          existedUserId: _uid,
        ),
      );

      final startTime = DateTime.now();

      final response = await _restClient.post(
        _startQuery,
        body: _appParams.toJson(),
        receiveTimeout: const Duration(seconds: 30),
      );

      final endTime = DateTime.now();

      final duration = endTime.difference(startTime);

      AmplitudeUtil.log(
        AppEvent.backendCallbackTime(
          info: response.data as Map<String, dynamic>,
          seconds: duration.inMicroseconds / 1000000.0,
        ),
      );

      final coreData = CoreData.fromJson(
        response.data as Map<String, dynamic>,
      );
      _coreData = coreData;

      AmplitudeUtil.log(
        AppEvent.backendResponseOk(
          url: AppConstants.apiEndpoint,
          response: response.data as Map<String, dynamic>,
        ),
      );

      if (coreData.result.uid.isNotEmpty) {
        AmplitudeUtil.log(AppEvent.uidOk(uid: coreData.result.uid));
      }

      if (coreData.result.uid.isNotEmpty && _uid != coreData.result.uid) {
        AmplitudeUtil.setUserId(coreData.result.uid);
      }

      if (_uid != coreData.result.uid) {
        preferences.setString(_uidKey, coreData.result.uid);
        _uid = coreData.result.uid;
        _appParams.uid = coreData.result.uid;
      }

      _appParams.fbApplicationId = AppConstants.facebookAppId;
      _appParams.fbAttribution = AppConstants.facebookClientToken;
      _appParams.devKey = AppConstants.appsflyerDevKey;
      _appParams.bundle = AppConstants.appId;

      return coreData;
    } catch (e) {
      AmplitudeUtil.log(
        AppEvent.backendResponseFail(
          url: AppConstants.apiEndpoint,
          reason: e.toString(),
        ),
      );
      rethrow;
    }
  }

  Future<String> initAppsflyer() async {
    final afOptions = AppsFlyerOptions(
      afDevKey: AppConstants.appsflyerDevKey,
      showDebug: true,
      appId: AppConstants.appsflyerAppId,
    );
    _appsflyerSdk = AppsflyerSdk(afOptions);

    _appsflyerSdk.onInstallConversionData((data) {
      logger.i(data);
      _conversionData = (data as Map).cast<String, dynamic>();
      if (_conversionData?['status'] == 'success') {
        AmplitudeUtil.log(AppEvent.afConvertOk());
        if (_conversionData?['payload']['af_status'] == 'Organic') {
          AmplitudeUtil.log(AppEvent.afOrganic());
        } else if (_conversionData?['payload']['af_status'] == 'Non-organic') {
          AmplitudeUtil.log(AppEvent.afNotOrganic());
        }
      } else {
        AmplitudeUtil.log(AppEvent.afConvertFail(dataFail: data.toString()));
      }
    });

    await _appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
    final String? appsflyerId = await _appsflyerSdk.getAppsFlyerUID();
    await _setAttributes(appsflyerId: appsflyerId);

    return appsflyerId ?? '';
  }

  Future<EventsResponse> getEvents() async {
    try {
      final response =
      await _restClient.get(_eventsQuery, queryParams: {'u_id': _uid});

      final eventsResponse = EventsResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
      return eventsResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getFirebaseToken() async {
    try {
      final apnsToken = await _messaging.getAPNSToken();
      if (apnsToken != null) {
        final startTime = DateTime.now();
        final String? token = await _messaging.getToken();
        final endTime = DateTime.now();
        final duration = endTime.difference(startTime);
        if (token != null) {
          AmplitudeUtil.log(
            AppEvent.firebasePushTokenOk(
              token: token,
              seconds: duration.inMicroseconds / 1000000.0,
            ),
          );
        } else {
          AmplitudeUtil.log(
            AppEvent.firebasePushTokenFail(reason: 'Token is empty'),
          );
        }
        _fcmToken = token;
        await _setAttributes(fcmToken: _fcmToken);
        return token;
      } else {
        AmplitudeUtil.log(
          AppEvent.firebasePushTokenFail(reason: 'APNS token is empty'),
        );
        return null;
      }
    } catch (e) {
      AmplitudeUtil.log(AppEvent.firebasePushTokenFail(reason: e.toString()));
      return null;
    }
  }

  Future<void> getNotificationPermission() async {
    try {
      final settings = await _messaging.requestPermission();
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        SharedPreferences.getInstance()
            .then((prefs) => prefs.setBool('notificationsEnabled', false));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> confirmEvent() async {
    try {
      await _restClient.get(_eventsConfirmQuery, queryParams: {'u_id': _uid});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getConversionData() async {
    try {
      DateTime? conversionEndTime;
      final conversionStartTime = DateTime.now();
      final conversionCompleter = Completer<void>();

      final timer = Timer(const Duration(seconds: 10), () async {
        if (!conversionCompleter.isCompleted) {
          await AmplitudeUtil.log(AppEvent.afTimeout());
          conversionEndTime = DateTime.now();
          conversionCompleter.complete();
        }
      });

      _appsflyerSdk.onInstallConversionData((data) {
        timer.cancel();
        _conversionData = (data as Map).cast<String, dynamic>();
        if (_conversionData?['status'] == 'success') {
          AmplitudeUtil.log(AppEvent.afConvertOk());
          if (_conversionData?['payload']['af_status'] == 'Organic') {
            AmplitudeUtil.log(AppEvent.afOrganic());
          } else if (_conversionData?['payload']['af_status'] ==
              'Non-organic') {
            AmplitudeUtil.log(AppEvent.afNotOrganic());
          }
        } else {
          AmplitudeUtil.log(AppEvent.afConvertFail(dataFail: data.toString()));
        }
        conversionEndTime = DateTime.now();

        if (!conversionCompleter.isCompleted) {
          conversionCompleter.complete();
        }
      });
      await conversionCompleter.future;

      if (conversionEndTime != null) {
        final duration = conversionEndTime!.difference(conversionStartTime);
        AmplitudeUtil.log(
          AppEvent.afConvertTime(
            isSuccess: _conversionData?['status'] == 'success',
            seconds: duration.inMicroseconds / 1000000.0,
          ),
        );
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  Future<void> _setAttributes({
    String? appsflyerId,
    String? idfa,
    String? fcmToken,
  }) async {
    try {
      if (_uid != null && _uid!.isNotEmpty) {
        await _restClient.post(
          _attributeQuery,
          body: Attribute(
            uid: _uid,
            appsflyerId: appsflyerId,
            idfa: idfa,
            fcmToken: fcmToken,
          ).toJson(),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setStat(String url) async {
    try {
      if (url != lastUrl) {
        statRequest ??= StatRequest(uid: _uid ?? '', type: 'urls', urls: [url]);

        await _restClient.post(
          _statQuery,
          body: statRequest!.toJson(),
        );

        AmplitudeUtil.log(AppEvent.urlsOk(url: url));

        lastUrl = url;
      }
    } catch (e) {
      AmplitudeUtil.log(AppEvent.urlsFail(url: url, reason: e.toString()));
      rethrow;
    }
  }

  String getTargetUrl() {
    try {
      if (_conversionData != null) {
        AmplitudeUtil.log(
          AppEvent.afConversionMergeStart(),
        );
      } else if (_conversionData == null &&
          coreData.result.isWaitAppsflyer) {
        AmplitudeUtil.log(
          AppEvent.afConversionMergeFinishFail(
            oldLink: _coreData.result.targetUrl,
            reason: 'Error: Conversion data was not received',
          ),
        );
      }

      logger.i(_conversionData);
      final String newTargetUrl = applyMacros(
        _coreData.result.targetUrl,
        {
          ..._appParams.toJson(),
          ..._conversionData?['payload'] as Map<String, dynamic>? ?? {},
        },
      );
      if (_conversionData != null) {
        AmplitudeUtil.log(
          AppEvent.afConversionMergeFinishOk(
            oldLink: _coreData.result.targetUrl,
            newLink: newTargetUrl,
          ),
        );
      }

      return newTargetUrl;
    } catch (e) {
      AmplitudeUtil.log(
        AppEvent.afConversionMergeFinishFail(
          oldLink: _coreData.result.targetUrl,
          reason: e.toString(),
        ),
      );
      rethrow;
    }
  }

  Future<void> sendFacebookRegistrationEvent() async {
    try {
      await _facebookAppEvents.logCompletedRegistration(
        registrationMethod: 'email',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendFacebookPurchaseEvent(String currency, double sum) async {
    try {
      await _facebookAppEvents.logPurchase(amount: sum, currency: currency);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendAppsflyerEvent(
      AppEvent event,
      ) async {
    try {
      await _appsflyerSdk.logEvent(event.eventName, event.parameters);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveLastUrl(
      String url,
      ) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      preferences.setString(_lastUrlKey, url);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getLastUrl() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      return preferences.getString(_lastUrlKey);
    } catch (e) {
      rethrow;
    }
  }
}
