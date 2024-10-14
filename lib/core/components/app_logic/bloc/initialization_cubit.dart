import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bubblebrain/routes/route_value.dart';
import 'package:bubblebrain/core/constants/app_constants.dart';
import 'package:bubblebrain/core/dependency_injection.dart';
import 'package:bubblebrain/core/utils/amplitude.dart';
import 'package:bubblebrain/core/utils/app_event.dart';
import 'package:bubblebrain/core/utils/log.dart';
import 'package:bubblebrain/core/components/app_logic/repository/core_repository.dart';

part 'initialization_state.dart';

class InitializationCubit extends Cubit<InitializationState> {
  InitializationCubit() : super(InitializationInitial());

  final _coreRepository = locator<CoreRepository>();

  Future<void> initialize() async {
    try {
      await Future.delayed(Duration(seconds: 1));      await _coreRepository.initializeIDFA();
      await _coreRepository.getNotificationPermission();
      final haveInternet = await _coreRepository.checkInternetConnection();
      if (!haveInternet) {
        await AmplitudeUtil.log(
          AppEvent.gameLoaded(reason: 'No internet'),
        );
        emit(InitializedState(startRoute: RouteValue.mindMap.path));
      } else {
        await AmplitudeUtil.initializeAmplitude();
        final startResponse = await _coreRepository.start();
        logger.i(startResponse.result.isWaitAppsflyer);
        if (startResponse.ok && startResponse.result.isActive) {
          await _coreRepository.getFirebaseToken();
          if (startResponse.result.isWaitAppsflyer ||
              startResponse.result.isSendEventsAf) {
            final appsflyerId = await _coreRepository.initAppsflyer();
            await AmplitudeUtil.log(
              AppEvent.afInit(
                afDevKey: AppConstants.appsflyerDevKey,
                afId: appsflyerId,
              ),
            );
            if (startResponse.result.isWaitAppsflyer) {
              await _coreRepository.getConversionData();
            }
          }
          if (startResponse.result.targetUrl.isNotEmpty) {
            emit(
              InitializedState(
                startRoute: RouteValue.coreScreen.path,
              ),
            );
          }
        } else {
          AmplitudeUtil.log(
            AppEvent.gameLoaded(
              reason:
              "Parameter${!startResponse.ok ? " 'ok'" : ""}${!startResponse.ok && !startResponse.result.isActive ? " and" : ""}${!startResponse.result.isActive ? " 'isActive'" : ""} is false.",
            ),
          );
          emit(InitializedState(startRoute: RouteValue.mindMap.path));
        }
      }
    } catch (e) {
      logger.d(e);
      if (e is DioException) {
        await AmplitudeUtil.log(
          AppEvent.gameLoaded(reason: 'POST /start request timed out.'),
        );
        emit(InitializedState(startRoute: RouteValue.mindMap.path));
      }
    }
  }
}
