import 'package:flutter/material.dart';
import '../app_state/bloc_provider.dart';

const _textStyle = TextStyle(
  fontSize: 20,
  //color: Colors.indigo,
);

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  static BlocProvider blocProvider;

  @override
  void initState() {
    super.initState();
    blocProvider = BlocProvider.instance;
  }

  static int allTasks = 0;
  static int tasksDone = 0;

  Widget buildBody() {
    return StreamBuilder<Map<String, int>>(
        initialData: {'allTodos': 0, 'doneTodos': 0},
        stream: BlocProvider.statsStream,
        builder: (context, snapshot) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Text(
                    '#Some math#',
                    style: TextStyle(
                        fontSize: 18, color: Theme.of(context).accentColor),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'All tasks',
                      style: _textStyle,
                    ),
                    Text(
                      snapshot.data['allTodos'].toString(),
                      style: TextStyle(
                          fontSize: 22, color: Theme.of(context).accentColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Done tasks',
                      style: _textStyle,
                    ),
                    Text(
                      snapshot.data['doneTodos'].toString(),
                      style: TextStyle(
                          fontSize: 22, color: Theme.of(context).accentColor),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  height: 2,
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Left todos',
                      style: _textStyle,
                    ),
                    Text(
                      "${snapshot.data['allTodos'] - snapshot.data['doneTodos']}",
                      style: TextStyle(
                          fontSize: 22, color: Theme.of(context).accentColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Text(
                    (snapshot.data['doneTodos'] / snapshot.data['allTodos'])
                                    .isNaN ==
                                true ||
                            (snapshot.data['doneTodos'] /
                                        snapshot.data['allTodos'])
                                    .isInfinite ==
                                true
                        ? ''
                        : "Success: ${(snapshot.data['doneTodos'] / snapshot.data['allTodos'] * 100).truncate()}%",
                    style: TextStyle(
                      fontSize: _textStyle.fontSize,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Center(
                  child: (snapshot.data['doneTodos'] /
                              snapshot.data['allTodos'] *
                              100) ==
                          100
                      ? Icon(
                          Icons.done_all,
                          size: 50,
                          color: Colors.indigoAccent,
                        )
                      : SizedBox(),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return buildBody();
  }
}
