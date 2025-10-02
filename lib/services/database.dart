import 'package:mysecondapp/models/chatSportiObj.dart';
import 'package:mysecondapp/models/convercation.dart';
import 'package:mysecondapp/models/sportiObj.dart';
import 'package:mysecondapp/models/user.dart';
import 'package:mysecondapp/services/local_database.dart';
import 'dart:async';

class DatabaseService {
  final String uid;
  String chatId = '';
  
  DatabaseService({required this.chatId, required this.uid});

  // Update user data
  Future<void> updateUserData(String sport, String name, var strength) async {
    LocalDatabaseService localDB = LocalDatabaseService(uid: uid, chatId: chatId);
    return await localDB.updateUserData(sport, name, strength);
  }

  // Get sportis stream
  Stream<List<Sporti>> get sportis {
    LocalDatabaseService localDB = LocalDatabaseService(uid: uid, chatId: chatId);
    return localDB.getSportis().asStream();
  }

  // Get user data stream
  Stream<UserData> get userData {
    LocalDatabaseService localDB = LocalDatabaseService(uid: uid, chatId: chatId);
    return localDB.getUserData().asStream();
  }

  // Create liked room
  Future<void> createLikedRoom(String likedRoomId, String interest, String likedBy,
      String likedTo) async {
    LocalDatabaseService localDB = LocalDatabaseService(uid: uid, chatId: chatId);
    return await localDB.createLikedRoom(likedRoomId, interest, likedBy, likedTo);
  }

  // Get chat sportis stream
  Stream<List<ChatSporti>> get chatSportis {
    LocalDatabaseService localDB = LocalDatabaseService(uid: uid, chatId: chatId);
    return localDB.getChatSportis().asStream();
  }

  // Get or create liked room
  Future<void> getcreateLikedRoom(String likedRoomId) async {
    // This is a placeholder - in a real implementation you might want to do something here
    return;
  }

  // Create conversation message
  Future<void> createConversationMessage(String chatRoomId) async {
    // This is a placeholder - in a real implementation you might want to do something here
    return;
  }

  // Add conversation message
  Future<void> addConversationMessage(String chatRoomId, message, sendBy) async {
    LocalDatabaseService localDB = LocalDatabaseService(uid: uid, chatId: chatId);
    return await localDB.addConversationMessage(chatRoomId, message, sendBy);
  }

  // Get conversation message
  Future<void> getConversationMessage(String chatRoomId) async {
    chatId = chatRoomId;
    // This is a placeholder - in a real implementation you might want to do something here
    return;
  }

  // Get conversation data stream
  Stream<List<ConversationObj>> get conversationData {
    LocalDatabaseService localDB = LocalDatabaseService(uid: uid, chatId: chatId);
    return localDB.getAllConversationMessages().asStream();
  }
}