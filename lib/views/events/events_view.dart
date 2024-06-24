import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_event_view.dart';
import 'package:intl/intl.dart';

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
                MaterialPageRoute(
                    builder: (context) => const CreateEventView()),
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
      stream: FirebaseFirestore.instance.collection('events').snapshots(),
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
              event['eventName'],
              '$dateRange\n${event['eventLocation']}\n${event['eventDescription']}',
              event['eventImage'], // Handle event images from Firestore
            );
          },
        );
      },
    );
  }

  Widget _buildPastEvents() {
    return ListView(
      children: [
        _buildEventCard(
          'Nanyang Pet Carnival June 2024',
          '29 June 2024 | 5:30PM - 7:30PM\nNanyang CC - Singapore',
          'assets/app/people_walking_dog.jpg',
        ),
        _buildEventCard(
            'Pets Weekend: May',
            '25 - 26 May 2024 | 10AM - 6PM\nCrane Joo Chiat - Singapore',
            'assets/app/pet_weekend.jpeg'),
        _buildEventCard(
            'Pet Expo 2024',
            '15 - 17 March 2024 | 11AM - 8PM\nSingapore Expo Halls 5B & 6 - Singapore',
            'assets/app/pet_expo.png'),
        // Add more event cards here
      ],
    );
  }

  Widget _buildEventCard(String title, String details, String imagePath) {
    return Card(
      margin: const EdgeInsets.all(10.0),
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
              details,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
                const SizedBox(width: 10), // Add some spacing between the buttons
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
          ),
        ],
      ),
    );
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