import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/todo_model.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

class BlocProvider {
  BlocProvider._createInstance() {
    _init();
  }

  static BlocProvider _blocProvider;

  static BlocProvider get instance {
    if (_blocProvider == null) {
      _blocProvider = BlocProvider._createInstance();
    }

    return _blocProvider;
  }

  void _init() async {
    List<Todo> todosList = await databaseHelper.getTodos();

    _controller.sink.add(todosList);

    _statsController.sink
        .add({'allTodos': allTodosCount, 'doneTodos': doneTodosCount});
  }

  static final DatabaseHelper databaseHelper = DatabaseHelper();

  static final BehaviorSubject<List<Todo>> _controller = BehaviorSubject();
  static final BehaviorSubject<Map<String, int>> _statsController =
      BehaviorSubject();

  static Future<List<Todo>> get _getAllTodos => databaseHelper.getTodos();

  static Stream<List<Todo>> get todoListStream => _controller.stream;
  static Stream<Map<String, int>> get statsStream => _statsController.stream;

  void dispose() {
    _controller.close();
    _statsController.close();
  }

  void addTodo(Todo todo) async {
    await databaseHelper.saveTodo(todo);

    await _getAllTodos.then((todos) {
      _controller.sink.add(todos);
    });

    //print(('stream added'));
    _statsController.sink
        .add({'allTodos': allTodosCount, 'doneTodos': doneTodosCount});
  }

  void removeTodo(Todo todo) async {
    //print('trying to delete element at index $id');

    await databaseHelper.deletetodo(todo.id);

    await _getAllTodos.then((todos) {
      _controller.sink.add(todos);
    });

    _statsController.sink
        .add({'allTodos': allTodosCount, 'doneTodos': doneTodosCount});
  }

  void removeAllTodos() async {
    databaseHelper.removeAllTodos();

    await _getAllTodos.then((todos) {
      _controller.sink.add(todos);
    });

    _statsController.sink
        .add({'allTodos': allTodosCount, 'doneTodos': doneTodosCount});
  }

  void updateTodo(Map<String, dynamic> data) async {
    await databaseHelper.updateTodo(data);

    await _getAllTodos.then((todos) {
      _controller.sink.add(todos);
    });

    _statsController.sink
        .add({'allTodos': allTodosCount, 'doneTodos': doneTodosCount});
  }

  void updateTodoStatus(Todo todo) async {
    bool newStatus = !(todo.isComplete);

    Map<String, dynamic> data = {
      'id': todo.id,
      'name': todo.name,
      'status': Todo.mapStatus(newStatus),
      'priority': todo.priority,
    };

    updateTodo(data);

    print('status updated success');
  }

  int get allTodosCount => databaseHelper.todosCount;
  int get doneTodosCount => databaseHelper.doneTodosCount;
}
