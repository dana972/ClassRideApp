import 'package:flutter/material.dart';

class ProfileManagement extends StatefulWidget {
  @override
  _ProfileManagementState createState() => _ProfileManagementState();
}

class _ProfileManagementState extends State<ProfileManagement> {
  final TextEditingController _nameController = TextEditingController(text: "Bus Owner");
  final TextEditingController _phoneController = TextEditingController(text: "01012345678");

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
