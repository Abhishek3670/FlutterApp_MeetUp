import 'package:flutter/material.dart';
import 'package:mysecondapp/models/chatSportiObj.dart';
import 'package:mysecondapp/pages/home/chatTiles.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    final chatters = Provider.of<List<ChatSporti>>(context);
    return ListView.builder(
      itemCount: chatters.length,
      itemBuilder: (context, index) {
        return ChatTile(chatsporti: chatters[index]);
      },
    );
  }
}
