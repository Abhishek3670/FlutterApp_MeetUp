import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mysecondapp/models/chatSportiObj.dart';
import 'package:mysecondapp/models/convercation.dart';
import 'package:mysecondapp/models/sportiObj.dart';
import 'package:mysecondapp/models/user.dart';

class LocalDatabaseService {
  static Database? _database;
  final String uid;
  String chatId = '';

  LocalDatabaseService({required this.chatId, required this.uid});

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  _initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'meetup.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  // Create tables
  void _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        uid TEXT PRIMARY KEY,
        name TEXT,
        sport TEXT,
        strength INTEGER
      )
    ''');

    // Sportis table
    await db.execute('''
      CREATE TABLE sportis (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sportiId TEXT,
        name TEXT,
        sport TEXT,
        strength INTEGER
      )
    ''');

    // Chat sportis table
    await db.execute('''
      CREATE TABLE chat_sportis (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chatId TEXT,
        interest TEXT,
        likedTo TEXT,
        likedBy TEXT
      )
    ''');

    // Conversations table
    await db.execute('''
      CREATE TABLE conversations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chatRoomId TEXT,
        message TEXT,
        sendBy TEXT,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Insert some initial mock data
    await _insertInitialData(db);
  }

  // Insert initial mock data
  Future<void> _insertInitialData(Database db) async {
    // Insert sample users
    await db.insert('sportis', {
      'sportiId': 'user1',
      'name': 'John Doe',
      'sport': 'Basketball',
      'strength': 80
    });
    
    await db.insert('sportis', {
      'sportiId': 'user2',
      'name': 'Jane Smith',
      'sport': 'Swimming',
      'strength': 75
    });
    
    await db.insert('sportis', {
      'sportiId': 'user3',
      'name': 'Mike Johnson',
      'sport': 'Running',
      'strength': 90
    });

    // Insert sample chat sportis
    await db.insert('chat_sportis', {
      'chatId': 'chat1',
      'interest': 'Basketball',
      'likedTo': 'user2',
      'likedBy': 'user1'
    });

    // Insert sample conversations
    await db.insert('conversations', {
      'chatRoomId': 'chat1',
      'message': 'Hello there!',
      'sendBy': 'user1'
    });
    
    await db.insert('conversations', {
      'chatRoomId': 'chat1',
      'message': 'Hi! How are you?',
      'sendBy': 'user2'
    });
  }

  // Update user data
  Future<void> updateUserData(String sport, String name, var strength) async {
    final db = await database;
    await db.insert(
      'users',
      {
        'uid': uid,
        'sport': sport,
        'name': name,
        'strength': strength
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get user data
  Future<UserData> getUserData() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'uid = ?',
      whereArgs: [uid],
    );

    if (maps.isNotEmpty) {
      return UserData(
        name: maps[0]['name'],
        uid: maps[0]['uid'],
        sport: maps[0]['sport'],
        strength: maps[0]['strength'],
      );
    } else {
      // Return default user data if not found
      return UserData(
        name: 'Default User',
        uid: uid,
        sport: 'Running',
        strength: 75,
      );
    }
  }

  // Get sportis list
  Future<List<Sporti>> getSportis() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query('sportis');
    
    return List.generate(maps.length, (i) {
      return Sporti(
        sportiId: maps[i]['sportiId'],
        name: maps[i]['name'],
        sport: maps[i]['sport'],
        strength: maps[i]['strength'],
      );
    });
  }

  // Get chat sportis list
  Future<List<ChatSporti>> getChatSportis() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query('chat_sportis');
    
    return List.generate(maps.length, (i) {
      return ChatSporti(
        chatId: maps[i]['chatId'],
        interest: maps[i]['interest'],
        likedTo: maps[i]['likedTo'],
        likedBy: maps[i]['likedBy'],
      );
    });
  }

  // Create liked room
  Future<void> createLikedRoom(String likedRoomId, String interest, String likedBy,
      String likedTo) async {
    final db = await database;
    await db.insert(
      'chat_sportis',
      {
        'chatId': likedRoomId,
        'interest': interest,
        'likedBy': likedBy,
        'likedTo': likedTo
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Add conversation message
  Future<void> addConversationMessage(String chatRoomId, String message, String sendBy) async {
    final db = await database;
    await db.insert(
      'conversations',
      {
        'chatRoomId': chatRoomId,
        'message': message,
        'sendBy': sendBy
      },
    );
  }

  // Get conversation messages
  Future<List<ConversationObj>> getConversationMessages(String chatRoomId) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'conversations',
      where: 'chatRoomId = ?',
      whereArgs: [chatRoomId],
      orderBy: 'timestamp ASC'
    );
    
    return List.generate(maps.length, (i) {
      return ConversationObj(
        message: maps[i]['message'],
        sendBy: maps[i]['sendBy'],
        time: DateTime.parse(maps[i]['timestamp']),
      );
    });
  }

  // Get all conversation messages (for the stream)
  Future<List<ConversationObj>> getAllConversationMessages() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query('conversations', orderBy: 'timestamp ASC');
    
    return List.generate(maps.length, (i) {
      return ConversationObj(
        message: maps[i]['message'],
        sendBy: maps[i]['sendBy'],
        time: DateTime.parse(maps[i]['timestamp']),
      );
    });
  }
}