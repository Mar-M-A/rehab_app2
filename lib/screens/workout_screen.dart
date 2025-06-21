import 'package:flutter/material.dart';
import 'package:rehab_app2/models/exercise_model.dart';
import 'package:rehab_app2/screens/form.page.dart';
import '../services/api_service.dart';

class WorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final PageController _controller = PageController();

  late int _currentSessionId;

  double? meanHr;
  double? meanBr;

  @override
  void initState() {
    super.initState();
    _createSession();
  }

  void _createSession() async {
    try {
      final fetched = await ApiService.createNewSession("1");
      setState(() {
        _currentSessionId = fetched!;
      });
    } catch (e) {
      print('Failed to load session: $e');
    }
  }

  // Future<void> _startAndNavigateToExercise(
  //   String exerciseName,
  //   int exerciseId,
  //   int sets,
  //   int reps,
  // ) async {
  //   if (_currentSessionId == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('No active session. Please start a session first'),
  //       ),
  //     );
  //     return;
  //   }
  //   final int? newSessionExerciseId = await ApiService.startExerciseSet(
  //     _currentSessionId!,
  //     exerciseId,
  //   );

  //   if (newSessionExerciseId == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to start exercise session on backend.')),
  //     );
  //     return;
  //   }

  //   setState(() {
  //     _currentSessionExerciseId = newSessionExerciseId;
  //     _currentExerciseId = exerciseId;
  //   });

  //   final result = await Navigator.pushNamed(
  //     context,
  //     '/exercise',
  //     arguments: {
  //       'exerciseName': exerciseName,
  //       'sets': sets,
  //       'reps': reps,
  //       'sessionExerciseId': newSessionExerciseId,
  //     },
  //   );

  //   if (result != null && result is Map<String, dynamic>) {
  //     setState(() {
  //       meanHr = result['meanHr'];
  //       meanBr = result['meanBr'];
  //     });
  //   }
  // }

  Future<void> _finishSession() async {

    //TODO change time in db?

    Navigator.pop(context); //Go to previous screen
  }

  // Future<void> showMetrics(int sessionExerciseId) async {
  //   final metrics = await ApiService.fetchSessionExercisesummary(
  //     sessionExerciseId,
  //   );
  //   showDialog(
  //     context: context,
  //     builder:
  //         (_) => AlertDialog(
  //           title: Text('Session Metrics'),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children:
  //                 metrics
  //                     .map((m) => Text('${m.metricName}: ${m.value}'))
  //                     .toList(),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: Text('OK.'),
  //             ),
  //           ],
  //         ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout session'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //TODO display previous exercises from set (summary)
            //TODO button start new exercise (go to form)
            //TODO keep "finish session"
            
            // ...exercises.map((exercise) {
            //   return Center(
            //     child: Card(
            //       margin: EdgeInsets.all(8),
            //       child: ListTile(
            //         title: Text(exercise.description),
            //         trailing: Icon(Icons.arrow_forward),
            //         onTap: //TODO go to form
            //             () => _startAndNavigateToExercise(
            //               exercise.description,
            //               exercise.id,
            //               3, //example sets
            //               12, //example reps
            //             ),
            //       ),
            //     ),
            //   );
            // }),

            GestureDetector(
              onTap: () {
                  print('Tapped!');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormPage(session_id: _currentSessionId)),
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Anar al form",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _finishSession,
                child: Text('Finish Session'),
              ),
            ),
          ],
        ),
      )
    );
  }
}
