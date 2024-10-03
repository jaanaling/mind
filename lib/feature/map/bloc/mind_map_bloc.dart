import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bubblebrain/core/dependency_injection.dart';
import 'package:bubblebrain/core/utils/log.dart';
import 'package:bubblebrain/feature/map/models/mind_map.dart';
import 'package:bubblebrain/feature/map/models/node.dart';
import 'package:bubblebrain/feature/map/repository/repository.dart';

part 'mind_map_event.dart';
part 'mind_map_state.dart';

class MindMapBloc extends Bloc<MindMapEvent, MindMapState> {
  final MindMapRepository repository = locator<LocalMindMapRepository>();

  MindMapBloc() : super(MindMapInitial()) {
    on<LoadMindMaps>(_onLoadMindMaps);
    on<AddNode>(_onAddNode);
    on<RemoveNode>(_onRemoveNode);
    on<RemoveMap>(_onRemoveMap);
    on<SaveMap>(_onSaveMap);
  }

  Future<void> _onLoadMindMaps(
    LoadMindMaps event,
    Emitter<MindMapState> emit,
  ) async {
    try {
      final maps = await repository.fetchMindMaps();
      emit(MindMapLoaded(maps));
    } catch (e) {
      emit(const MindMapError('Failed to load mind maps'));
    }
  }

  Future<void> _onAddNode(AddNode event, Emitter<MindMapState> emit) async {
    if (state is MindMapLoaded) {
      final loadedState = state as MindMapLoaded;
      final updatedMaps = loadedState.maps.map((map) {
        if (map.id == event.mapId) {
          return map.copyWith(
            nodes: List.from(map.nodes)..add(event.node),
          );
        }
        return map;
      }).toList();
      emit(MindMapLoaded(updatedMaps));
    }
  }

  Future<void> _onRemoveNode(
    RemoveNode event,
    Emitter<MindMapState> emit,
  ) async {
    if (state is MindMapLoaded) {
      final loadedState = state as MindMapLoaded;
      final updatedMaps = loadedState.maps.map((map) {
        if (map.id == event.mapId) {
          return map.copyWith(
            nodes: map.nodes.where((node) => node.id != event.nodeId).toList(),
          );
        }
        return map;
      }).toList();
      emit(MindMapLoaded(updatedMaps));
    }
  }

  Future<void> _onRemoveMap(
    RemoveMap event,
    Emitter<MindMapState> emit,
  ) async {
    if (state is MindMapLoaded) {
      final loadedState = state as MindMapLoaded;
      final updatedMaps =
          loadedState.maps.where((map) => map.id != event.map.id).toList();
      repository.deleteMindMap(event.map.id);
      emit(MindMapLoaded(updatedMaps));
    }
    logger.d('Map removed');
  }

  Future<void> _onSaveMap(SaveMap event, Emitter<MindMapState> emit) async {
    await repository.saveMindMap(event.map);
    emit(MindMapLoaded(await repository.fetchMindMaps()));
  }
}
