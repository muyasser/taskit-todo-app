import 'package:complete_todo_app/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../app_state/bloc_provider.dart';
import '../models/todo_model.dart';
import '../widgets/remove_all_tasks_dialog.dart';
import 'info_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../app_state/theme_provider.dart';

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

  ThemeData theme;

  var todosTab = StreamBuilder<List<Todo>>(
    stream: BlocProvider.todoListStream,
    builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data.length == 0) {
          /* return Center(
            child: Text('No todos yet'),
          ); */

          return Center(
            child: Image.asset(
              'assets/empty.png',
              fit: BoxFit.contain,
              color: Colors.grey.shade400,
              colorBlendMode: BlendMode.modulate,
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
                //color: Colors.indigo[100],
                ),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/add.png',
                      fit: BoxFit.scaleDown,
                      color: Colors.grey,
                      colorBlendMode: BlendMode.modulate,
                    ),
                  ),
                ),
                ListView.builder(
                  controller: _lvController,
                  itemCount: snapshot.data.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final item = snapshot.data[index];
                    return Slidable(
                      closeOnScroll: true,
                      actionPane: SlidableStrechActionPane(),
                      actionExtentRatio: 0.2,
                      actions: <Widget>[
                        IconSlideAction(
                          color: Colors.transparent,
                          foregroundColor:
                              Theme.of(context).accentTextTheme.button.color,
                          caption: snapshot.data[index].isComplete == true
                              ? 'Pending'
                              : 'Done',
                          icon: snapshot.data[index].isComplete == true
                              ? Icons.timelapse
                              : Icons.done_outline,
                          onTap: () => blocProvider
                              .updateTodoStatus(snapshot.data[index]),
                        ),
                      ],
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          closeOnTap: true,
                          caption: 'Edit',
                          icon: Icons.edit,
                          color: Colors.transparent,
                          foregroundColor:
                              Theme.of(context).accentTextTheme.button.color,
                          onTap: () {
                            print('Edite success');

                            Navigator.of(context).pushNamed('/new',
                                arguments: snapshot.data[index]);
                          },
                        ),
                        IconSlideAction(
                            color: Colors.transparent,
                            foregroundColor:
                                Theme.of(context).accentTextTheme.button.color,
                            caption: 'Delete',
                            icon: Icons.delete,
                            //color: Colors.red,
                            onTap: () =>
                                blocProvider.removeTodo(snapshot.data[index])),
                      ],
                      child: ListTile(
                        key: Key(item.toString()),
                        title: Text(
                          snapshot.data[index].name,
                          style: TextStyle(
                            decoration: snapshot.data[index].isComplete == true
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationThickness: 1.4,
                          ),
                        ),
                        trailing: snapshot.data[index].isComplete == true
                            ? Icon(Icons.done)
                            : SizedBox(),
                        subtitle: Text(
                            Todo.mapPriority(snapshot.data[index].priority)
                                .toString()),
                        onTap: () {
                          print(index.toString());
                          //blocProvider.removeTodo(snapshot.data[index]);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actionsIconTheme: Theme.of(context).appBarTheme.actionsIconTheme,
        backgroundColor: Theme.of(context).appBarTheme.color,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Tasks',
          style: Theme.of(context).textTheme.title,
        ),
        actions: <Widget>[
          // do some action hobb-ya
          IconButton(
            icon: Icon(Icons.brightness_4),
            onPressed: ThemeProvider.toggleTheme,
          ),
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
        label: Text(
          'Add Task',
          style: Theme.of(context).textTheme.button,
        ),

        icon: Icon(
          Icons.add,
          color: Theme.of(context).iconTheme.color,
        ),

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
        color: Theme.of(context).bottomAppBarColor,
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
              icon: Icon(FontAwesomeIcons.calculator),
              text: 'Math',
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
