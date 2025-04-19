import 'package:flutter/material.dart';

class StudentProfileManagement extends StatefulWidget {
  @override
  _StudentProfileManagementState createState() => _StudentProfileManagementState();
}

class _StudentProfileManagementState extends State<StudentProfileManagement> {
  final TextEditingController _nameController = TextEditingController(text: "Student Name");
  final TextEditingController _phoneController = TextEditingController(text: "01098765432");
  final TextEditingController _universityController = TextEditingController(text: "LIU");

  bool _isEditing = false;

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    setState(() {
      _isEditing = false;
    });
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
          Text("Student Profile", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 24),
          _buildTextField("Full Name", _nameController, _isEditing),
          SizedBox(height: 16),
          _buildTextField("Phone Number", _phoneController, _isEditing),
          SizedBox(height: 16),
          _buildTextField("University", _universityController, _isEditing),
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
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF121435)),
                  child: Text("Save"),
                ),
            ],
          )
        ],
      ),
    );
  }
}
