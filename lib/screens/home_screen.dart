// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rehab_app2/main.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
    final String userName;
    const HomeScreen({super.key, required this.userName});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware
{
    List<String> pastSessions = [];

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
            setState(()
            {
                pastSessions = sessions.map((s) => 'Session ${s['id']} (${s["start_time"]})').toList();
            });
        }
        catch (e)
        {
            print('Failed to load sessions: $e');
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
                        ...pastSessions.map((session) => Card(
                            child: ListTile( //TODO make buttons, new screen with info (like workout but without adding new sets)
                                title: Text(session)
                            ),
                        )),
                        
                        
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

