import 'package:flutter/material.dart';
import '../models/metrics_model.dart';
import '../services/api_service.dart';
import 'dart:async';

class ExerciseScreen extends StatefulWidget {
  final String exerciseName;
  final int sets;
  final int reps;
  final int sessionExerciseId;

  const ExerciseScreen({
    required this.exerciseName,
    required this.sets,
    required this.reps,
    required this.sessionExerciseId,
  });

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}


class _ExerciseScreenState extends State<ExerciseScreen>
{
  int _hrCount = 0;
  int brCount = 0;
  double _currentMean_Hr = 0.0;
  double _currentMeanBr = 0.0;

  // stream controllers for sumulating sensor data
  late StreamController<double> _heartRateController;
  late StreamController<double> _breathRateController;
  Timer? _sensorTimer;

  @override
  void initState()
  {
    super.initState();
    
    _heartRateController = StreamController<double>();
    _breathRateController = StreamController<double>();

    _startSensorDataStream();
  }

  void _startSensorDataStream()
  {
    _sensorTimer = Timer.periodic(Duration(seconds: 1), (timer) async
    {
      final simulatedHr = 70.0 + (5 * (DateTime.now().second % 10 - 5)).toDouble(); // Randomize
      final simulatedBr = 15.0 + (2 * (DateTime.now().second % 5 - 2)).toDouble(); // Randomize

      _heartRateController.add(simulatedHr);
      _breathRateController.add(simulatedBr);

      // Accumulate for mean calculation
      _currentMeanHr = (_currentMeanHr * _hrCount + simulatedHr) / (_hrCount + 1);
      _hrCount++;
      _currentMeanBr = (_currentMeanBr * _brCount + simulatedBr) / (_brCount + 1);
      _brCount++;

      // Send to backend (example for pox data)
      await ApiService.sendPox({
        "ts": DateTime.now().toIso8601String(),
        "session_exercise": widget.sessionExerciseId,
        "total_phase": 0.0, // Placeholder
        "breath_phase": 0.0, // Placeholder
        "heart_phase": 0.0, // Placeholder
        "breath_rate": simulatedBr,
        "heart_rate": simulatedHr,
        "distance": 0.0, // Placeholder
      });

      // TODO: Implement sending Kinect data similarly
    });
  }

  void _finishExercise()
  {
    _sensorTimer?.cancel();
    _heartRateController.close();
    _breathRateController.close();

    Navigator.pop(context,
    {
      'sessionExerciseId': widget.sessionExerciseId,
      'meanHr': _currentMeanHr,
      'meanBr': _currentMeanBr,
    });
  }
    @override
    void dispose()
    {
      _sensorTimer?.cancel();
      _heartRateController.close();
      _breathRateController.close();
      super.dispose();
    }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.exerciseName)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Goal', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            Text('${widget.sets} sets × ${widget.reps} reps'),
            SizedBox(height: 24),
            Text('Live Metrics:', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            StreamBuilder<double>(
              stream: _heartRateController.stream,
              builder: (context, snapshot)
              {
                id (snapshot.hasData)
                {
                  return Text('Heart Rate: ${snapshot.data!.toStringAsFixed(1)} bpm');
                }
                return Text('Heart Rate: N/A');
              },
            ),
            StreamBuilder<double>(
              stream: _breathRateController.stream,
              builder: (context, snapshot)
              {
                if (snapshot.hasData)
                {
                  return Text('Breath Rate: ${snapshot.data!.toStringAsFixed(1)} bpm');
                }
                return Text('Breath Rate: N/A');
              },
            ),
            SizedBox(height: 24),
            Text('Average Metrics for this session:', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            Text('Mean Heart Rate: ${_currentMeanHr.toStringAsFixed(1)} bpm'),
            Text('Mean Breath Rate: ${_currentMeanBr.toStringAsFixed(1)} bpm'),
            SizedBox(height: 24),
            // FutureBuilder<List<Metrics>>(
            //     future: _metrics,
            //     builder: (context, snapshot){
            //         if (snapshot.connectionState == ConnectionState.waiting)
            //             return Center(child: CircularProgressIndicator());
            //         if (snapshot.hasError)
            //             return Center(child: Text('Error: ${snapshot.error}'));
            //         if (!snapshot.hasData || snapshot.data!.isEmpty)
            //             return Center(child: Text('No metrics available'));
                    
            //         final metrics = snapshot.data!;
            //         return Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: metrics.map((metric) {
            //                 return Text(
            //                     '{$metric.metricName}: ${metric.value}',
            //                     style: Theme.of(context).textTheme.bodyMedium,
            //                 );
            //             }).toList(),
            //         );
            //     },
            // ),
            // SizedBox(height: 24),
            ElevatedButton(
              onPressed: _finishExercise,
              child: Text('Mark Complete'),
            ),
          ],
        ),
      ),
    );
  }
}
