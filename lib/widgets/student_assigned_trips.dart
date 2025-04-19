import 'package:flutter/material.dart';

class StudentAssignedTrips extends StatelessWidget {
  final List<Map<String, String>> trips;
  final Map<String, String> activeTrip;

  const StudentAssignedTrips({
    Key? key,
    this.trips = const [
      {
        'name': 'Morning Trip',
        'time': '7:30 AM',
        'destination': 'University District',
        'bus': 'Bus 2',
        'driver': 'Ahmed Zaki',
      },
      {
        'name': 'Return Trip',
        'time': '3:00 PM',
        'destination': 'Home',
        'bus': 'Bus 2',
        'driver': 'Ahmed Zaki',
      },
    ],
    this.activeTrip = const {
      'destination': 'University District',
      'estimatedArrival': '8:15 AM',
      'driver': 'Ahmed Zaki',
      'bus': 'Bus 2',
      'status': 'On the way',
      'location': 'Beirut Ring Road, Near ABC',
    },
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Active Trip Live Tracking Box
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFFF6500)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("🛰️ Active Trip – Live Tracking",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Text("Bus: ${activeTrip['bus']}"),
              Text("Driver: ${activeTrip['driver']}"),
              Text("Destination: ${activeTrip['destination']}"),
              Text("Estimated Arrival: ${activeTrip['estimatedArrival']}"),
              Text("Status: ${activeTrip['status']}"),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "Current Location: ${activeTrip['location']}",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: Text("Map Preview Placeholder",
                    style: TextStyle(color: Colors.grey.shade700)),
              )
            ],
          ),
        ),
        SizedBox(height: 24),

        // Trip History Cards
        ...trips.map((trip) => Card(
          margin: EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: ListTile(
            leading: Icon(Icons.directions_bus, color: Color(0xFFFF6500)),
            title: Text(trip['name'] ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Time: ${trip['time']}"),
                Text("Destination: ${trip['destination']}"),
                Text("Bus: ${trip['bus']}"),
                Text("Driver: ${trip['driver']}"),
              ],
            ),
            isThreeLine: true,
          ),
        )),
      ],
    );
  }
}
