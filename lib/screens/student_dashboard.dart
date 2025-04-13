import 'package:flutter/material.dart';
import '../widgets/student_profile_management.dart';
import '../widgets/student_assigned_trips.dart';
import '../widgets/chats.dart';


class AttendanceBox extends StatefulWidget {
  @override
  _AttendanceBoxState createState() => _AttendanceBoxState();
}

class _AttendanceBoxState extends State<AttendanceBox> {
  bool _attendingTomorrow = false;
  final TextEditingController _scheduleController = TextEditingController(text: "3:00 PM");

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Color(0xFF3F7D58)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Are you attending tomorrow?", style: TextStyle(fontWeight: FontWeight.bold)),
          Switch(
            value: _attendingTomorrow,
            onChanged: (val) {
              setState(() {
                _attendingTomorrow = val;
              });
            },
            activeColor: Color(0xFF3F7D58),
          ),
          SizedBox(height: 8),
          Text("you want to change your fixed return time?:", style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 4),
          TextField(
            controller: _scheduleController,
            decoration: InputDecoration(
              hintText: "e.g. 3:00 PM",
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileManagement extends StatefulWidget {
  final String initialName;
  final String initialPhone;
  final void Function(String name, String phone)? onSave;

  ProfileManagement({
    this.initialName = "",
    this.initialPhone = "",
    this.onSave,
  });

  @override
  _ProfileManagementState createState() => _ProfileManagementState();
}

class _ProfileManagementState extends State<ProfileManagement> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _phoneController = TextEditingController(text: widget.initialPhone);
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    setState(() {
      _isEditing = false;
    });
    if (widget.onSave != null) {
      widget.onSave!(_nameController.text, _phoneController.text);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profile updated successfully!")),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool enabled) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Profile Management", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 24),
          _buildTextField("Full Name", _nameController, _isEditing),
          SizedBox(height: 16),
          _buildTextField("Phone Number", _phoneController, _isEditing),
          SizedBox(height: 24),
          Row(
            children: [
              ElevatedButton(
                onPressed: _toggleEdit,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: Text(_isEditing ? "Cancel" : "Edit"),
              ),
              SizedBox(width: 16),
              if (_isEditing)
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text("Save"),
                ),
            ],
          )
        ],
      ),
    );
  }
}

class StudentDashboard extends StatefulWidget {
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  String selectedPage = 'dashboard';

  void _selectPage(String page) {
    setState(() {
      selectedPage = page;
    });
    Navigator.pop(context); // Close drawer
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF3F7D58)),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _getSelectedPageContent() {
    switch (selectedPage) {
      case 'dashboard':
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: AttendanceBox(),
              ),
              SizedBox(height: 24),
              StudentProfileManagement(),
            ],
          ),
        );


      case 'my_trips':
        return StudentAssignedTrips();

      case 'chats':
        return ChatsPage();


      default:
        return Center(child: Text("Page not found"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      appBar: AppBar(
        backgroundColor: Color(0xFF3F7D58),
        title: Text("Student Dashboard"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF3F7D58)),
              child: Center(
                child: Text(
                  "Student Menu",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            _buildDrawerItem(Icons.dashboard, 'Dashboard', () => _selectPage('dashboard')),
            _buildDrawerItem(Icons.directions_bus, 'My Trips', () => _selectPage('my_trips')),
            _buildDrawerItem(Icons.chat, 'Chats', () => _selectPage('chats')),

            // 👇 New Section: Navigation Back to Home
            Divider(),
            _buildDrawerItem(Icons.home, 'Back to Home', () {
              Navigator.popUntil(context, (route) => route.isFirst);
            }),

            // 👇 New Section: Logout
            _buildDrawerItem(Icons.logout, 'Logout', () {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacementNamed(context, '/', arguments: 'logout');
            }),
          ],
        ),
      ),

      body: _getSelectedPageContent(),
    );
  }
}
