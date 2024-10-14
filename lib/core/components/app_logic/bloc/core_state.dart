part of 'core_bloc.dart';

sealed class CoreState extends Equatable {
  const CoreState();
}

final class CoreInitial extends CoreState {
  @override
  List<Object> get props => [];
}

final class CoreDataLoadedState extends CoreState {
  final Uri targetUrl;
  final bool isNotchEnabled;
  final Color? backgroundColor;
  final bool isNavBarEnabled;
  final Uri lastUrl;

  const CoreDataLoadedState({
    required this.lastUrl,
    required this.targetUrl,
    required this.isNotchEnabled,
    required this.backgroundColor,
    required this.isNavBarEnabled,
  });

  @override
  List<Object> get props => [targetUrl, isNotchEnabled, isNavBarEnabled];
}
