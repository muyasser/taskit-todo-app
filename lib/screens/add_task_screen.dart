import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../app_state/bloc_provider.dart';
import '../models/todo_model.dart';

enum _priorities { Basic, Important, Critical }

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  _priorities groupValue = _priorities.Basic;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _titleController;
  BlocProvider blocProvider;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    blocProvider = BlocProvider.instance;
  }

  @override
  void dispose() {
    super.dispose();

    _titleController.dispose();
    //blocProvider.dispose();
  }

  final appBar = AppBar(
    title: Text('Add Task'),
    centerTitle: true,
    automaticallyImplyLeading: false,
  );

  @override
  Widget build(BuildContext context) {
    // title field
    var titleField = Container(
      child: TextFormField(
        controller: _titleController,
        validator: _validateTitle,
        onSaved: _saveTaskInfo,
        decoration: InputDecoration(
          labelText: 'Title',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );

    // priority field
    var radioButtons = Container(
      margin: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Radio(
                value: _priorities.Basic,
                groupValue: groupValue,
                onChanged: onchangeRadio,
              ),
              Text('Basic'),
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                value: _priorities.Important,
                groupValue: groupValue,
                onChanged: onchangeRadio,
              ),
              Text('Important'),
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                value: _priorities.Critical,
                groupValue: groupValue,
                onChanged: onchangeRadio,
              ),
              Text('Critical'),
            ],
          ),
        ],
      ),
    );

    // button s field
    final buttons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          child: Text('CANCEL'),
          textColor: Colors.black,
          onPressed: navigateToHomeScreen,
        ),
        RaisedButton(
          child: Text('CREATE'),
          color: Colors.indigo,
          textColor: Colors.white,
          onPressed: _submitTask,
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              titleField,
              radioButtons,
              buttons,
            ],
          ),
        ),
      ),
    );
  }

  void onchangeRadio(_priorities value) {
    setState(() {
      groupValue = value;
    });
  }

  // map priorty int an integer

  int mapPriorityToInt(_priorities p) {
    switch (p) {
      case _priorities.Important:
        return 1;
        break;
      case _priorities.Critical:
        return 2;
      default:
        return 0;
    }
  }

  // validate title method

  String _validateTitle(String inputValue) {
    if (inputValue.isNotEmpty) {
      if (inputValue.length > 30) {
        return 'Title is maximum 30 characters';
      }
      return null;
    } else {
      return 'Title shouldn\'t be empty';
    }
  }

  void _saveTaskInfo(String data) {
    blocProvider.addTodo(
      Todo(name: data, priority: mapPriorityToInt(groupValue)),
    );
  }

  void _submitTask() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      navigateToHomeScreen();
    }
  }

  void navigateToHomeScreen() {
    print('go to home');
    Navigator.of(context).pop();
  }

  void addTask() {}
}
