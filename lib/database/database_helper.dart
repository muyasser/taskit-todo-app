import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import '../models/todo_model.dart';

const String TABLE_NAME = 'Tasks';

int _todosCount;
int _doneTodosCount = 0;

class DatabaseHelper {
  // database object
  static Database _database;

  // database getter
  Future<Database> get db async {
    if (_database == null) {
      _database = await initDb();
    }

    return _database;
  }

  // open the database if exists on filesystem, otherwise create it
  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentDirectory.path, 'tasks.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);

    return db;
  }

  // create the database tables if not created
  void _onCreate(Database database, int version) async {
    // When creating the db, create the table

    database.execute(
        '''CREATE TABLE $TABLE_NAME (id INTEGER PRIMARY KEY, name TEXT, status INTEGER, priority INTEGER )''');
  }

  // helper methods

  // fetch all todos (default on start the app)
  Future<List<Todo>> getTodos() async {
    var dbClient = await db;

    List<Map<String, dynamic>> todosListOfMaps =
        await dbClient.query(TABLE_NAME);

    List<Todo> todos = [];

    for (int i = 0; i < todosListOfMaps.length; i++) {
      todos.add(
        Todo(
            id: todosListOfMaps[i]['id'],
            name: todosListOfMaps[i]['name'],
            isComplete: todosListOfMaps[i]['status'] == 0 ? false : true,
            priority: todosListOfMaps[i]['priority']),
      );

      // get done todos count query

      _doneTodosCount = Sqflite.firstIntValue(await dbClient
          .rawQuery('SELECT COUNT(*) FROM $TABLE_NAME WHERE status = 1'));
    }

    _todosCount = todos.length;
    print('All todos count : $_todosCount');
    print('Done todos count : $_doneTodosCount');

    return todos;
  }

  // save todo
  Future<int> saveTodo(Todo todo) async {
    var dbClient = await db;

    var table =
        await dbClient.rawQuery("SELECT MAX(id) + 1 as id FROM $TABLE_NAME");

    int id = table.first["id"];

    int result = await dbClient.insert(TABLE_NAME, Todo.todoToMap(id, todo));
    print('Added todo id: ${result.toString()}');

    return result;
  }

  // removeTodo

  Future<int> deletetodo(int id) async {
    var dbClient = await db;

    int result =
        await dbClient.delete(TABLE_NAME, where: 'id = ?', whereArgs: [id]);

    print('deleted element at index $result');

    return result;
  }

  // update todo

  Future<int> updateTodo(Map<String, dynamic> data) async {
    var dbClient = await db;

    int result = await dbClient
        .update(TABLE_NAME, data, where: 'id = ?', whereArgs: [data['id']]);

    return result;
  }

  // remove all todos

  Future<int> removeAllTodos() async {
    var dbClient = await db;

    int result = await dbClient.delete(TABLE_NAME);
    print(result);

    todosCount = 0;
    doneTodosCount = 0;

    return result;
  }

  // get all todos count
  int get todosCount => _todosCount;
  int get doneTodosCount => _doneTodosCount;

  set todosCount(int value) => _todosCount = value;
  set doneTodosCount(int value) => _doneTodosCount = value;

  // get done todos count
}
