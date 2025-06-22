// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rehab_app2/main.dart';
import 'package:rehab_app2/models/set_model.dart';
import 'package:rehab_app2/screens/form.page.dart';
import 'package:rehab_app2/screens/set_summary.dart';
import '../services/api_service.dart';

class WorkoutScreen extends StatefulWidget {

  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> with RouteAware {

  List<SetInfo> pastExercises = [];

  late int _currentSessionId;

  double? meanHr;
  double? meanBr;

  @override
  void initState() {
    super.initState();
    _createSession();
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

  void _createSession() async {
    try {
      final fetched = await ApiService.createNewSession("1");
      setState(() {
        _currentSessionId = fetched!;
      });

      _loadSetsFromSession();

    } catch (e) {
      print('Failed to load session: $e');
    }
  }

  void _loadSetsFromSession() async
    {
        try
        {
          final sets = await ApiService.fetchSets(_currentSessionId);
          setState(() {
            pastExercises = sets;
          });
        }
        catch (e)
        {
          print('Failed to load sets: $e');
        }
    }

  Future<void> _finishSession() async {

    await ApiService.finishSession(_currentSessionId);

    if (!mounted) return;

    //Go to home
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
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
        title: Text('Workout session'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...pastExercises.map((set) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SetSummaryScreen(setId: set.id, exerciseName: set.exercise,)),
                  );
                },
                child: Card(
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
                )
              );
            }),
            
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormPage(sessionId: _currentSessionId)),
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "New exercise",
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
