import 'package:complete_todo_app/database/database_helper.dart';
import 'package:flutter/material.dart';

import '../app_state/bloc_provider.dart';
import '../models/todo_model.dart';
import '../widgets/remove_all_tasks_dialog.dart';
import 'info_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

const List<String> _appbarActionList = ['CLEAR TODOS'];

class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  static BlocProvider blocProvider;
  static ScrollController _lvController;
  DatabaseHelper databaseHelper;
  TabController _tabController;

  var todosTab = StreamBuilder<List<Todo>>(
    stream: BlocProvider.todoListStream,
    builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data.length == 0) {
          return Center(
            child: Text('No todos yet'),
          );
        } else {
          return ListView.builder(
            controller: _lvController,
            itemCount: snapshot.data.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final item = snapshot.data[index];
              return Slidable(
                actionPane: SlidableStrechActionPane(),
                actionExtentRatio: 0.2,
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Edit',
                    icon: Icons.edit,
                    color: Colors.grey[300],
                    onTap: () => print('Edite success'),
                  ),
                  IconSlideAction(
                    caption: 'Delete',
                    icon: Icons.edit,
                    color: Colors.red,
                    onTap: () => print('Delete success'),
                  ),
                ],
                child: ListTile(
                  key: Key(item.toString()),
                  title: Text(snapshot.data[index].name),
                  subtitle: Text(Todo.mapPriority(snapshot.data[index].priority)
                      .toString()),
                  onTap: () {
                    print(index.toString());
                    blocProvider.removeTodo(snapshot.data[index]);
                  },
                ),
              );
            },
          );
        }
      } else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Tasks',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        ),
        actions: <Widget>[
          // do some action hobb-ya
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: _onSelectAction,
            itemBuilder: (BuildContext cxt) {
              return _appbarActionList.map((action) {
                return PopupMenuItem<String>(
                  value: action,
                  child: Text(action),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          todosTab,
          InfoScreen(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add Task'),
        icon: Icon(Icons.add),
        elevation: 4,
        backgroundColor: Colors.indigo,
        //shape: ,
        onPressed: () {
          /* blocProvider.addTodo(
            Todo(
              name: 'fourth Todo',
              isComplete: true,
              priority: 1,
            ),
          ); */
          //blocProvider.removeAllTodos();

          Navigator.of(context).pushNamed('/new');
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.white,
        //shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        notchMargin: 4,
        child: TabBar(
          controller: _tabController,
          indicatorColor: Colors.transparent,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.home),
              text: 'Todos',
            ),
            Tab(
              icon: Icon(Icons.info),
              text: 'Info',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    blocProvider.dispose();
    _lvController.dispose();
    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();

    blocProvider = BlocProvider.instance;

    _lvController = ScrollController();

    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  // action list method

  void _onSelectAction(String action) {
    switch (action) {
      case 'CLEAR TODOS':
        showDialog(
            context: context,
            builder: (BuildContext cxt) {
              return RemoveAllTasksDialog();
            });
        break;

      default:
        break;
    }
  }
}
