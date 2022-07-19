import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/chat_message.dart';

class ChatMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<ChatMessage>> fetchChats () async {
    List<ChatMessage> chats = [];
    try {
      
    } catch (error) {

    }
    return chats;
  }
}