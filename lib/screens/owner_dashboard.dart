import 'package:flutter/material.dart';
import '../widgets/trip_management.dart';
import '../widgets/trip_history.dart';
import '../widgets/chats.dart';
import '../widgets/owner_profile_management.dart';
import '../widgets/payments_management.dart';
class OwnerDashboard extends StatefulWidget {
  @override
  _OwnerDashboardState createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  String selectedPage = 'dashboard';

  List<String> buses = ['Bus 1', 'Bus 2', 'Bus 3'];
  List<String> destinations = ['Downtown', 'University District', 'City Center'];
  List<String> drivers = ['Ahmed Zaki', 'Fatima El-Sayed', 'Youssef Kamal'];

  List<Map<String, dynamic>> students = [
    {'name': 'Sarah Ali', 'phone': '01012345678', 'university': 'LIU', 'attended': false},
    {'name': 'Hassan Omar', 'phone': '01122334455', 'university': 'IUL', 'attended': true},
    {'name': 'Maya Tarek', 'phone': '01234567890', 'university': 'LIU', 'attended': false},
  ];

  void _selectPage(String page) {
    setState(() {
      selectedPage = page;
    });
    Navigator.pop(context);
  }
  List<Map<String, String>> trips = [];

  List<Map<String, dynamic>> assignableStudents = [
    {'name': 'Ali Kamel', 'phone': '01011112222', 'destination': 'City Center', 'assignedTrip': null},
    {'name': 'Laila Nour', 'phone': '01122223333', 'destination': 'Downtown', 'assignedTrip': null},
    {'name': 'Hussein Zaki', 'phone': '01233334444', 'destination': 'University District', 'assignedTrip': null},
    {'name': 'Nour Fathy', 'phone': '01099998888', 'destination': 'City Center', 'assignedTrip': null},
  ];

  void _showRequestsModal() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Color(0xFFEFEFEF), // Light Gray
          title: Text("Join Requests", style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRequestSection(
                  title: "Student Requests",
                  color: Colors.lightBlue.shade100,
                  requests: [
                    {'name': 'Sara Ahmed', 'phone': '01012345678', 'university': 'LIU'},
                    {'name': 'Ali Mahmoud', 'phone': '01098765432', 'university': 'IUL'},
                  ],
                  columns: ['Name', 'Phone', 'University'],
                ),
                SizedBox(height: 24),
                _buildRequestSection(
                  title: "Driver Requests",
                  color: Color(0xFFFFE0C2), // Soft orange background
                  requests: [
                    {'name': 'Mostafa Hassan', 'phone': '01234567891', 'license': 'LIC123456'},
                    {'name': 'Omar Tarek', 'phone': '01122334455', 'license': 'LIC654321'},
                  ],
                  columns: ['Name', 'Phone', 'License'],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close", style: TextStyle(color: Color(0xFF121435))),
            ),
          ],
        );
      },
    );
  }

  void _showAddItemModal(String title, void Function(String) onAdd) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Color(0xFFFAF9F0),
          title: Text("Add $title", style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Enter $title name",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String newItem = controller.text.trim();
                if (newItem.isNotEmpty) {
                  onAdd(newItem);
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRequestSection({
    required String title,
    required Color color,
    required List<Map<String, String>> requests,
    required List<String> columns,
  }) {
    final ScrollController _horizontalController = ScrollController();

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Scrollbar(
            controller: _horizontalController,
            thumbVisibility: true,
            trackVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _horizontalController,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Color(0xFF121435)),
                headingTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                columnSpacing: 16,
                columns: [
                  ...columns.map((c) => DataColumn(label: Text(c))),
                  DataColumn(label: Text("Actions")),
                ],
                rows: requests.map((req) {
                  return DataRow(cells: [
                    ...columns.map((col) => DataCell(Text(req[col.toLowerCase()] ?? ''))),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.check_circle, color: Colors.green),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.cancel, color: Colors.red),
                          onPressed: () {},
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardBox({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    Widget? trailing,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: Color(0xFF121435)),
            SizedBox(height: 10),
            Text(
              "$count",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 16)),
            if (trailing != null) ...[
              SizedBox(height: 12),
              trailing,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildListBox({
    required String title,
    required Color color,
    required List<String> items,
    required VoidCallback onAdd,
    required void Function(String item) onRemove,
  }) {
    final bool showAddButton = title != 'Drivers';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              if (showAddButton)
                IconButton(
                  icon: Icon(Icons.add_circle, color: Color(0xFF121435)),
                  tooltip: 'Add $title',
                  onPressed: onAdd,
                ),
            ],
          ),
          Divider(),
          ...items.map((item) {
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              title: Text(item),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => onRemove(item),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildStudentTable() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Students", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Color(0xFF121435)),
              headingTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              columnSpacing: 24,
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Phone')),
                DataColumn(label: Text('University')),
                DataColumn(label: Text('Attendance')),
                DataColumn(label: Text('Actions')),
              ],
              rows: students.map((student) {
                return DataRow(cells: [
                  DataCell(Text(student['name'])),
                  DataCell(Text(student['phone'])),
                  DataCell(Text(student['university'])),
                  DataCell(Switch(
                    value: student['attended'],
                    onChanged: (val) {
                      setState(() {
                        student['attended'] = val;
                      });
                    },
                  )),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete, color: Color(0xFFFF5722)),
                      onPressed: () {
                        setState(() {
                          students.remove(student);
                        });
                      },
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent() {
    if (selectedPage == 'dashboard') {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              ProfileManagement(),
              SizedBox(height: 24),

              Text(
                "Welcome, Bus Owner!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF121435),
                ),
              ),
              SizedBox(height: 24),

              Row(
                children: [
                  _buildDashboardBox(
                    title: "Joined Students",
                    count: students.length,
                    icon: Icons.group,
                    color: Colors.green.shade100,
                  ),
                  _buildDashboardBox(
                    title: "Join Requests",
                    count: 5,
                    icon: Icons.mark_email_unread,
                    color: Colors.orange.shade100,
                    trailing: ElevatedButton(
                      onPressed: _showRequestsModal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEC5228), // Red-Orange
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ),
                      child: Text("View Requests", style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              LayoutBuilder(
                builder: (context, constraints) {
                  bool isWide = constraints.maxWidth > 600;

                  return Column(
                    children: [
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: isWide
                                ? (constraints.maxWidth - 32) / 2
                                : constraints.maxWidth,
                            child: _buildListBox(
                              title: 'Buses',
                              color: Colors.blue.shade100,
                              items: buses,
                              onAdd: () => _showAddItemModal('Bus', (value) {
                                setState(() => buses.add(value));
                              }),
                              onRemove: (item) => setState(() => buses.remove(item)),
                            ),
                          ),
                          SizedBox(
                            width: isWide
                                ? (constraints.maxWidth - 32) / 2
                                : constraints.maxWidth,
                            child: _buildListBox(
                              title: 'Destinations',
                              color: Colors.purple.shade100,
                              items: destinations,
                              onAdd: () => _showAddItemModal('Destination', (value) {
                                setState(() => destinations.add(value));
                              }),
                              onRemove: (item) => setState(() => destinations.remove(item)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _buildListBox(
                        title: 'Drivers',
                        color: Color(0xFFEDEBCA),
                        items: drivers,
                        onAdd: () {}, // Disabled
                        onRemove: (item) => setState(() => drivers.remove(item)),
                      ),
                      SizedBox(height: 16),
                      _buildStudentTable(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      );

    }

    if (selectedPage == 'manage_trips') {
      return TripManagement(
        buses: buses,
        destinations: destinations,
        drivers: drivers,
        trips: trips,
        assignableStudents: assignableStudents,
        onTripCreated: (trip) => setState(() => trips.add(trip)),
        onTripRemoved: (trip) => setState(() => trips.remove(trip)),
        onStudentAssigned: (student, trip) => setState(() => student['assignedTrip'] = trip),
      );
    }


    if (selectedPage == 'trip_history') {
      return TripHistory();
    }
    if (selectedPage == 'chats') {
      return ChatsPage();
    }

    if (selectedPage == 'manage_payments') {
      return PaymentsManagement();
    }
    return Center(child: Text("Page not found"));
  }

  Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF121435)),
      title: Text(label, style: TextStyle(fontSize: 16, color: Color(0xFF121435))),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF9F0),
      appBar: AppBar(
        backgroundColor: Color(0xFF121435), // Primary Green
        title: Text("Owner Dashboard"),
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
                  Text('Bus Owner',
                      style: TextStyle(
                          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('owner@classride.com', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            _buildDrawerItem(Icons.dashboard, 'Dashboard', () => _selectPage('dashboard')),
            _buildDrawerItem(Icons.manage_search, 'Manage Trips', () => _selectPage('manage_trips')),
            _buildDrawerItem(Icons.money, 'Manage Payments', () => _selectPage('manage_payments')),
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




}


