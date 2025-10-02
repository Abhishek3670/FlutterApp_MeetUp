import 'package:mysecondapp/models/user.dart';
import 'package:mysecondapp/services/local_database.dart';
import 'dart:async';

class AuthService {
  // Current user ID
  String? _currentUserId;
  
  // For demo purposes, we'll use a simple in-memory store
  // In a real app, you might want to persist this
  static Map<String, Map<String, dynamic>> _users = {};
  
  // Auth change user stream
  Stream<UserId?> get user {
    return Stream.value(_currentUserId != null ? UserId(uid: _currentUserId!) : null);
  }

  // Sign in anonymously
  Future<UserId?> signInAnom() async {
    try {
      // Generate a mock user ID
      String userId = 'anon_${DateTime.now().millisecondsSinceEpoch}';
      _currentUserId = userId;
      
      // Create user in local database
      LocalDatabaseService localDB = LocalDatabaseService(uid: userId, chatId: '');
      await localDB.updateUserData('Anonymous Sport', 'Anonymous User', 50);
      
      return UserId(uid: userId);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email & password
  Future<UserId?> loginWithEmailAndPassword(String email, String password) async {
    try {
      // Simple validation for demo
      if (email.isNotEmpty && password.length >= 6) {
        // Generate user ID based on email
        String userId = 'user_${email.hashCode}';
        _currentUserId = userId;
        
        // Store user data (in a real app, you would verify credentials)
        _users[userId] = {
          'email': email,
          'password': password, // Note: Never store plain text passwords in real apps
        };
        
        // Create user in local database
        LocalDatabaseService localDB = LocalDatabaseService(uid: userId, chatId: '');
        await localDB.updateUserData('Default Sport', email.split('@')[0], 75);
        
        return UserId(uid: userId);
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with email & password
  Future<UserId?> registerWithEmailAndPassword(String email, String password) async {
    try {
      // Simple validation for demo
      if (email.isNotEmpty && password.length >= 6) {
        // Check if user already exists
        String userId = 'user_${email.hashCode}';
        if (_users.containsKey(userId)) {
          throw Exception('User already exists');
        }
        
        // Set as current user
        _currentUserId = userId;
        
        // Store user data
        _users[userId] = {
          'email': email,
          'password': password, // Note: Never store plain text passwords in real apps
        };
        
        // Create user in local database
        LocalDatabaseService localDB = LocalDatabaseService(uid: userId, chatId: '');
        await localDB.updateUserData('New Sport', email.split('@')[0], 45);
        
        print('Registered user with email: $email');
        return UserId(uid: userId);
      } else {
        throw Exception('Invalid registration data');
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future<void> logOut() async {
    try {
      _currentUserId = null;
      return;
    } catch (e) {
      print(e.toString());
      return;
    }
  }
}