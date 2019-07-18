import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'routing/router.dart';
import 'app_state/theme_provider.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeProvider themeProvider;

  @override
  void initState() {
    super.initState();
    themeProvider = ThemeProvider.instance;
  }

  @override
  void dispose() {
    super.dispose();
    ThemeProvider.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeData>(
        stream: themeProvider.themeStream,
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.indigo,
              ),
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: snapshot.data,
              initialRoute: '/',
              onGenerateRoute: Router.generateRoute,
              home: HomeScreen(),
            );
          }
        });
  }
}
