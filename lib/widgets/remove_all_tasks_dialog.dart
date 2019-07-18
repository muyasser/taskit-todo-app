import 'package:flutter/material.dart';
import '../app_state/bloc_provider.dart';

class RemoveAllTasksDialog extends StatelessWidget {
  final BlocProvider blocProvider = BlocProvider.instance;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('CONFIRM'),
          onPressed: () {
            blocProvider.removeAllTodos();
            Navigator.pop(context);
          },
        ),
      ],
      content: Text(
          'Are you sure you want to remove all your tasks? (there may be unfinished ones)'),
    );
  }
}
