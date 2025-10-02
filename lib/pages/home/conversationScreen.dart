import 'package:flutter/material.dart';
import 'package:mysecondapp/models/chatSportiObj.dart';
import 'package:mysecondapp/models/convercation.dart';
import 'package:mysecondapp/models/user.dart';
import 'package:mysecondapp/services/database.dart';
import 'package:provider/provider.dart';

class Conversation extends StatefulWidget {
  final ChatSporti chatRoomId;
  Conversation(this.chatRoomId);
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  // Current user ID
  String userId = 'current_user';

  TextEditingController messageController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);
    final chatter = Provider.of<List<ConversationObj>>(context);
    
    sendMessage() async {
      if (messageController.text.isNotEmpty) {
        String message = messageController.text;
        String sendby = widget.chatRoomId.likedBy;
        
        // Save message to local database
        DatabaseService dbService = DatabaseService(uid: user.uid, chatId: widget.chatRoomId.chatId);
        await dbService.addConversationMessage(widget.chatRoomId.chatId, message, sendby);
        
        // Clear the text field
        messageController.text = '';
        
        // Refresh the UI
        setState(() {});
      } else {
        print("empty text");
      }
    }

    Widget chatMessageList() {
      return ListView.builder(
          itemCount: chatter.length,
          itemBuilder: (context, index) {
            return MessageTile(
              msg: chatter[index].message,
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.chatRoomId.likedTo),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Text message ... ',
                            hintStyle: TextStyle(color: Colors.white54)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => sendMessage(),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(20)),
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String msg;
  MessageTile({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Text(msg),
    );
  }
}