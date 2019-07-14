import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'routing/router.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        tabBarTheme: TabBarTheme(
          labelColor: Colors.indigoAccent,
          unselectedLabelColor: Colors.black,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.indigo.shade400,
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: Router.generateRoute,
      home: HomeScreen(),
    );
  }
}
