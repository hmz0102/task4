import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statemangement/functions/methods.dart';
import 'package:statemangement/pages/homepage.dart';

class Statemangement extends StatefulWidget {
  const Statemangement({super.key});

  @override
  State<Statemangement> createState() => _StatemangementState();
}

void main() {
  runApp(const Statemangement());
}

class _StatemangementState extends State<Statemangement> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => TodoProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Homepage(),
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              listTileTheme: ListTileThemeData(
                textColor: Color(0xFFADAEBC),
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                iconColor: Color(0xFF3B82F6),
              ),

              cardTheme: CardThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.white,
                elevation: 2,
              ),
              scaffoldBackgroundColor: Colors.grey[200],
              textTheme: TextTheme(
                bodyLarge: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.grey[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            darkTheme: ThemeData(
              listTileTheme: ListTileThemeData(
                textColor: Color(0xFFADAEBC),
                tileColor: Color(0xFF25273D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                iconColor: Colors.white,
              ),

              cardTheme: CardThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Color(0xFF25273D),
                elevation: 2,
              ),
              scaffoldBackgroundColor: Color(0xFF161622),
              textTheme: TextTheme(
                bodyLarge: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  void setTheme(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
  }

  void toggleTheme() {
    if (themeMode == ThemeMode.light) {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }
    notifyListeners();
  }
}
