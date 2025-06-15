import 'package:flutter/material.dart';
import '../widgets/slidable_session_card.dart';

class HomeScreen extends StatelessWidget {
    final String userName;
    const HomeScreen({Key? key, required this.userName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    
    List<String> pastSessions = [
        'Session on June 10',
        'Session on June 12',
        'Session on June 14',
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Hi, Name!")),
    //   body: ListView.builder(
    //     itemCount: pastSessions.length,
    //     itemBuilder: (context, index) {
    //       return ListTile(
    //         title: Text(pastSessions[index]),
    //       );
    //     },
    //   ),
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
