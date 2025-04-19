import 'package:flutter/material.dart';

class TripManagement extends StatelessWidget {
  final List<String> buses;
  final List<String> destinations;
  final List<String> drivers;
  final List<Map<String, dynamic>> trips; // ⬅️ Allow dynamic to support students list
  final List<Map<String, dynamic>> assignableStudents;

  final Function(Map<String, dynamic>) onTripCreated;
  final Function(Map<String, dynamic>) onTripRemoved;
  final Function(Map<String, dynamic>, Map<String, dynamic>) onStudentAssigned;
  final Function(Map<String, dynamic>, Map<String, dynamic>) onStudentRemoved;

  TripManagement({
    required this.buses,
    required this.destinations,
    required this.drivers,
    required this.trips,
    required this.assignableStudents,
    required this.onTripCreated,
    required this.onTripRemoved,
    required this.onStudentAssigned,
    required this.onStudentRemoved,
  });

  void _showTripFormModal(
      BuildContext context, {
        required String title,
        Map<String, dynamic>? initialTrip,
        required Function(Map<String, dynamic>) onSave,
      }) {
    String? selectedBus = initialTrip?['bus'];
    String? selectedDestination = initialTrip?['destination'];
    String? selectedDriver = initialTrip?['driver'];

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: selectedBus,
                  hint: Text("Select Bus"),
                  onChanged: (value) => selectedBus = value,
                  items: buses.map((bus) => DropdownMenuItem(value: bus, child: Text(bus))).toList(),
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedDestination,
                  hint: Text("Select Destination"),
                  onChanged: (value) => selectedDestination = value,
                  items: destinations.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedDriver,
                  hint: Text("Select Driver"),
                  onChanged: (value) => selectedDriver = value,
                  items: drivers.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (selectedBus != null && selectedDestination != null && selectedDriver != null) {
                  onSave({
                    'bus': selectedBus!,
                    'destination': selectedDestination!,
                    'driver': selectedDriver!,
                    'students': List<Map<String, dynamic>>.from(initialTrip?['students'] ?? []),
                  });

                  Navigator.pop(context);
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTripList(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(color: Color(0xFF121435), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text("Created Trips", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                onPressed: () {
                  _showTripFormModal(context, title: "Create New Trip", onSave: onTripCreated);
                },
                child: Text("Create New Trip"),
              ),
            ],
          ),
          Divider(color: Colors.white),
          ...trips.map((trip) {
            final students = (trip['students'] as List?)?.cast<Map<String, dynamic>>() ?? [];

            return Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Color(0xFF3F7D58), borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text("${trip['bus']} → ${trip['destination']}", style: TextStyle(color: Colors.white)),
                    subtitle: Text("Driver: ${trip['driver']}", style: TextStyle(color: Colors.white70)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Color(0xFFEDEBCA)),
                          onPressed: () {
                            _showTripFormModal(
                              context,
                              title: "Edit Trip",
                              initialTrip: trip,
                              onSave: (updatedTrip) {
                                onTripRemoved(trip);
                                onTripCreated(updatedTrip);
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.orange),
                          onPressed: () => onTripRemoved(trip),
                        ),
                      ],
                    ),
                  ),
                  if (students.isNotEmpty) ...[
                    Divider(color: Colors.white70),
                    Text("Assigned Students:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ...students.map((student) {
                      return ListTile(
                        title: Text(student['name'], style: TextStyle(color: Colors.white)),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                          onPressed: () => onStudentRemoved(student, trip),
                        ),
                      );
                    }).toList(),
                  ]
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAssignableStudentsByDestination() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: destinations.map((destination) {
        final unassigned = assignableStudents.where((s) => s['destination'] == destination && s['assignedTrip'] == null).toList();
        final tripsForDestination = trips.where((t) => t['destination'] == destination).toList();

        if (unassigned.isEmpty) return SizedBox.shrink();

        return Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(color: Color(0xFFEDEBCA), borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(destination, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Divider(),
              ...unassigned.map((student) {
                return ListTile(
                  title: Text(student['name']),
                  subtitle: Text("Phone: ${student['phone']}"),
                  trailing: DropdownButton<Map<String, dynamic>>(
                    hint: Text("Assign to Trip"),
                    onChanged: (selectedTrip) {
                      onStudentAssigned(student, selectedTrip!);
                    },
                    items: tripsForDestination.map((trip) {
                      return DropdownMenuItem(
                        value: trip,
                        child: Text("${trip['bus']} - ${trip['driver']}"),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Manage Trips", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _buildTripList(context),
            SizedBox(height: 32),
            Text("Students Awaiting Assignment", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            _buildAssignableStudentsByDestination(),
          ],
        ),
      ),
    );
  }
}
