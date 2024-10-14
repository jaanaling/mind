class AppEvent {
  final String eventName;
  final Map<String, dynamic>? parameters;

  AppEvent._(this.eventName, this.parameters);

  factory AppEvent.gameLoaded({
    required String reason,
  }) {
    return AppEvent._('game_loaded', {
      'reason': reason,
    });
  }

  factory AppEvent.afConvertOk() {
    return AppEvent._('af_convert_ok', null);
  }

  factory AppEvent.afNotOrganic() {
    return AppEvent._('af_not_organic', null);
  }

  factory AppEvent.afOrganic() {
    return AppEvent._('af_organic', null);
  }

  factory AppEvent.afConvertFail({
    required String dataFail,
  }) {
    return AppEvent._('af_convert_fail', {
      'data_fail': dataFail,
    });
  }

  factory AppEvent.afTimeout() {
    return AppEvent._('af_timeout', null);
  }

  factory AppEvent.afConversionMergeFinishOk({
    required String oldLink,
    required String newLink,
  }) {
    return AppEvent._('af_conversion_merge_finish_ok', {
      'old_link': oldLink,
      'new_link': newLink,
    });
  }

  factory AppEvent.afConversionMergeStart() {
    return AppEvent._('af_conversion_merge_start', null);
  }

  factory AppEvent.afConversionMergeFinishFail({
    required String oldLink,
    required String reason,
  }) {
    return AppEvent._('af_conversion_merge_finish_fail', {
      'old_link': oldLink,
      'reason': reason,
    });
  }

  factory AppEvent.afConvertTime({
    required bool isSuccess,
    required double seconds,
  }) {
    return AppEvent._('af_convert_time', {
      'is_success': isSuccess.toString(),
      'seconds': seconds,
    });
  }

  factory AppEvent.afInit({
    required String afDevKey,
    required String afId,
  }) {
    return AppEvent._('af_init', {'af_dev_key': afDevKey, 'af_id': afId});
  }

  factory AppEvent.analyticInit({
    required String afDevKey,
    required String amplitudeDevKey,
    required String appId,
    required String appIosId,
    required String appVersion,
    required String? idfa,
    required String os,
  }) {
    return AppEvent._('analytic_init', {
      'af_dev_key': afDevKey,
      'amplitude_dev_key': amplitudeDevKey,
      'app_id': appId,
      'app_ios_id': appIosId,
      'app_version': appVersion,
      'idfa': idfa ?? 'N/A',
      'os': os,
    });
  }

  factory AppEvent.firstPageTime({
    required String url,
    required double seconds,
  }) {
    return AppEvent._('first_page_time', {
      'url': url,
      'seconds': seconds,
    });
  }

  factory AppEvent.coreLoaded({
    required String url,
  }) {
    return AppEvent._('core_loaded', {
      'url': url,
    });
  }

  factory AppEvent.whitePage() {
    return AppEvent._('white_page', null);
  }

  factory AppEvent.afPurchase({
    required String currency,
    required double sum,
  }) {
    return AppEvent._('af_purchase', {
      'af_currency': currency,
      'af_revenue': sum,
    });
  }

  factory AppEvent.firebasePushTokenOk({
    required String token,
    required double seconds,
  }) {
    return AppEvent._('firebase_push_token_ok', {
      'token': token,
      'seconds': seconds,
    });
  }

  factory AppEvent.firebasePushTokenFail({required String reason}) {
    return AppEvent._('firebase_push_token_fail', {
      'reason': reason,
    });
  }

  factory AppEvent.afCompleteRegistration() {
    return AppEvent._('af_complete_registration', {
      'registration_method': 'email',
    });
  }

  factory AppEvent.backendRequestSend({
    required String backendUrl,
    required Map<String, dynamic> body,
    required String fcmToken,
    required String? existedUserId,
  }) {
    return AppEvent._('backend_request_sent', {
      'backend_url': backendUrl,
      'body': body.toString(),
      'fcm_token': fcmToken,
      'existed_user_id': existedUserId,
    });
  }

  factory AppEvent.backendCallbackTime({
    required Map<String, dynamic> info,
    required double seconds,
  }) {
    return AppEvent._('backend_callback_time', {
      'info': info.toString(),
      'seconds': seconds,
    });
  }

  factory AppEvent.backendResponseOk({
    required String url,
    required Map<String, dynamic> response,
  }) {
    return AppEvent._(
      'backend_response_ok',
      {'url': url, 'response': response.toString()},
    );
  }

  factory AppEvent.backendResponseFail({
    required String url,
    required String reason,
  }) {
    return AppEvent._(
      'backend_response_fail',
      {'url': url, 'reason': reason},
    );
  }

  factory AppEvent.uidOk({
    required String uid,
  }) {
    return AppEvent._(
      'u_id_ok',
      {'u_id': uid},
    );
  }

  factory AppEvent.urlsOk({
    required String url,
  }) {
    return AppEvent._(
      'urls_ok',
      {'urls': '[$url]'},
    );
  }

  factory AppEvent.urlsFail({
    required String url,
    required String reason,
  }) {
    return AppEvent._(
      'urls_fail',
      {'urls': '[$url]', 'reason': reason},
    );
  }
}
