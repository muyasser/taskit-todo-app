import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../app_state/bloc_provider.dart';
import '../models/todo_model.dart';

enum _priorities { Basic, Important, Critical }

enum _mode { Create, Edit }

class AddTaskScreen extends StatefulWidget {
  final Todo todo;

  AddTaskScreen({this.todo});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  _mode currentMode;

  TextEditingController _titleController;
  _priorities groupValue;

  String submitButtonName;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  BlocProvider blocProvider;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      initEdit();
    } else {
      initCreate();
    }
    blocProvider = BlocProvider.instance;
  }

  @override
  void dispose() {
    super.dispose();

    _titleController.dispose();
    //blocProvider.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // title field
    var titleField = Container(
      child: TextFormField(
        controller: _titleController,
        validator: _validateTitle,
        onSaved: _saveTaskInfo,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            color: Colors.grey,
            icon: Icon(
              Icons.clear,
            ),
            onPressed: () {
              _titleController.clear();
            },
          ),
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
          child: Text(submitButtonName),
          color: Colors.indigo,
          textColor: Colors.white,
          onPressed: currentMode == _mode.Create ? _createTask : _updateTodo,
        ),
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'Add Task',
          style: Theme.of(context).textTheme.title,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(60),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/home.png',
                fit: BoxFit.cover,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey
                    : Colors.transparent,
                colorBlendMode: Theme.of(context).brightness == Brightness.dark
                    ? BlendMode.modulate
                    : BlendMode.dst,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      titleField,
                      radioButtons,
                      buttons,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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

  void _createTask() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      navigateToHomeScreen();
    }
  }

  // update tas info method
  void _updateTaskInfo() {
    var data = {
      'id': widget.todo.id,
      'name': _titleController.text,
      'status': Todo.mapStatus(widget.todo.isComplete),
      'priority': mapPriorityToInt(groupValue)
    };

    blocProvider.updateTodo(data);
  }

  void _updateTodo() {
    if (_formKey.currentState.validate()) {
      _updateTaskInfo();
      navigateToHomeScreen();
    }
  }

  void navigateToHomeScreen() {
    print('go to home');
    Navigator.of(context).pop();
  }

  void initEdit() {
    currentMode = _mode.Edit;
    groupValue = widget.todo.priority == 0
        ? _priorities.Basic
        : widget.todo.priority == 1
            ? _priorities.Important
            : _priorities.Critical;
    _titleController = TextEditingController(text: widget.todo.name);
    submitButtonName = 'UPDATE';
  }

  void initCreate() {
    currentMode = _mode.Create;
    groupValue = _priorities.Basic;
    _titleController = TextEditingController();
    submitButtonName = 'CREATE';
  }
}
