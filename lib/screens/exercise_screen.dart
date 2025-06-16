import 'package:flutter/material.dart';
import '../models/metrics_model.dart';
import '../services/api_service.dart';

class ExerciseScreen extends StatefulWidget {
  final String exerciseName;
  final int sets;
  final int reps;

  const ExerciseScreen({
    required this.exerciseName,
    required this.sets,
    required this.reps,
  });

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}


class _ExerciseScreenState extends State<ExerciseScreen>
{
    late Future<List<Metrics>> _metrics;
    @override
    void initState()
    {
        super.initState();
        _metrics = ApoService.fetchMetrics(widget.exerciseName);
    }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exerciseName)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Goal', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            Text('${widget.sets} sets × ${widget.reps} reps'),
            SizedBox(height: 24),
            // TODO: Integrate pulse oximeter data stream here
            // TODO: Integrate Kinnect posture data stream here
            FutureBuilder<List<Metrics>>(
                future: _metrics,
                builder: (context, snapshot){
                    if (snapshot.connectionState == ConnectionSttate.waiting)
                        return Center(child: CircularProgressIndicator());
                    if (snapshot.hasError)
                        return Center(child: Text('Error: ${snapshot.error}'));
                    if (!snapshot.hasData || snapshot.data!.isEmpty)
                        return Center(child: Text('No metrics available'));
                    
                    final metrics = snapshot.data!;
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: metrics.map((metric) {
                            return Text(
                                '{$metric.metricName}: ${metric.value}',
                                style: Theme.of(context).textTheme.bodyMedium,
                            );
                        }).toList(),
                    );
                },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Mark as complete and return to workout or home
                Navigator.pushNamed(context, '/workout');
              },
              child: Text('Mark Complete'),
            ),
          ],
        ),
      ),
    );
  }
}
