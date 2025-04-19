import 'package:flutter/material.dart';

class TripHistory extends StatefulWidget {
  @override
  _TripHistoryState createState() => _TripHistoryState();
}

class _TripHistoryState extends State<TripHistory> {
  // Example data - should be filtered to trips for the logged-in driver
  List<Map<String, dynamic>> trips = [
    {
      'name': 'Morning Trip - Route A',
      'date': '2025-04-10',
      'type': 'Morning',
      'destination': 'City Center',
      'driver': 'Ahmed Zaki', // should match logged-in driver
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
      'driver': 'Ahmed Zaki', // again, match this in real case
      'bus': 'Bus 3',
      'students': [
        {'name': 'Lina Nasser', 'payment': true},
        {'name': 'Rami Said', 'payment': false},
      ],
    },
  ];

  void _savePaymentStatus() {
    // Here you'd call your backend or local DB
    print("Payment statuses saved:");
    for (var trip in trips) {
      for (var student in trip['students']) {
        print("${student['name']}: ${student['payment'] ? 'Paid' : 'Unpaid'}");
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment statuses saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
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
                  ListTile(title: Text("Bus: ${trip['bus']}")),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text("Students (toggle payment):",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ...trip['students'].asMap().entries.map((entry) {
                    int studentIndex = entry.key;
                    var student = entry.value;
                    return SwitchListTile(
                      title: Text(student['name']),
                      subtitle: Text(student['payment'] ? 'Payment Received' : 'Pending Payment'),
                      value: student['payment'],
                      onChanged: (val) {
                        setState(() {
                          trips[index]['students'][studentIndex]['payment'] = val;
                        });
                      },  activeColor: Colors.white ,           // Dark green thumb
                      activeTrackColor: Colors.green ,      // Softer dark green track
                      inactiveThumbColor: Colors.white,         // Thumb when OFF
                      inactiveTrackColor: Colors.grey.shade400,
                      secondary: Icon(
                        student['payment'] ? Icons.check_circle : Icons.cancel,
                        color: student['payment'] ? Colors.green : Colors.red,
                      ),
                    );
                  }).toList(),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: ElevatedButton.icon(
            onPressed: _savePaymentStatus,
            icon: Icon(Icons.save),
            label: Text("Save Payment Status"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF121435),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14),
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ),
      ],
    );
  }
}
