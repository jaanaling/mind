import 'dart:async';
import 'package:bubblebrain/core/components/app_logic/repository/core_repository.dart';
import 'package:bubblebrain/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bubblebrain/core/dependency_injection.dart';
import 'package:bubblebrain/core/utils/log.dart';
import 'package:bubblebrain/core/utils/amplitude.dart';
import 'package:bubblebrain/core/utils/hex_to_color.dart';
import 'package:bubblebrain/core/utils/app_event.dart';

part 'core_event.dart';
part 'core_state.dart';

class CoreBloc extends Bloc<CoreEvent, CoreState> {
  final _coreRepository = locator<CoreRepository>();
  CoreBloc() : super(CoreInitial()) {
    on<GetCoreData>(_onGetCoreData);
    on<SendEvents>(_onSendEvents);
    on<UrlChangedEvent>(_onUrlChangedEvent);
  }

  Future<void> _onGetCoreData(
    CoreEvent event,
    Emitter<CoreState> emit,
  ) async {
    try {
      final coreData = _coreRepository.coreData;
      final targetUrl = _coreRepository.getTargetUrl();
      String? lastUrl = await _coreRepository.getLastUrl();
      if (lastUrl == null || lastUrl.isEmpty) {
        await _coreRepository.saveLastUrl(targetUrl);
      }
      lastUrl = await _coreRepository.getLastUrl();

      AmplitudeUtil.log(AppEvent.coreLoaded(url: lastUrl ?? targetUrl));

      emit(
        CoreDataLoadedState(
          lastUrl: Uri.parse(lastUrl ?? targetUrl),
          targetUrl: Uri.parse(targetUrl),
          isNotchEnabled: coreData.result.isNotchEnabled,
          backgroundColor: hexToColor(coreData.result.backgroundColor),
          isNavBarEnabled: coreData.result.isNavBarEnabled,
        ),
      );
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> _onSendEvents(
    CoreEvent event,
    Emitter<CoreState> emit,
  ) async {
    try {
      AmplitudeUtil.log(
        AppEvent.analyticInit(
          afDevKey: AppConstants.appsflyerDevKey,
          amplitudeDevKey: AppConstants.amplitudeKey,
          appId: AppConstants.appId,
          appIosId: AppConstants.iosAppId,
          appVersion: _coreRepository.appVersion,
          idfa: _coreRepository.idfa,
          os: _coreRepository.os,
        ),
      );
      if (_coreRepository.coreData.result.isSendEventsFacebook ||
          _coreRepository.coreData.result.isSendEventsAf) {
        Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
          final eventsResponse = await _coreRepository.getEvents();
          if (eventsResponse.result.events.isNotEmpty) {
            for (final event in eventsResponse.result.events) {
              if (event.event == 'dep') {
                await _coreRepository.sendAppsflyerEvent(
                  AppEvent.afPurchase(
                    currency: event.currency ?? '',
                    sum: event.sum ?? 0,
                  ),
                );

                await _coreRepository.sendFacebookPurchaseEvent(
                  event.currency ?? '',
                  event.sum ?? 0,
                );

                AmplitudeUtil.log(
                  AppEvent.afPurchase(
                    currency: event.currency ?? '',
                    sum: event.sum ?? 0,
                  ),
                );
              } else if (event.event == 'reg') {
                await _coreRepository.sendFacebookRegistrationEvent();
                await _coreRepository.sendAppsflyerEvent(
                  AppEvent.afCompleteRegistration(),
                );

                AmplitudeUtil.log(
                  AppEvent.afCompleteRegistration(),
                );
              }
            }
            await _coreRepository.confirmEvent();
          }
        });
      }
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> _onUrlChangedEvent(
    UrlChangedEvent event,
    Emitter<CoreState> emit,
  ) async {
    try {
      await _coreRepository.saveLastUrl(event.url);
      await _coreRepository.setStat(event.url);
    } catch (e) {
      logger.d(e);
    }
  }
}
