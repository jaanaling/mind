part of 'initialization_cubit.dart';

sealed class InitializationState extends Equatable {
  const InitializationState();
}

final class InitializationInitial extends InitializationState {
  @override
  List<Object> get props => [];
}

final class InitializedState extends InitializationState {
  final String startRoute;

  const InitializedState({required this.startRoute});

  @override
  List<Object> get props => [startRoute];
}
