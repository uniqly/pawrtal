import 'package:flutter/material.dart';

class EventsView extends StatelessWidget {
  const EventsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to create event page
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
    return ListView(
      children: [
        _buildEventCard('Asia Cat Expo', '29 & 30 June 2024 | 10AM - 8PM\nSuntec Convention — Hall 403 & 404 - SIngapore', 'assets/app/people_walking_dog.jpg'),
        _buildEventCard('Event 2', 'Description of event 2', 'assets/app/people_walking_dog.jpg'),
        // Add more event cards here
      ],
    );
  }

  Widget _buildPastEvents() {
    return ListView(
      children: [
        _buildEventCard('Past Event 1', 'Description of past event 1', 'assets/app/people_walking_dog.jpg'),
        _buildEventCard('Past Event 2', 'Description of past event 2', 'assets/app/people_walking_dog.jpg'),
        // Add more event cards here
      ],
    );
  }

  Widget _buildEventCard(String title, String description, String imagePath) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity, height: 150),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(description),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // Handle event details navigation
                },
                child: const Text('View Details'),
              ),
              TextButton(
                onPressed: () {
                  // Handle joining the event
                },
                child: const Text('Join'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
