import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawrtal/models/user/user_model.dart';

class EventModel {
  final String eventId;
  late String _eventName;
  late String _eventLocation;
  late String _eventDescription;
  late String _imagePath;
  late UserModel _creator;
  late Timestamp _startDateTime;
  late Timestamp _endDateTime;
  late List<DocumentReference> _interested;

  String get eventTitle => _eventName;
  String get eventLocation => _eventLocation.isNotEmpty ? _eventLocation : '- No Location -';
  String get description => _eventDescription;
  String get image => _imagePath;
  UserModel get creator => _creator;
  DateTime get startDateTime => _startDateTime.toDate();
  DateTime get endDateTime => _endDateTime.toDate();
  int get numInterested => _interested.length;
  String get dateRange { 
    if (DateUtils.isSameDay(startDateTime, endDateTime)) {
      return '${DateFormat('dd MMMM yyyy HH:mm').format(startDateTime)} to ${DateFormat('HH:mm').format(endDateTime)}';
    } else {
      return '${DateFormat('dd MMMM yyyy HH:mm').format(startDateTime)} to ${DateFormat('dd MMMM yyyy HH:mm').format(endDateTime)}';
    }
  }

  DocumentReference get dbRef => FirebaseFirestore.instance
    .collection('events').doc(eventId);

  EventModel({
    required this.eventId,
  });

  static Future<EventModel> eventFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    final event = EventModel(eventId: snapshot.id);
    final data = snapshot.data()!;
    event._creator = await UserModel(data['creatorId']).updated;
    event._eventName = data['eventName'];
    event._eventLocation = data['eventLocation'];
    event._eventDescription = data['eventDescription'];
    event._startDateTime = data['startDateTime'];
    event._endDateTime = data['endDateTime'];
    event._imagePath = data['eventImage'];
    event._interested = List.from(data['interested'] ?? const Iterable.empty());
    return event;
  }

  bool hasInterestedUser(UserModel user) {
    return _interested.contains(user.dbRef);
  }

  Future<void> addInterestedUser(UserModel user) async {
    // check if user is not interested
    if (!hasInterestedUser(user)) {
      await dbRef.update({ 'interested': FieldValue.arrayUnion([user.dbRef])})
        .then((_) => _interested.add(user.dbRef));
      log(_interested.toString());
    }
  }

  Future<void> removeInterestedUser(UserModel user) async {
    if (hasInterestedUser(user)) {
      await dbRef.update({'interested': FieldValue.arrayRemove([user.dbRef])})
        .then((_) => _interested.remove(user.dbRef));
      log(_interested.toString());
    }
  }

  Future<List<UserModel>> get interestedUsers async {
    // except creator
    return [ 
      for (var userRef in _interested)
        if (userRef.id != creator.uid)
          UserModel.fromSnapshot(uid: userRef.id, snapshot: await (userRef as DocumentReference<Map<String, dynamic>>).get()),
    ];
  }

  static Stream<List<EventModel>> get upcomingEvents {
    return FirebaseFirestore.instance.collection('events')
      .where('startDateTime', isGreaterThanOrEqualTo: Timestamp.now())
      .snapshots()
      .asyncMap((querySnapshot) async { 
        final events = <EventModel>[];
        for (var docSnapshot in querySnapshot.docs) {
          final event = await eventFromSnapshot(docSnapshot);
          events.add(event);
        }
        return events;
      });
  }

  static Stream<List<EventModel>> get ongoingEvents {
    return FirebaseFirestore.instance.collection('events')
      .where('endDateTime', isGreaterThanOrEqualTo: Timestamp.now())
      .where('startDateTime', isLessThanOrEqualTo: Timestamp.now())
      .snapshots()
      .asyncMap((querySnapshot) async { 
        final events = <EventModel>[];
        for (var docSnapshot in querySnapshot.docs) {
          final event = await eventFromSnapshot(docSnapshot);
          events.add(event);
        }
        return events;
      });
  }

  static Stream<List<EventModel>> get pastEvents {
    return FirebaseFirestore.instance.collection('events')
      .where('endDateTime', isLessThan: Timestamp.now())
      .snapshots()
      .asyncMap((querySnapshot) async { 
        final events = <EventModel>[];
        for (var docSnapshot in querySnapshot.docs) {
          final event = await eventFromSnapshot(docSnapshot);
          events.add(event);
        }
        return events;
      });
  }

  Future<void> delete() async {
    await dbRef.delete();
  }
}