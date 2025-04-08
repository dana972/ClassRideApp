import 'package:flutter/material.dart';

class TripManagement extends StatelessWidget {
  final List<String> buses;
  final List<String> destinations;
  final List<String> drivers;
  final List<Map<String, String>> trips;
  final List<Map<String, dynamic>> assignableStudents;

  final Function(Map<String, String>) onTripCreated;
  final Function(Map<String, String>) onTripRemoved;
  final Function(Map<String, dynamic>, Map<String, String>) onStudentAssigned;

  TripManagement({
    required this.buses,
    required this.destinations,
    required this.drivers,
    required this.trips,
    required this.assignableStudents,
    required this.onTripCreated,
    required this.onTripRemoved,
    required this.onStudentAssigned,
  });

  void _showCreateTripModal(BuildContext context) {
    _showTripFormModal(context, title: "Create New Trip", onSave: onTripCreated);
  }

  void _showEditTripModal(BuildContext context, Map<String, String> originalTrip) {
    _showTripFormModal(
      context,
      title: "Edit Trip",
      initialTrip: originalTrip,
      onSave: (updatedTrip) {
        onTripRemoved(originalTrip);  // Remove the old
        onTripCreated(updatedTrip);  // Add the updated one
      },
    );
  }

  void _showTripFormModal(
      BuildContext context, {
        required String title,
        Map<String, String>? initialTrip,
        required Function(Map<String, String>) onSave,
      }) {
    String? selectedBus = initialTrip?['bus'];
    String? selectedDestination = initialTrip?['destination'];
    String? selectedDriver = initialTrip?['driver'];

    showDialog(
      context: context,
      builder: (_) {
        return MediaQuery.removeViewInsets(
          context: context,
          removeBottom: true,
          child: AlertDialog(
            title: Text(title),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                    });
                    Navigator.pop(context);
                  }
                },
                child: Text("Save"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTripList(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Created Trips",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () => _showCreateTripModal(context),
                child: Text("Create New Trip"),
              ),
            ],
          ),
          Divider(),
          ...trips.map((trip) {
            return ListTile(
              title: Text("${trip['bus']} → ${trip['destination']}"),
              subtitle: Text("Driver: ${trip['driver']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showEditTripModal(context, trip),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => onTripRemoved(trip),
                  ),
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
        final matchingStudents = assignableStudents
            .where((s) => s['destination'] == destination && s['assignedTrip'] == null)
            .toList();

        final matchingTrips = trips
            .where((t) => t['destination'] == destination)
            .toList();

        if (matchingStudents.isEmpty) return SizedBox.shrink();

        return Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(destination, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Divider(),
              ...matchingStudents.map((student) {
                return ListTile(
                  title: Text(student['name']),
                  subtitle: Text("Phone: ${student['phone']}"),
                  trailing: DropdownButton<Map<String, String>>(
                    hint: Text("Assign to Trip"),
                    value: student['assignedTrip'],
                    items: matchingTrips.map((trip) {
                      return DropdownMenuItem(
                        value: trip,
                        child: Text("${trip['bus']} - ${trip['driver']}"),
                      );
                    }).toList(),
                    onChanged: (selectedTrip) {
                      onStudentAssigned(student, selectedTrip!);
                    },
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
    );
  }
}
