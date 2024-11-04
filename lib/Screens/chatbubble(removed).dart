import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:velocity_x/velocity_x.dart';

class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String recieverID;
  final String recieverUserName;

  ChatPage(
      {super.key,
      required this.recieverEmail,
      required this.recieverID,
      required this.recieverUserName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  File? _selectedFile;
  List<Map<String, dynamic>> _messages = []; // Temporary messages list

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
  }

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
        _messages.add({
          'senderID': 'currentUser', // Simulating the current user
          'message': _messageController.text,
          'fileUrl': fileUrl
        });
      });
      _messageController.clear();
      scrollDown();
    }
  }

  void _selectFile() {
    // Placeholder for selecting a file
    setState(() {
      _selectedFile = File('path_to_file'); // Simulate file selection
      _sendMessage(fileUrl: 'dummy_file_url'); // Simulate sending file
    });
  }

  Widget _buildMessageItem(Map<String, dynamic> data) {
    bool isCurrentUser = data['senderID'] == 'currentUser';
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: ChatBubble(
        message: data["message"],
        isCurrentUser: isCurrentUser,
        username: data["fileUrl"] != null ? "File" : null,
        fileUrl: data["fileUrl"],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollcontroller,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return _buildMessageItem(_messages[index]);
      },
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message. . .",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              focusNode: myFocusNode,
            ),
          ),
          Transform.rotate(
            angle: 220 * math.pi / 180,
            child: IconButton(
              iconSize: 27,
              icon: Icon(Icons.attach_file_rounded),
              onPressed: _selectFile,
              color: Vx.black,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 12),
            decoration:
                BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            child: IconButton(
              onPressed: () => _sendMessage(),
              icon: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: _buildMessageList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final String? username;
  final bool isCurrentUser;
  final String? fileUrl;

  ChatBubble({
    required this.message,
    required this.isCurrentUser,
    this.username,
    this.fileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (username != null)
          Padding(
            padding: EdgeInsets.only(
                left: isCurrentUser ? 0 : 10, right: isCurrentUser ? 10 : 0),
            child: Text(
              username!,
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins"),
            ),
          ),
        Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                  color: isCurrentUser ? Vx.black : Vx.black,
                ),
              ),
              if (fileUrl != null)
                GestureDetector(
                  onTap: () {
                    // Simulate file opening
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sent a file",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                          color: isCurrentUser ? Colors.black : Colors.black,
                        ),
                      ),
                      Text(
                        "Click to open",
                        style: TextStyle(
                          color: Vx.blue700,
                          fontFamily: "Poppins",
                          decoration: TextDecoration.underline,
                          decorationThickness: 2.5,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
