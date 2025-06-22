// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rehab_app2/main.dart';
import 'package:rehab_app2/models/set_model.dart';
import '../services/api_service.dart';

class PastSessionScreen extends StatefulWidget {

  final int sessionId;
  
  const PastSessionScreen({
    super.key,
    required this.sessionId
  });

  @override
  State<PastSessionScreen> createState() => _PastSessionScreenState();
}

class _PastSessionScreenState extends State<PastSessionScreen> with RouteAware {

  List<SetInfo> pastExercises = [];

  double? meanHr;
  double? meanBr;

  @override
  void initState() {
    super.initState();
    _loadSetsFromSession();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _loadSetsFromSession();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _loadSetsFromSession() async
  {
      try
      {
        final sets = await ApiService.fetchSets(widget.sessionId);
        setState(() {
          pastExercises = sets;
        });
      }
      catch (e)
      {
        print('Failed to load sets: $e');
      }
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session ${widget.sessionId}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...pastExercises.map((set) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            set.exercise,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                          ),
                          Text(
                            "Duration: ${set.duration.toStringAsFixed(1)} s",
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStat("Breath", "${set.mBreathRate.toStringAsFixed(1)} bpm"),
                          _buildStat("Heart", "${set.mHeartRate.toStringAsFixed(1)} bpm"),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStat("Reps", "${set.reps}"),
                          _buildStat("Weight", "${set.weight} kg"),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed:() {
                  Navigator.pop(context);
                },
                child: Text('Go back'),
              ),
            ),
          ],
        ),
      )
    );
  }
}
