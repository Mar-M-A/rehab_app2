// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rehab_app2/models/point_model.dart';
import 'package:rehab_app2/services/api_service.dart';
import 'package:rehab_app2/widgets/point_graph.dart';

class RunningScreen extends StatefulWidget {
  final int setId;
  final int exerciseId;
  final int repetitions;

  const RunningScreen({
    super.key,
    required this.setId,
    required this.exerciseId,
    required this.repetitions
  });

  @override
  State<RunningScreen> createState() => _RunningScreenState();
}

class _RunningScreenState extends State<RunningScreen> {

  List<PointInfo> completeness = [];
  double lastTimestamp = 0;

  static const int keepPoints = 50;

  int currentReps = 0;
  double upperLimit = 70.0;
  double lowerLimit = 20.0;
  bool expectsUpper = true;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _initializeExercise();
    _pointUpdate();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _pointUpdate() {
    _timer = Timer.periodic(Duration(milliseconds: 200), (timer) async {
      try {
        final newPoints = await ApiService.fetchLiveReps(widget.setId, lastTimestamp);

        if (newPoints.isNotEmpty) {
          setState(() {
            // Append new points
            completeness.addAll(newPoints);

            // Keep only the last `keepPoints` elements
            if (completeness.length > keepPoints) {
              completeness = completeness.sublist(completeness.length - keepPoints);
            } else if (completeness.isNotEmpty && completeness.length < keepPoints) {
              //Padding
              final missing = keepPoints - completeness.length;
              final double startTs = completeness.first.x;
              final double step = 0.1;

              final List<PointInfo> padding = List.generate(missing, (i) {
                return PointInfo(
                  x: startTs - step * (missing - i),
                  y: 0,
                );
              });

              completeness = [...padding, ...completeness];
            }

            // Update last timestamp
            lastTimestamp = newPoints.last.x;

            //Check repetitions
            for (int i = 0; i < newPoints.length; i++) {
              final point = newPoints[i];

              if (expectsUpper) {
                if (point.y > upperLimit) {
                  expectsUpper = false;
                }
              } else {
                if (point.y < lowerLimit) {
                  currentReps += 1;
                  expectsUpper = true;
                }
              }
            }
          });

          if (currentReps >= widget.repetitions) {
            // Auto finish
            _finishExercise();
          }
        }
      } catch (e) {
        print('Error fetching points: $e');
      }
    });
  }

  void _initializeExercise() async {
    try {
      await ApiService.setExercise(1, widget.setId, widget.exerciseId);
    } catch (e) {
      print('Failed to init exercises: $e');
    }
  }

  void _finishExercise() async {
    //Send stop signal (for sensors)
    await ApiService.setExercise(1, widget.setId, -1);
    await ApiService.setMetrics(widget.setId);
    if (mounted) {
      Navigator.popUntil(context, ModalRoute.withName('/workout'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Exercise in progress...',
                      style: Theme.of(context).textTheme.headlineMedium),
                  Text(
                    "Reps: $currentReps",
                    style: TextStyle(fontSize: 18, color: Colors.blue.shade800),
                  ),
                ]
              ),
              SizedBox(height: 16),
              PointGraph(
                points: completeness,
                color: expectsUpper ? Colors.indigo.shade900 : Colors.red.shade800,
                maxY: 100,
                minY: 0,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _finishExercise,
                child: Text('Finish exercise'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
