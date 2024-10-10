import 'package:get_it/get_it.dart';
import 'package:bubblebrain/feature/map/repository/repository.dart';

import 'components/app_logic/repository/core_repository.dart';

final locator = GetIt.instance;

void setupDependencyInjection() {
  locator.registerSingleton(LocalMindMapRepository());
  locator.registerLazySingleton(() => CoreRepository());
}
