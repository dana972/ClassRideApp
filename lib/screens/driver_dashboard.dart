import 'package:flutter/material.dart';
import '../widgets/chats.dart';
import '../widgets/driver_trip_history.dart';
import '../widgets/driver_profile_management.dart';

class DriverDashboard extends StatefulWidget {
  @override
  _DriverDashboardState createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  String selectedPage = 'dashboard';

  void _selectPage(String page) {
    setState(() {
      selectedPage = page;
    });
    Navigator.pop(context);
  }

  Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF121435)),
      title: Text(label, style: TextStyle(fontSize: 16, color: Color(0xFF121435))),
      onTap: onTap,
    );
  }
  Widget _buildPageContent() {
    if (selectedPage == 'dashboard') {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DriverProfileManagement(),
            SizedBox(height: 24),
            Text("Today's Assigned Trips",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),

            // ✅ Constrain the ListView
            SizedBox(
              height: 600, // adjust based on screen size or use MediaQuery
              child: _buildTodayTrips(),
            )
          ],
        ),
      );
    }

    if (selectedPage == 'chats') {
      return ChatsPage();
    }

    if (selectedPage == 'trip_history') {
      return TripHistory();
    }

    return Center(child: Text("Page not found"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF9F0),
      appBar: AppBar(
        backgroundColor: Color(0xFF121435),
        title: Text("Driver Dashboard"),
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFFEDEBCA),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF121435)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.directions_bus, size: 40, color: Colors.white),
                  SizedBox(height: 8),
                  Text('Driver',
                      style: TextStyle(
                          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('driver@classride.com', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            _buildDrawerItem(Icons.dashboard, 'Dashboard', () => _selectPage('dashboard')),
            _buildDrawerItem(Icons.history, 'Trip History', () => _selectPage('trip_history')),
            _buildDrawerItem(Icons.chat, 'Chats', () => _selectPage('chats')),
            _buildDrawerItem(Icons.home, 'Back to Home', () {
              Navigator.popUntil(context, (route) => route.isFirst);
            }),
            Divider(),
            _buildDrawerItem(Icons.logout, 'Logout', () {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacementNamed(context, '/', arguments: 'logout');
            }),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _buildPageContent(),
      ),
    );
  }

  List<Map<String, dynamic>> todayTrips = [
    {
      'name': 'Morning Trip - Route A',
      'type': 'Morning',
      'date': DateTime.now().toIso8601String().split('T')[0],
      'destination': 'City Center',
      'bus': 'Bus 1',
      'students': [
        {
          'name': 'Sarah Ali',
          'phone': '01012345678',
          'location': '123 Main St',
          'university': 'LIU',
          'seat': '5A',
          'notes': 'Prefers front seat',
          'payment': true,
        },
        {
          'name': 'Omar Kamel',
          'phone': '01087654321',
          'location': '456 Elm St',
          'university': 'IUL',
          'seat': '7B',
          'notes': 'Late payer',
          'payment': false,
        },
      ]
    },
    {
      'name': 'Return Trip - Route B',
      'type': 'Return',
      'date': DateTime.now().toIso8601String().split('T')[0],
      'destination': 'University District',
      'bus': 'Bus 2',
      'students': [
        {
          'name': 'Lina Nasser',
          'phone': '01111222333',
          'location': '789 Garden Rd',
          'university': 'LIU',
          'seat': '4C',
          'notes': 'Allergic to perfume',
          'payment': true,
        },
        {
          'name': 'Rami Said',
          'phone': '01233445566',
          'location': '90 Palm Ave',
          'university': 'IUL',
          'seat': '8A',
          'notes': 'Needs extra time boarding',
          'payment': false,
        },
      ]
    },
  ];

  Widget _buildTodayTrips() {
    return ListView.builder(
      itemCount: todayTrips.length,
      itemBuilder: (context, index) {

        final trip = todayTrips[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 12),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trip['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text("Type: ${trip['type']}"),
                Text("Destination: ${trip['destination']}"),
                Text("Bus: ${trip['bus']}"),
                Text("Date: ${trip['date']}"),
                SizedBox(height: 12),
                Text("Students:", style: TextStyle(fontWeight: FontWeight.bold)),
                ...trip['students'].asMap().entries.map((entry) {
                  int studentIndex = entry.key;
                  var student = entry.value;
                  return ListTile(
                    title: GestureDetector(
                      onTap: () => _showStudentDetailsModal(context, student),
                      child: Text(student['name'],
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue.shade700)),
                    ),
                    trailing: Switch(
                      value: student['payment'],
                      onChanged: (val) {
                        setState(() {
                          todayTrips[index]['students'][studentIndex]['payment'] = val;
                        });
                      },
                      activeColor: Colors.white ,           // Dark green thumb
                      activeTrackColor: Colors.green ,      // Softer dark green track
                      inactiveThumbColor: Colors.white,         // Thumb when OFF
                      inactiveTrackColor: Colors.grey.shade400, // Track when OFF
                    ),


                    subtitle: Text(student['payment']
                        ? 'Payment Received'
                        : 'Pending Payment'),
                    leading: Icon(
                      student['payment'] ? Icons.check_circle : Icons.cancel,
                      color: student['payment'] ? Colors.green : Colors.red,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showStudentDetailsModal(BuildContext context, Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(student['name']),
        content: Material(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Phone: ${student['phone']}"),
              Text("Location: ${student['location']}"),
              Text("University: ${student['university']}"),
              Text("Seat: ${student['seat']}"),
              Text("Notes: ${student['notes']}"),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _openChatBox(context, student);
                },
                icon: Icon(Icons.chat),
                label: Text("Chat Now"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF121435),
                  foregroundColor: Colors.white,
                ),
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text("Close"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  void _openChatBox(BuildContext context, Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Chat with ${student['name']}"),
        content: Material(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text("Hello, any issues with your trip today?"),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Type a message...",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext), // ✅ FIXED
            child: Text("Close"),
          ),
        ],
      ),
    );
  }
}
