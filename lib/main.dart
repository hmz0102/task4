import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statemangement/functions/methods.dart';
import 'package:statemangement/pages/homepage.dart';
import 'package:statemangement/themes/theme.dart';

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
            home: const Homepage(),
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
          );
        },
      ),
    );
  }
}
