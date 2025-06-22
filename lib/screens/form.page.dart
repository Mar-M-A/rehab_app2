// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rehab_app2/models/exercise_model.dart';
import 'package:rehab_app2/screens/running_screen.dart';
import '../services/api_service.dart';

class FormPage extends StatefulWidget {
  
  final int sessionId;
  
  const FormPage({
    super.key,
    required this.sessionId
  });

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  List<Exercise> exercises = [];
  
  int exerciseId = -1;
  double weight = 0;
  int reps = 1;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  void _loadExercises() async {
    try {
      final fetched = await ApiService.fetchExercises();
      setState(() {
        exercises = fetched;
      });
    } catch (e) {
      print('Failed to load exercises: $e');
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exercise settings")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Choose an exercise',
                  border: OutlineInputBorder(),
                ),
                items: exercises.map((exercise) {
                  return DropdownMenuItem<int>(
                    value: exercise.id,
                    child: Text(exercise.description),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    exerciseId = value!;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Weight',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      width: 140,
                      height: 40,
                      alignment: Alignment.center,
                      child: TextFormField(
                        initialValue: weight.toString(),
                        decoration: InputDecoration(
                          hintText: 'Enter text',
                          border: InputBorder.none, // removes underline
                          enabledBorder:
                              InputBorder.none, // removes when not focused
                          focusedBorder:
                              InputBorder.none, // removes when focused
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (val) {
                          setState(() {
                            if(val.isNotEmpty){
                              weight = double.parse(val);
                            }
                            
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Repetitions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      width: 140,
                      height: 40,
                      alignment: Alignment.center,
                      child: TextFormField(
                        initialValue: reps.toString(),
                        decoration: InputDecoration(
                          hintText: 'Enter text',
                          border: InputBorder.none, // removes underline
                          enabledBorder:
                              InputBorder.none, // removes when not focused
                          focusedBorder:
                              InputBorder.none, // removes when focused
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (val) {
                          setState(() {
                            if(val.isNotEmpty){
                              reps = int.parse(val);
                            }
                            
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            if (exerciseId > 0 && reps > 0) GestureDetector(
              onTap: () async {
                final fetched = await ApiService.startExerciseSet(widget.sessionId, exerciseId, reps, weight);
                
                if (fetched! >= 0)
                {
                  if (context.mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RunningScreen(setId: fetched, exerciseId: exerciseId, repetitions: reps,)),
                    );
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.all(10),
                width: 180,
                height: 40,

                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("Start exercise", style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
