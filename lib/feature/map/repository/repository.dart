import 'dart:convert';
import 'package:bubblebrain/feature/map/models/mind_map.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MindMapRepository {
  Future<List<MindMap>> fetchMindMaps();
  Future<void> saveMindMap(MindMap map);
  Future<void> deleteMindMap(String mapId);
}

class LocalMindMapRepository implements MindMapRepository {
  static const String mindMapsKey = 'mind_maps';

  @override
  Future<List<MindMap>> fetchMindMaps() async {
    final prefs = await SharedPreferences.getInstance();
    final String? mapsString = prefs.getString(mindMapsKey);

    if (mapsString != null) {
      final List<dynamic> jsonList = json.decode(mapsString) as List<dynamic>;
      return jsonList
          .map((json) => MindMap.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> saveMindMap(MindMap map) async {
    final prefs = await SharedPreferences.getInstance();
    final List<MindMap> currentMaps = await fetchMindMaps();

    bool isUpdated = false;
    for (int i = 0; i < currentMaps.length; i++) {
      if (currentMaps[i].id == map.id) {
        currentMaps[i] = map;
        isUpdated = true;
        break;
      }
    }

    if (!isUpdated) {
      currentMaps.add(map);
    }

    final String mapsString =
        json.encode(currentMaps.map((map) => map.toJson()).toList());
    await prefs.setString(mindMapsKey, mapsString);
  }

  @override
  Future<void> deleteMindMap(String mapId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<MindMap> currentMaps = await fetchMindMaps();

    currentMaps.removeWhere((map) => map.id == mapId);

    final String mapsString =
        json.encode(currentMaps.map((map) => map.toJson()).toList());
    await prefs.setString(mindMapsKey, mapsString);
  }
}
