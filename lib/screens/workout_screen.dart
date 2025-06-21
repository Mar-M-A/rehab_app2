// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rehab_app2/screens/form.page.dart';
import '../services/api_service.dart';

class WorkoutScreen extends StatefulWidget {

  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {

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

  Future<void> _finishSession() async {

    //TODO change time in db?

    Navigator.pop(context); //Go to previous screen
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
            //TODO display previous exercises from set (summary)
            //TODO button start new exercise (go to form)
            //TODO keep "finish session"
            
            GestureDetector(
              onTap: () {
                  print('Tapped!');
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
