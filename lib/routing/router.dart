import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/add_task_screen.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
        break;
      case '/new':
        return MaterialPageRoute(
            builder: (_) => AddTaskScreen(
                  todo: args,
                ));
        break;

      default:
        return _errorRoute();
        break;
    }
  }

  // error route method

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
