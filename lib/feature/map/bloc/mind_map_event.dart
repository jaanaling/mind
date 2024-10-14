part of 'mind_map_bloc.dart';

abstract class MindMapEvent extends Equatable {
  const MindMapEvent();

  @override
  List<Object?> get props => [];
}

class LoadMindMaps extends MindMapEvent {}

class AddNode extends MindMapEvent {
  final String mapId;
  final Node node;

  const AddNode(this.mapId, this.node);

  @override
  List<Object?> get props => [mapId, node];
}

class RemoveMap extends MindMapEvent {
  final MindMap map;

  const RemoveMap(this.map);

  @override
  List<Object?> get props => [map];
}

class RemoveNode extends MindMapEvent {
  final String mapId;
  final String nodeId;

  const RemoveNode(this.mapId, this.nodeId);

  @override
  List<Object?> get props => [mapId, nodeId];
}

class SaveMap extends MindMapEvent {
  final MindMap map;

  const SaveMap(this.map);

  @override
  List<Object?> get props => [map];
}
