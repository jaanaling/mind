// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

class Node {
  final String id;
  String? title;
  String? description;
  Offset position;
  String nodeType;
  String tag;
  String color;
  double size;

  Node({
    required this.id,
    required this.title,
    required this.position,
    required this.tag,
    required this.nodeType,
    required this.color,
    required this.size,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title ?? 'Unnamed',
      'position': {'dx': position.dx, 'dy': position.dy},
      'tag': tag,
      'nodeType': nodeType,
      'color': color,
      'size': size,
      'description': description ?? '',
    };
  }

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      id: json['id'] as String,
      description: json['description'] as String?,
      tag: json['tag'] as String,
      title: json['title'] as String?,
      position: Offset(
        json['position']['dx'] as double,
        json['position']['dy'] as double,
      ),
      nodeType: json['nodeType'] as String,
      color: json['color'] as String,
      size: json['size'] as double,
    );
  }

  @override
  bool operator ==(covariant Node other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.tag == tag &&
        other.position == position &&
        other.nodeType == nodeType &&
        other.color == color &&
        other.description == description &&
        other.size == size;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        position.hashCode ^
        nodeType.hashCode ^
        color.hashCode ^
        description.hashCode ^
        size.hashCode;
  }

  Node copyWith({
    String? id,
    String? title,
    Offset? position,
    String? nodeType,
    String? color,
    double? size,
    String? description,
    String? tag,
  }) {
    return Node(
      tag: tag ?? this.tag,
      description: description ?? this.description,
      id: id ?? this.id,
      title: title ?? this.title,
      position: position ?? this.position,
      nodeType: nodeType ?? this.nodeType,
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }
}

enum NodeType {
  idea(name: 'Idea'),
  task(name: 'Task'),
  resource(name: 'Resource'),
  problem(name: 'Problem'),
  solution(name: 'Solution');

  const NodeType({
    required this.name,
  });

  final String name;
}

enum NodeTag {
  untagged(name: 'Untagged'),
  priority(name: 'Priority'),
  idea(name: 'Idea'),
  urgent(name: 'Urgent'),
  question(name: 'Question'),
  target(name: 'Target'),
  resource(name: 'Resource'),
  risk(name: 'Risk'),
  note(name: 'Note'),
  ideaForRevision(name: 'Idea For Revision'),
  instructions(name: 'Instructions');

  const NodeTag({
    required this.name,
  });

  final String name;
}
