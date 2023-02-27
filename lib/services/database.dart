import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysecondapp/models/chatSportiObj.dart';

import 'package:mysecondapp/models/convercation.dart';
import 'package:mysecondapp/models/sportiObj.dart';
import 'package:mysecondapp/models/user.dart';

class DatabaseService {
  final String uid;
  String chatId = '';
  DatabaseService({required this.chatId, required this.uid});
  //collection reference

  final CollectionReference sportiCollection =
      FirebaseFirestore.instance.collection('aatish');

  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chatRoom');

  final CollectionReference likedCollection =
      FirebaseFirestore.instance.collection('likedRoom');

  Future updateUserData(String sport, String name, var strength) async {
    return await sportiCollection
        .doc(uid)
        .set({'id': uid, 'sport': sport, 'name': name, 'strength': strength});
  }

  //sporti list from snapshot
  List<Sporti> _sportiListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Sporti(
          name: doc['name'],
          sport: doc['sport'],
          strength: doc['strength'],
          sportiId: doc['id']);
    }).toList();
  }

  // get sportigramm stream
  Stream<List<Sporti>> get sportis {
    return sportiCollection.snapshots().map(_sportiListFromSnapshot);
  }

  //User data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        name: snapshot.get('name'),
        uid: uid,
        sport: snapshot['sport'],
        strength: snapshot['strength']);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return sportiCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // // chat roomm creation
  // Future createChatRoom(String chatRoomId, dynamic chatRoomMap) async {
  //   return likedCollection.doc(chatRoomId).collection('chat').add(chatRoomMap);
  // }

  // liked room creation
  Future createLikedRoom(String likedRoomId, String interest, String likedBy,
      String likedTo) async {
    return await likedCollection.doc(likedRoomId).set({
      'chatRoomId': likedRoomId,
      'interest': interest,
      'likedBy': likedBy,
      'likedTo': likedTo
    });
  }

  // sporti list from snapshot
  List<ChatSporti> _chatSportiListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ChatSporti(
          chatId: doc['chatRoomId'],
          interest: doc['interest'],
          likedTo: doc['likedTo'],
          likedBy: doc['likedBy']);
    }).toList();
  }

  // get sportigramm stream
  Stream<List<ChatSporti>> get chatSportis {
    return likedCollection.snapshots().map(_chatSportiListFromSnapshot);
  }

  // liked room creation
  Future getcreateLikedRoom(String likedRoomId) async {
    return likedCollection.doc(likedRoomId).snapshots();
  }

  // chat room message
  Future createConversationMessage(String chatRoomId) async {
    return likedCollection.doc(chatRoomId).collection('chats').doc();
  }

  Future addConversationMessage(String chatRoomId, message, sendBy) async {
    return likedCollection.doc(chatRoomId).collection('chats').doc().set({
      'message': message,
      'sendBy': sendBy,
    });
  }

  Future getConversationMessage(String chatRoomId) async {
    chatId = chatRoomId;
    return chatCollection
        .doc(chatRoomId)
        .collection('chats')
        .snapshots()
        .map(_conversationSnapshot);
  }

  List<ConversationObj> _conversationSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ConversationObj(
          message: doc['message'], sendBy: doc['sendBy'], time: doc['time']);
    }).toList();
  }

  Stream<List<ConversationObj>> get conversationData {
    return likedCollection
        .doc()
        .collection('chats')
        .snapshots()
        .map(_conversationSnapshot);
  }
}
