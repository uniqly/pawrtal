import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pawrtal/services/auth.dart';
import 'create_event_view.dart';
import 'event_details_view.dart';

class EventsView extends StatelessWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Events',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateEventView()),
              );
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            const TabBar(
              tabs: [
                Tab(text: 'Upcoming'),
                Tab(text: 'Past'),
              ],
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.grey,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildUpcomingEvents(),
                  _buildPastEvents(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .where('endDate', isGreaterThanOrEqualTo: DateTime.now().toIso8601String())
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final events = snapshot.data!.docs;

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            final DateTime startDate = DateTime.parse(event['startDate']);
            final DateTime endDate = DateTime.parse(event['endDate']);
            final String startTime = event['startTime'];
            final String endTime = event['endTime'];

            String dateRange;
            if (startDate == endDate) {
              dateRange = '${DateFormat('yyyy-MM-dd').format(startDate)} | $startTime - $endTime';
            } else {
              dateRange = '${DateFormat('yyyy-MM-dd').format(startDate)} $startTime - ${DateFormat('yyyy-MM-dd').format(endDate)} $endTime';
            }

            return _buildEventCard(
              context,
              event['eventId'],
              event['eventName'],
              dateRange,
              event['eventLocation'],
              event['eventDescription'],
              event['eventImage'],
              event['creatorId'],
            );
          },
        );
      },
    );
  }

  Widget _buildPastEvents() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .where('endDate', isLessThan: DateTime.now().toIso8601String())
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final events = snapshot.data!.docs;

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            final DateTime startDate = DateTime.parse(event['startDate']);
            final DateTime endDate = DateTime.parse(event['endDate']);
            final String startTime = event['startTime'];
            final String endTime = event['endTime'];

            String dateRange;
            if (startDate == endDate) {
              dateRange = '${DateFormat('yyyy-MM-dd').format(startDate)} | $startTime - $endTime';
            } else {
              dateRange = '${DateFormat('yyyy-MM-dd').format(startDate)} $startTime - ${DateFormat('yyyy-MM-dd').format(endDate)} $endTime';
            }

            return _buildEventCard(
              context,
              event['eventId'],
              event['eventName'],
              dateRange,
              event['eventLocation'],
              event['eventDescription'],
              event['eventImage'],
              event['creatorId'],
            );
          },
        );
      },
    );
  }

  Widget _buildEventCard(
    BuildContext context, 
    String eventId, 
    String title, 
    String dateRange, 
    String location, 
    String description, 
    String imagePath, 
    String creatorId) {
      return Card(
        margin: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailsView(
                  title: title,
                  dateRange: dateRange,
                  location: location,
                  description: description,
                  imagePath: imagePath,
                  creatorId: creatorId,
                  eventId: eventId,
                ),
              ),
            );
          },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _loadEventImage(imagePath),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Text(
              dateRange,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Text(
              location,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Handle "Interested" button press
                        },
                        icon: const Icon(Icons.star),
                        label: const Text('Interested'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Handle "Share" button press
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                      ),
                    ),
                  ],
                ),
                FutureBuilder<String?>(
                  future: AuthService().getCurrentUserId(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasData) {
                      String currentUserId = snapshot.data!;
                      if (creatorId == currentUserId) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigate to edit event page
                                  },
                                  child: const Text('Edit'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // Show delete confirmation dialog
                                    bool? confirmDelete = await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Delete Event'),
                                          content: const Text('Are you sure you want to delete this event?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(false);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirmDelete == true) {
                                      await _deleteEvent(eventId);
                                    }
                                  },
                                  child: const Text('Delete'),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return const Text('User not authenticated');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> _deleteEvent(String eventId) async {
  try {
    await FirebaseFirestore.instance.collection('events').doc(eventId).delete();
  } catch (e) {
    print('Error deleting event: $e');
    // Show an error dialog or handle the error as needed
  }
}

  Widget _loadEventImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        height: 250, // Adjust the height as needed
        width: double.infinity,
      );
    } else {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        height: 250, // Adjust the height as needed
        width: double.infinity,
      );
    }
  }
}