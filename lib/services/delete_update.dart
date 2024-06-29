import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> _deleteEvent(String eventId) async {
  try {
    await FirebaseFirestore.instance.collection('events').doc(eventId).delete();
  } catch (e) {
    print('Error deleting event: $e');
    // Show an error dialog or handle the error as needed
  }
}