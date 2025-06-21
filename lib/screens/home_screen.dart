import 'package:flutter/material.dart';
import '../widgets/slidable_session_card.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
    final String userName;
    const HomeScreen({Key? key, required this.userName}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
    List<String> pastSessions = [];

    @override
    void initState()
    {
        super.initState();
        loadSessions();
    }

    void loadSessions() async
    {
        try
        {
            final sessions = await ApiService.getUserSessions("1");// Here goes the real user ID
            setState(()
            {
                pastSessions = sessions.map((s) => 'Session ID: ${s['id']}').toList();
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
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                        Text('Past Sessions', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 16),
                        ...pastSessions.map((session) => Card(
                            child: ListTile(
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
        );
    }
}

