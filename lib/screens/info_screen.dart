import 'package:flutter/material.dart';
import '../app_state/bloc_provider.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  BlocProvider blocProvider;

  @override
  void initState() {
    super.initState();
    blocProvider = BlocProvider.instance;
  }

  final _textStyle = TextStyle(fontSize: 40);

  static int allTasks = 0;
  static int tasksDone = 0;

  Future<int> calcStats() async {
    int length = await blocProvider.getTodosLength();

    allTasks = length;
  }

  var infoTab = Center(
    child: Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'TASKS DONE',
                style: TextStyle(fontSize: 40),
              ),
              Text(allTasks.toString()),
            ],
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return infoTab;
  }
}
