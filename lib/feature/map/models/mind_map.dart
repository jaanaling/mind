// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:bubblebrain/feature/map/models/node.dart';

class MindMap {
  final String id;
  final String? title;
  final List<Node> nodes;
  final String? description;
  final String template;
  final String tag;
  final List<Connection> connections;

  MindMap({
    required this.description,
    required this.template,
    required this.tag,
    required this.id,
    required this.title,
    required this.nodes,
    required this.connections,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title ?? 'Unnamed',
      'nodes': nodes.map((node) => node.toJson()).toList(),
      'connections': connections.map((conn) => conn.toJson()).toList(),
      'description': description ?? '',
      'template': template,
      'tag': tag,
    };
  }

  factory MindMap.fromJson(Map<String, dynamic> json) {
    return MindMap(
      id: json['id'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      template: json['template'] as String,
      tag: json['tag'] as String,
      nodes: (json['nodes'] as List)
          .map((nodeJson) => Node.fromJson(nodeJson as Map<String, dynamic>))
          .toList(),
      connections: (json['connections'] as List)
          .map(
            (connJson) => Connection.fromJson(connJson as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  MindMap copyWith({
    String? id,
    String? title,
    List<Node>? nodes,
    List<Connection>? connections,
    String? description,
    String? template,
    String? tag,
  }) {
    return MindMap(
      id: id ?? this.id,
      title: title ?? this.title,
      nodes: nodes ?? this.nodes,
      connections: connections ?? this.connections,
      description: description ?? this.description,
      template: template ?? this.template,
      tag: tag ?? this.tag,
    );
  }

  @override
  bool operator ==(covariant MindMap other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        listEquals(other.nodes, nodes) &&
        other.description == description &&
        other.template == template &&
        other.tag == tag &&
        listEquals(other.connections, connections);
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ nodes.hashCode ^ connections.hashCode;
  }
}

class Connection {
  final String nodeId1;
  final String nodeId2;

  Connection({
    required this.nodeId1,
    required this.nodeId2,
  });

  Map<String, dynamic> toJson() {
    return {
      'nodeId1': nodeId1,
      'nodeId2': nodeId2,
    };
  }

  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
      nodeId1: json['nodeId1'] as String,
      nodeId2: json['nodeId2'] as String,
    );
  }

  Connection copyWith({
    String? nodeId1,
    String? nodeId2,
  }) {
    return Connection(
      nodeId1: nodeId1 ?? this.nodeId1,
      nodeId2: nodeId2 ?? this.nodeId2,
    );
  }

  @override
  bool operator ==(covariant Connection other) {
    if (identical(this, other)) return true;

    return other.nodeId1 == nodeId1 && other.nodeId2 == nodeId2;
  }

  @override
  int get hashCode => nodeId1.hashCode ^ nodeId2.hashCode;
}

enum MapTags {
  idea(name: 'Idea'),
  task(name: 'Task'),
  question(name: 'Question'),
  target(name: 'Target'),
  note(name: 'Note'),
  ideaForRevision(name: 'Idea for revision'),
  urgent(name: 'Urgent'),
  resource(name: 'Resource'),
  problem(name: 'Problem'),
  solution(name: 'Solution'),
  instructions(name: 'Instructions'),
  priority(name: 'Priority'),
  untagged(name: 'Untagged');

  const MapTags({
    required this.name,
  });

  final String name;
}

enum MapTemples {
  Untempled(name: 'Untempled'),
  ProjectPlanning(name: 'Project Planning'),
  Brainstorming(name: 'Brainstorming'),
  StudyPlan(name: 'Study Plan'),
  ProblemAnalysisAndSolutions(name: 'Problem Analysis and Solutions'),
  CreatingAProduct(name: 'Creating a Product'),
  UserJourneyMapping(name: 'User Journey Mapping'),
  ContentCalendar(name: 'Content Calendar'),
  TeamCollaboration(name: 'Team Collaboration'),
  MarketingStrategy(name: 'Marketing Strategy'),
  EventPlanning(name: 'Event Planning'),
  SWOTAnalysis(name: 'SWOT Analysis');


  const MapTemples({
    required this.name,
  });

  final String name;
}
