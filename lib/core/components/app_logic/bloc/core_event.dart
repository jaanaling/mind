part of 'core_bloc.dart';

sealed class CoreEvent extends Equatable {
  const CoreEvent();
}

final class GetCoreData extends CoreEvent {
  @override
  List<Object> get props => [];
}

final class SendEvents extends CoreEvent {
  @override
  List<Object> get props => [];
}

final class UrlChangedEvent extends CoreEvent {
  final String url;

  const UrlChangedEvent({required this.url});

  @override
  List<Object> get props => [url];
}
