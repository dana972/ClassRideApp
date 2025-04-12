import 'package:flutter/material.dart';
import 'student_dashboard.dart';
import 'driver_dashboard.dart';
import 'owner_dashboard.dart';
import 'admin_dashboard.dart';

class ClientPage extends StatefulWidget {
  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  Map<String, dynamic>? currentUser;
  bool isSignUp = false;
  bool showChatConversation = false;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String selectedRole = 'student';

  final List<Map<String, dynamic>> conversation = [
    {
      'from': 'bot',
      'text': 'Ohh! We found you a bus to drive.',
      'button': 'Apply to this bus owner'
    },
    {
      'from': 'bot',
      'text': 'Ohh! We found you a bus to ride.',
      'button': 'Apply now and join this bus owner'
    },
  ];

  void _showAuthDialog() {
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setInnerState) {
          return AlertDialog(
            backgroundColor: Color(0xFFEFEFEF),
            title: Text(isSignUp ? "Sign Up" : "Login", style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: InputDecoration(labelText: "Select Role"),
                    items: ['student', 'driver', 'owner', 'admin']
                        .map((role) => DropdownMenuItem(value: role, child: Text(role.capitalize())))
                        .toList(),
                    onChanged: (value) => setInnerState(() => selectedRole = value!),
                  ),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: "Phone Number"),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                  ),
                  if (isSignUp)
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Confirm Password"),
                    ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (isSignUp && _passwordController.text != _confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Passwords do not match")),
                        );
                        return;
                      }

                      Navigator.pop(context);

                      Future.delayed(Duration(milliseconds: 100), () {
                        setState(() {
                          currentUser = {
                            'phone': _phoneController.text,
                            'role': selectedRole,
                          };
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFEC5228)),
                    child: Text(isSignUp ? "Sign Up" : "Login"),
                  ),
                  TextButton(
                    onPressed: () => setInnerState(() => isSignUp = !isSignUp),
                    child: Text(isSignUp ? "Already have an account? Login" : "Don't have an account? Sign Up"),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _logout() {
    setState(() {
      currentUser = null;
    });
  }

  void _showOwnerApplicationForm() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController companyController = TextEditingController();
    final TextEditingController licenseController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFFEFEFEF),
          title: Text("Owner Application Form", style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: InputDecoration(labelText: "Full Name")),
                TextField(controller: phoneController, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: "Phone Number")),
                TextField(controller: companyController, decoration: InputDecoration(labelText: "Company Name")),
                TextField(controller: licenseController, decoration: InputDecoration(labelText: "License Number")),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFEC5228)),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Application submitted successfully!")),
                    );
                  },
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSidebar() {
    final bool isLoggedIn = currentUser != null;
    final String? userRole = currentUser?['role'];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF3F7D58)),
            child: Row(
              children: [
                Icon(Icons.directions_bus, size: 30, color: Colors.white),
                SizedBox(width: 10),
                Text("ClassRide", style: TextStyle(fontSize: 24, color: Colors.white)),
              ],
            ),
          ),
          ListTile(title: Text("About Us"), onTap: () {}),
          if (isLoggedIn && userRole != null)
            ListTile(
              title: Text("Dashboard (${userRole.capitalize()})"),
              onTap: () {
                Navigator.pop(context);
                Widget dashboard;
                switch (userRole) {
                  case 'student':
                    dashboard = StudentDashboard();
                    break;
                  case 'driver':
                    dashboard = DriverDashboard();
                    break;
                  case 'owner':
                    dashboard = OwnerDashboard();
                    break;
                  case 'admin':
                    dashboard = AdminDashboard();
                    break;
                  default:
                    dashboard = StudentDashboard();
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => dashboard),
                );
              },
            ),
          ListTile(
            title: Text(isLoggedIn ? "Logout" : "Login / Sign Up"),
            onTap: isLoggedIn ? _logout : _showAuthDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Welcome to ClassRide",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF121435))),
        SizedBox(height: 10),
        Text(
          "ClassRide is a smart and easy-to-use platform designed to connect students, drivers, and bus owners. "
              "It simplifies your daily commute to and from school by helping you manage your ride efficiently and safely.",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 15),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'about.jpg',
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _buildOwnerCard() {
    return Card(
      color: Color(0xFFEF9651),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Are you a bus owner?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            Text("Apply to manage your business and trips using ClassRide.", style: TextStyle(color: Colors.white)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showOwnerApplicationForm,
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3F7D58)),
              child: Text("Apply as Owner"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFinderCard() {
    return Card(
      color: Color(0xFFFFF3E0),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Are you a student or a driver?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Use our chatbot to find a bus within your home location range to ride or drive."),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => setState(() => showChatConversation = true),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3F7D58)),
              child: Text("Find a Bus"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChatBot() {
    if (!showChatConversation) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: conversation.map((msg) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFEF9651),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(msg['text'], style: TextStyle(color: Colors.white)),
                  if (msg['button'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ElevatedButton(
                        onPressed: _showOwnerApplicationForm,
                        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3F7D58)),
                        child: Text(msg['button']!),
                      ),
                    )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == 'logout' && currentUser != null) {
      currentUser = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {}); // Refresh UI after logout
      });
    }

    return Scaffold(
      backgroundColor: Color(0xFFFAF9F0),
      drawer: _buildSidebar(),
      appBar: AppBar(
        backgroundColor: Color(0xFF3F7D58),
        title: Row(
          children: [
            Icon(Icons.directions_bus, color: Colors.white),
            SizedBox(width: 10),
            Text("ClassRide", style: TextStyle(color: Colors.white)),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildWelcomeSection(),
            _buildOwnerCard(),
            _buildFinderCard(),
            _buildChatBot(),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => "${this[0].toUpperCase()}${substring(1)}";
}
