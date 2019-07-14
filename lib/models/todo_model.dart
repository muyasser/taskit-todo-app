import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class Todo {
  int id;
  String name;
  bool isComplete;
  int priority;

  Todo({
    this.id,
    @required this.name,
    this.isComplete = false,
    this.priority = 0,
  }) : assert(priority == 0 || priority == 1 || priority == 2);

  // helper methods
  static int mapStatus(bool status) {
    if (status == true) {
      return 1;
    } else {
      return 0;
    }
  }

  static String mapPriority(int priority) {
    switch (priority) {
      case 1:
        return 'Important';
        break;
      case 2:
        return 'Critical';
        break;
      default:
        return 'Basic';
        break;
    }
  }

  // todo to map
  static Map<String, dynamic> todoToMap(int id, Todo todo) {
    Map<String, dynamic> map = {};

    map['id'] = id;
    map['name'] = todo.name;
    map['status'] = mapStatus(todo.isComplete);
    map['priority'] = todo.priority;

    return map;
  }
}
