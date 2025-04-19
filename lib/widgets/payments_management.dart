import 'package:flutter/material.dart';

class PaymentsManagement extends StatefulWidget {
  @override
  _PaymentsManagementState createState() => _PaymentsManagementState();
}

class _PaymentsManagementState extends State<PaymentsManagement> {
  final List<Map<String, dynamic>> unpaidStudents = [
    {
      'name': 'Sarah Ali',
      'trip': 'Morning Trip - Route A',
      'date': '2025-04-10',
      'paid': false
    },
    {
      'name': 'Omar Kamel',
      'trip': 'Return Trip - Route B',
      'date': '2025-04-09',
      'paid': false
    },
    {
      'name': 'Maya Tarek',
      'trip': 'Morning Trip - Route A',
      'date': '2025-04-10',
      'paid': true
    },
  ];

  final Set<int> modifiedIndexes = {};

  void _togglePaymentStatus(int index) {
    setState(() {
      unpaidStudents[index]['paid'] = !unpaidStudents[index]['paid'];
      modifiedIndexes.add(index);
    });
  }

  void _saveConfirmedPayments() {
    setState(() {
      unpaidStudents.removeWhere((student) => student['paid'] == true);
      modifiedIndexes.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Confirmed payments saved.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: unpaidStudents.length,
            itemBuilder: (context, index) {
              final student = unpaidStudents[index];
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(student['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Trip: ${student['trip']}"),
                      Text("Date: ${student['date']}"),
                    ],
                  ),
                  trailing:ElevatedButton(
                    onPressed: () => _togglePaymentStatus(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: student['paid'] ? Color(0xFF121435) : Colors.orange,
                    ),
                    child: Text(
                      student['paid'] ? 'Paid' : 'Confirm',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                ),
              );
            },
          ),
        ),
        if (unpaidStudents.any((s) => s['paid'] == true))
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _saveConfirmedPayments,
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF121435)),
              child: Text("Save Confirmed Payments"),
            ),
          ),
      ],
    );
  }
}
