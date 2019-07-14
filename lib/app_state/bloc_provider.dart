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

  int allTasks = 0;

  void _init() async {
    List<Todo> todosList = await databaseHelper.getTodos();

    allTasks = todosList.length;

    _controller.sink.add(todosList);
  }

  static final DatabaseHelper databaseHelper = DatabaseHelper();

  static final BehaviorSubject<List<Todo>> _controller = BehaviorSubject();

  Future<List<Todo>> get getAllTodos => databaseHelper.getTodos();

  static Stream<List<Todo>> get todoListStream => _controller.stream;

  void dispose() {
    _controller.close();
  }

  void addTodo(Todo todo) async {
    await databaseHelper.saveTodo(todo);

    await getAllTodos.then((todos) {
      _controller.sink.add(todos);
    });

    print(('stream added'));
  }

  void removeTodo(Todo todo) async {
    //print('trying to delete element at index $id');

    await databaseHelper.deletetodo(todo.id);

    await getAllTodos.then((todos) {
      _controller.sink.add(todos);
    });
  }

  static void removeAllTodos() async {
    databaseHelper.removeAllTodos();

    _controller.sink.add([]);
  }

  Future<int> getTodosLength() async {
    return databaseHelper.todosCount;
  }
}
