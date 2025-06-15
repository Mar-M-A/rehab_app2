import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/workout_screen.dart';
import 'screens/exercise_screen.dart';

void main() {
  runApp(RApp());
}

class RApp extends StatelessWidget {
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
        '/exercise': (_) => ExerciseScreen(
              exerciseName: 'Squats',
              sets: 3,
              reps: 12,
            ),
      },
    );
  }
}
