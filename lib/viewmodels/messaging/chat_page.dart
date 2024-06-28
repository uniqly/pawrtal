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

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // Determine alignment based on sender
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    // Determine background color based on sender
    var backgroundColor = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Colors.blue[100]
        : Colors.grey[300];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: alignment, // Use CrossAxisAlignment.end or CrossAxisAlignment.start
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(data['message']),
                const SizedBox(height: 4.0),
                Text(
                  _formatTimestamp(data['timestamp']), // Format timestamp here
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to format timestamp in 24-hour format
  String _formatTimestamp(Timestamp timestamp) {
    // Example format: HH:mm
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }
}