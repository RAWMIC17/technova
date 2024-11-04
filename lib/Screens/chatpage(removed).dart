import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String recieverID;
  final String recieverUserName;

  ChatPage({
    super.key,
    required this.recieverEmail,
    required this.recieverID,
    required this.recieverUserName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  List<Map<String, dynamic>> _messages = [];

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollcontroller = ScrollController();

  void scrollDown() {
    _scrollcontroller.animateTo(_scrollcontroller.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  void _sendMessage({String? fileUrl}) {
    if (_messageController.text.isNotEmpty || fileUrl != null) {
      setState(() {
        // Debug print statement to check if this function is being triggered
        print("Sending message: ${_messageController.text}");
        _messages.add({
          'senderID': 'currentUser',
          'message': _messageController.text,
          'fileUrl': fileUrl,
        });

        // Automated bot reply
        _messages.add({
          'senderID': 'bot',
          'message': "Hi, I am here to help!!",
          'fileUrl': null,
        });
      });
      _messageController.clear();
      scrollDown();
    }
  }

  Widget _buildUserInput() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0,left: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(width: 5,),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: TextField(
                enabled: true,
                style: TextStyle( color: Vx.white, fontSize: 16),
                controller: _messageController,
                decoration: InputDecoration(
                  fillColor: Vx.red500,
                  hintText: "Type a message...",
                  hintStyle: TextStyle(color: Vx.gray300,fontWeight: FontWeight.w300),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                focusNode: myFocusNode,
              ),
            ),
          ),
          Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.only(right: 7, left: 12),
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => _sendMessage(),
              icon: Icon(
                Icons.send_rounded,
                color: Colors.white, // Force the color to white
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Vx.gray800,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text(
            widget.recieverUserName,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollcontroller,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final data = _messages[index];
                  bool isCurrentUser = data['senderID'] == 'currentUser';
                  var alignment =
                      isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
      
                  return Container(
                    alignment: alignment,
                    child: ChatBubble(
                      message: data["message"],
                      isCurrentUser: isCurrentUser,
                    ),
                  );
                },
              ),
            ),
            _buildUserInput(),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  ChatBubble({
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: isCurrentUser ? 60 : 8,
          right: isCurrentUser ? 8 : 60),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.blue[200] : Colors.grey[300],
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isCurrentUser ? Vx.black : Vx.black,
          fontSize: 16,
        ),
      ),
    );
  }
}