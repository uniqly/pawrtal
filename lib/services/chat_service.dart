import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawrtal/models/message/message.dart';

class ChatService extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // send message
  Future <void> sendMessage(String receiverId, String message) async {
    // get user current info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentDisplayName = _firebaseAuth.currentUser!.displayName ?? 'Anonymous'; // Provide a default value
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message, 
      senderDisplayName: currentDisplayName,
      );

    // connstruct chatroom id from current user id and receiver id (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // sort ids (ensure chat room id is always the same for any pair of users)
    String chatRoomId = ids.join(
      "_" // combine the ids into a single string to use as a chatroomID
    );

    //create chat room if doesnt exists already
    await _firestore.collection('chat_rooms').doc(chatRoomId).set({'users': FieldValue.arrayUnion(ids)}, SetOptions(merge: true));
    
    //add new message to database
    await _firestore
      .collection('chat_rooms')
      .doc(chatRoomId)
      .collection('messages')
      .add(newMessage.toMap());
  }
  // recieve message
  Stream<QuerySnapshot> getMesasges(String userId, String otherUserId) {
    // construct chat room id from user ids (sorted to ensure it matches the user id used when sending message)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join(
      "_" // combine the ids into a single string to use as a chatroomID
    );
    return _firestore
      .collection('chat_rooms')
      .doc(chatRoomId)
      .collection('messages')
      .orderBy('timestamp', descending: false).snapshots();
  }
}