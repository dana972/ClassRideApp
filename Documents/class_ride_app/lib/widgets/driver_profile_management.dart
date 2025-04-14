import 'package:flutter/material.dart';

class DriverProfileManagement extends StatefulWidget {
  @override
  _DriverProfileManagementState createState() => _DriverProfileManagementState();
}

class _DriverProfileManagementState extends State<DriverProfileManagement> {
  final TextEditingController _nameController = TextEditingController(text: "Driver Name");
  final TextEditingController _phoneController = TextEditingController(text: "01098765432");
  final TextEditingController _scheduleController = TextEditingController(text: "6:00 AM - 3:00 PM");

  bool _showForm = false;
  bool _isEditing = false;

  void _toggleFormVisibility() {
    setState(() {
      _showForm = !_showForm;
      _isEditing = false;
    });
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Driver profile updated successfully!")),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: _toggleFormVisibility,
          icon: Icon(_showForm ? Icons.keyboard_arrow_up : Icons.person),
          label: Text(_showForm ? "Hide Driver Profile" : "Show Driver Profile"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        if (_showForm)
          Container(
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Driver Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 24),
                _buildTextField("Full Name", _nameController, _isEditing),
                SizedBox(height: 16),
                _buildTextField("Phone Number", _phoneController, _isEditing),
                SizedBox(height: 16),
                _buildTextField("Available Schedule", _scheduleController, _isEditing),
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
          ),
      ],
    );
  }
}
