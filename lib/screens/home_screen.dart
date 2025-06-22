// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rehab_app2/main.dart';
import 'package:rehab_app2/models/session_model.dart';
import '../services/api_service.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
    final String userName;
    const HomeScreen({super.key, required this.userName});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware
{
    List<SessionInfo> pastSessions = [];

    @override
    void initState()
    {
        super.initState();
        loadSessions();
    }

    @override
    void didPopNext() {
      super.didPopNext();
      loadSessions();
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

    void loadSessions() async
    {
        try
        {
          final sessions = await ApiService.getUserSessions("1");// Here goes the real user ID
          setState(() {
            pastSessions = sessions.map<SessionInfo>((s) {
              return SessionInfo(
                id: s['id'],
                start: HttpDate.parse(s['start_time']),
                end: HttpDate.parse(s['end_time']),
              );
            }).toList();
          });
        }
        catch (e)
        {
          print('Failed to load sessions: $e');
        }
    }

    String _formatDuration(Duration duration) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      final seconds = duration.inSeconds.remainder(60);
      if (hours > 0) {
        return '${hours}h ${minutes}m';
      } else if (minutes > 0) {
        return '${minutes}m ${seconds}s';
      } else {
        return '${seconds}s';
      }
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(title: Text("Hi, ${widget.userName}!")),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                        Text('Past Sessions', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 16),
                        ...pastSessions.map((session) {
                          final durationStr = _formatDuration(session.duration);

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              title: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  children: [
                                    TextSpan(text: 'Session ', style: TextStyle(color: Colors.black)),
                                    TextSpan(text: '${session.id}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                                  ],
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(DateFormat('yyyy-MM-dd HH:mm').format(session.start)),
                                  Text('Duration: $durationStr', style: TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                              leading: Icon(Icons.schedule, color: Colors.blue),
                            ),
                          );
                        }),
                        
                        
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: (){
                                Navigator.pushNamed(context, '/workout');
                            },
                            child: Text('Start New Session'),
                        ),
                    ],
                ),
            ),
          )
        );
    }
}

