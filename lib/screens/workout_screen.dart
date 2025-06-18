import 'package:flutter/material.dart';
import '../services/api_service.dart';

class WorkoutScreen extends StatefulWidget {
@override
_WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
    final PageController _controller = PageController();
    final List<Map<String, dynamic>> exercises = [
        {'name': 'Squats', 'id': 1},
        {'name': 'Push-ups', 'id': 2},
        {'name': 'Pull-ups', 'id': 3},
    ];

    int? _currentSessionId;
    int? _currentExerciseId;
    int? _currentSessionExerciseId;

    double? meanHr;
    double? meanBr;

    @override
    void initState()
    {
    super.initState();
    //TODO: obtain the current sessionid from a global state or pass it from homescreen
    _currentSessionId = 1; //for testing purposes
    }

    Future<void> _startAndNavigateToExercise(String exerciseName, int exerciseId, int sets, int reps) async
    {
        if (_currentSessionId == null)
            {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No active session. Please start a session first')),
                );
                return;
            }
        final int? newSessionExerciseId = await ApiService.startExerciseSession(
            _currentSessionId!,
            exerciseId,
        );

    if (newSessionExerciseId == null)
        {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to start exercise session on backend.')),
            );
            return;
        }

    setState(()
    {
        _currentSessionExerciseId = newSessionExerciseId;
        _currentExerciseId = exerciseId;
    });

    final result = await Navigator.pushNamed(
        context,
        '/exercise',
        arguments:
        {
            'exerciseName': exerciseName,
            'sets': sets,
            'reps': reps, 
            'sessionExerciseId': newSessionExerciseId,
        },
    );

    if (result != null && result is Map<String, dynamic>)
    {
        setState(()
        {
            meanHr = result['meanHr'];
            meanBr = result['meanBr'];
        });
    }
    }

    Future<void> _submitMetricsAndFinish() async
    {
        if (_currentSessionExerciseId == null || meanHr == null || meanBr == null)
        {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Metrics not available yet.')),
            );
            return;
        }

        bool success = await ApiService.setMetrics(
            _currentExerciseId!, 
            meanHr!, 
            meanBr!
        );

        if (!success)
        {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to submit metrics')),
            );
        }
        else
        {
            await showMetrics(_currentSessionExerciseId!);
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
    }

    Future<void>showMetrics (int sessionExerciseId) async
    {
        final metrics = await ApiService.fetchSessionExercisesummary(sessionExerciseId);
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                title: Text('Session Metrics'),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: metrics.map((m) => Text('${m.metricName}: ${m.value}')).toList(),
                ),
                actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK.'),
                    ),
                ],
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text('Workout')),
            body: Column(
                children: [
                    Expanded(
                        child: PageView.builder(
                            controller: _controller,
                            itemCount: exercises.length,
                            itemBuilder: (ctx, i) {
                                final exercise = exercises[i];
                                return Center(
                                    child: Card(
                                        margin: EdgeInsets.all(24),
                                        child: ListTile(
                                            title: Text(exercise['name']!),
                                            trailing: Icon(Icons.arrow_forward),
                                            onTap: () => _startAndNavigateToExercise(
                                                exercise['name']!,
                                                exercise['id']!,
                                                3, //example sets
                                                12, //example reps
                                            ),
                                        ),
                                    ),
                                );
                                },
                            ),
                            ),
                            Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                                onPressed: _submitMetricsAndFinish,
                                child: Text('Finish Session'),
                            ),
                        ),
                    ],
                ),
            );
    }
    
  }
