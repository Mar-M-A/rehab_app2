import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableSessionCard extends StatelessWidget {
  final String title;

  const SlidableSessionCard({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(), 
        children: [
          SlidableAction(
            onPressed: (context) {
              // TODO: Delete action
            },
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          title: Text(title),
          subtitle: Text('Tap to view details'),
        ),
      ),
    );
  }
}
