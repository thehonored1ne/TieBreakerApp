import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/decision_service.dart';
import 'screens/home_screen.dart';


void main() => runApp(const TiebreakerApp());

class TiebreakerApp extends StatelessWidget {
  const TiebreakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DecisionService()),
        ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TieBreaker',
        theme: ThemeData(colorSchemeSeed: Colors.deepPurple),
        home: const HomeScreen(),
      ),
    );
  }
}