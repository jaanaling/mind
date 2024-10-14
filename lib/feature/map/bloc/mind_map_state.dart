part of 'mind_map_bloc.dart';

abstract class MindMapState extends Equatable {
  const MindMapState();

  @override
  List<Object?> get props => [];
}

class MindMapInitial extends MindMapState {}

class MindMapLoaded extends MindMapState {
  final List<MindMap> maps;

  const MindMapLoaded(this.maps);

  @override
  List<Object?> get props => [maps];
}

class MindMapError extends MindMapState {
  final String message;

  const MindMapError(this.message);

  @override
  List<Object?> get props => [message];
}
