import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawrtal/models/events/events_model.dart';
import 'package:pawrtal/views/events/event_tile.dart';
import 'create_event_view.dart';

class EventsView extends StatelessWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        length: 3,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: const TabBar(
                tabs: [
                  Tab(text: 'Ongoing'),               
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Past')
                ],
                labelColor: Colors.blueAccent,
                unselectedLabelColor: Colors.grey,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildEvents(EventModel.ongoingEvents),
                  _buildEvents(EventModel.upcomingEvents),
                  _buildEvents(EventModel.pastEvents),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvents(Stream<List<EventModel>> eventStream) {
     return StreamBuilder<List<EventModel>>(
      stream: eventStream, 
      builder: (context, snapshot) { 
        if (snapshot.hasData) {
          return ListView( 
            children: [ 
              for (var event in snapshot.data!)
                EventTile(event: event),
            ],
          );
        } else {
          return const Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()));
        }
      });
  }

  Future<Map<String, dynamic>?> fetchEventData(String eventId) async {
    try {
      DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance.collection('events').doc(eventId).get();
      return eventSnapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error fetching event data: $e');
      return null;
    }
  }
}