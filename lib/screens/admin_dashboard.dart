import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String selectedPage = 'manage_users';

  List<Map<String, String>> users = [
    {'name': 'Ali Mansour', 'phone': '01012345678', 'role': 'student'},
    {'name': 'Lina Hafez', 'phone': '01198765432', 'role': 'driver'},
    {'name': 'Omar Nasser', 'phone': '01234567890', 'role': 'owner'},
    {'name': 'Sarah Fadel', 'phone': '01000000000', 'role': 'student'},
  ];

  List<Map<String, String>> ownerRequests = [
    {
      'name': 'Hany Saad',
      'phone': '01122334455',
      'company': 'Saad Transport',
      'licenseImage': 'assets/license1.jpg'
    },
    {
      'name': 'Rana El-Sayed',
      'phone': '01211223344',
      'company': 'El-Sayed Buses',
      'licenseImage': 'assets/license2.jpg'
    },
  ];

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

  late ScrollController _horizontalScrollController;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  Widget _buildUserTable() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF121435).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Users", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Scrollbar(
            controller: _horizontalScrollController,
            thumbVisibility: true,
            trackVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _horizontalScrollController,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Color(0xFF121435)),
                headingTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: users.map((user) {
                  return DataRow(cells: [
                    DataCell(Text(user['name']!)),
                    DataCell(Text(user['phone']!)),
                    DataCell(Text(user['role']!)),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.orange),
                        onPressed: () {
                          setState(() {
                            users.remove(user);
                          });
                        },
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildOwnerRequests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ownerRequests.map((req) {
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${req['name']}", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Phone: ${req['phone']}"),
              Text("Company: ${req['company']}"),
              SizedBox(height: 10),
              Text("Uploaded License Image:"),
              SizedBox(height: 6),
              Container(
                height: 120,
                width: 200,
                color: Colors.grey.shade300,
                child: Center(child: Text("${req['licenseImage']}")), // Replace with Image.asset in real case
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        ownerRequests.remove(req);
                      });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF121435)),
                    child: Text("Accept"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        ownerRequests.remove(req);
                      });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: Text("Reject"),
                  ),
                ],
              )
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPageContent() {
    if (selectedPage == 'manage_users') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Manage Users", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          _buildUserTable(),
        ],
      );
    } else if (selectedPage == 'manage_owner_requests') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Owner Requests", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          _buildOwnerRequests(),
        ],
      );
    }
    return Center(child: Text("Page not implemented yet"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF9F0),
      appBar: AppBar(
        backgroundColor: Color(0xFF121435),
        title: Text("Admin Dashboard"),
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
                  Icon(Icons.admin_panel_settings, size: 40, color: Colors.white),
                  SizedBox(height: 8),
                  Text('Administrator',
                      style: TextStyle(
                          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('admin@classride.com', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            _buildDrawerItem(Icons.supervised_user_circle, 'Manage Users', () => _selectPage('manage_users')),
            _buildDrawerItem(Icons.assignment_ind, 'Owner Requests', () => _selectPage('manage_owner_requests')),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: _buildPageContent(),
      ),
    );
  }
}
