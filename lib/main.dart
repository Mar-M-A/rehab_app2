import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/workout_screen.dart';

void main() async  {

  runApp(RApp());
}

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class RApp extends StatelessWidget {
  const RApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RApp',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => WelcomeScreen(),
        '/home': (_) => HomeScreen(userName: 'John'),
        '/workout': (_) => WorkoutScreen(),
      },
      navigatorObservers: [routeObserver],
    );
  }
}
