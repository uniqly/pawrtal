import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawrtal/services/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiveUserID;
  final String receiverDisplayName;

  const ChatPage({super.key, required this.receiveUserID, required this.receiverDisplayName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiveUserID, _messageController.text);
      
      // clear the text controller affter sending message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        title: Text(widget.receiverDisplayName)),
        body: Column(
          children: [
            // messages
            Expanded(
              child: _buildMessageList(),
              ),

              // user input
              _buildMessageInput(),
          ],
        ),
      );
  }

  // build meesage list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMesasges(
        widget.receiveUserID, _firebaseAuth.currentUser!.uid),
      builder : (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs
            .map((document) => _buildMessageItem(document))
            .toList(),
          );
        }
      );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the messages to the right if sender is current useer, otherwise to the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
      ? Alignment.centerRight 
      : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns texts to the start
        children: [
          // Container for senderDisplayName
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              data['senderDisplayName'] ?? 'Unknown', // Use 'Unknown' if senderDisplayName is null
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4.0), // Spacing between the boxes
          // Container for message
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(data['message']),
          ),
        ],
      ),
    );
  }
    

  // build message input
Widget _buildMessageInput() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        // Text field inside a decorated box
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0), // Add padding inside the text field
                hintText: 'Enter Message',
                border: InputBorder.none,
              ),
              obscureText: false,
            ),
          ),
        ),
        const SizedBox(width: 1.0), // Reduce the space between the input and the button
        // Circular send button
        RawMaterialButton(
          onPressed: sendMessage,
          elevation: 2.0,
          fillColor: Colors.blue[300],
          padding: const EdgeInsets.all(12.0), // Adjust padding for the circular button
          shape: const CircleBorder(),
          child: const Icon(
            Icons.arrow_forward,
            size: 30.0,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
}