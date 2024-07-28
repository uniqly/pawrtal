import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawrtal/models/user/user_model.dart';
import 'package:pawrtal/views/messaging/chat_page.dart';
import 'package:pawrtal/views/profile/profile.dart';
import 'package:timeago_flutter/timeago_flutter.dart';
class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}
class _MessageViewState extends State<MessageView> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.0,
        title: const Text(
          'Users',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final currentUser = _firebaseAuth.currentUser;
          if (currentUser == null) {
            return const Center(child: Text('No current user'));
          }

          final users = snapshot.data!.docs.where((user) => user.id != currentUser.uid).toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = UserModel.fromSnapshot(uid: users[index].id, snapshot: users[index]);
              var chatRoomId = ([user.uid, currentUser.uid]..sort()).join('_');
              log('chatroom: $chatRoomId');
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('chat_rooms')
                    .doc(chatRoomId)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .limit(1)
                    .snapshots(),
                builder: (context, messageSnapshot) {
                  String lastMessage = 'No Messages Yet';
                  dynamic messageData;
                  log('$chatRoomId ${messageSnapshot.hasData}');
                  if (!messageSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (messageSnapshot.hasError) {
                    log(messageSnapshot.error.toString());
                  } else if (messageSnapshot.data!.docs.isNotEmpty) {
                    log('${messageSnapshot.data!.docs}');
                    messageData = messageSnapshot.data!.docs.first.data();
                    lastMessage = messageData['message'];
                  }

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            receiver: user,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileView(userId: user.uid))),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.pfp),
                        ),
                      ),
                      title: Text('${user.displayName} (@${user.username})'),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              lastMessage, 
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          if (lastMessage != 'No Messages Yet') ... [
                            const SizedBox(width: 10.0,),
                            Timeago(
                              builder: (_, val) => Text(val, style: TextStyle(color: Colors.grey[600])),
                              date: messageData['timestamp'].toDate()
                            ),
                          ]
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}