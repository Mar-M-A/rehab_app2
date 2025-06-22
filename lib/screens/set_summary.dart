// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rehab_app2/models/point_model.dart';
import 'package:rehab_app2/widgets/point_graph.dart';
import '../services/api_service.dart';

class SetSummaryScreen extends StatefulWidget {

  final int setId;
  final String exerciseName;
  
  const SetSummaryScreen({
    super.key,
    required this.setId,
    required this.exerciseName
  });

  @override
  State<SetSummaryScreen> createState() => _SetSummaryScreenState();
}

class _SetSummaryScreenState extends State<SetSummaryScreen> {

  List<PointInfo> repetitions = [];
  List<PointInfo> instability = [];
  List<PointInfo> heartRate = [];
  List<PointInfo> breathRate = [];

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  void _loadPoints() async {
    try {
      final lists = await ApiService.fetchSetSummary(widget.setId);
      setState(() {
        repetitions = lists[0];
        instability = lists[1];
        heartRate = lists[2];
        breathRate = lists[3];
      });
    } catch (e) {
      print('Error fetching points: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exercise metrics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.exerciseName,
                    style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 16),
            PointGraph(
              points: repetitions, 
              title: 'Repetitions',
              color: Colors.black,
              maxY: 100,
              minY: 0,
            ),
            PointGraph(
              points: instability, 
              title: 'Instability',
              color: Colors.orange.shade900,
              minY: 0,
            ),
            PointGraph(
              points: heartRate, 
              title: 'Heart rate',
              color: Colors.red.shade400,
            ),
            PointGraph(
              points: breathRate, 
              title: 'Breath rate',
            ),
        ],)
      ),
    );
  }
}