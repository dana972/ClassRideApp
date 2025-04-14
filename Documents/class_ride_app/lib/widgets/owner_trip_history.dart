import 'package:flutter/material.dart';

class TripHistory extends StatelessWidget {
  final List<Map<String, dynamic>> trips = [
    {
      'name': 'Morning Trip - Route A',
      'date': '2025-04-10',
      'type': 'Morning',
      'destination': 'City Center',
      'driver': 'Ahmed Zaki',
      'bus': 'Bus 1',
      'students': [
        {'name': 'Sarah Ali', 'payment': true},
        {'name': 'Omar Kamel', 'payment': false},
      ],
    },
    {
      'name': 'Return Trip - Route B',
      'date': '2025-04-09',
      'type': 'Return',
      'destination': 'University District',
      'driver': 'Fatima El-Sayed',
      'bus': 'Bus 3',
      'students': [
        {'name': 'Lina Nasser', 'payment': true},
        {'name': 'Rami Said', 'payment': true},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return ExpansionTile(
          title: Text(
            trip['name'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Date: ${trip['date']}"),
          children: [
            ListTile(title: Text("Type: ${trip['type']}")),
            ListTile(title: Text("Destination: ${trip['destination']}")),
            ListTile(title: Text("Driver: ${trip['driver']}")),
            ListTile(title: Text("Bus: ${trip['bus']}")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text("Students:", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ...trip['students'].map<Widget>((student) {
              return ListTile(
                leading: Icon(
                  student['payment'] ? Icons.check_circle : Icons.cancel,
                  color: student['payment'] ? Colors.green : Colors.red,
                ),
                title: Text(student['name']),
                subtitle: Text(student['payment'] ? 'Payment Received' : 'Payment Pending'),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}
