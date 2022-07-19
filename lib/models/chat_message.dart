import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class ChatMessage with ChangeNotifier {
  final String message;
  final DateTime dateTime;
  final bool sentByMe;
  final String receiverId;

  ChatMessage({
    required this.message,
    required this.dateTime,
    required this.sentByMe,
    required this.receiverId,
  });

  Map<String, dynamic> toJson() => {
        'message': message,
        'dateTime': dateTime,
        'sentByMe': sentByMe,
        'receiverId': receiverId,
      };

  static ChatMessage fromSanp(Map map) {
    return ChatMessage(
      message: map['message'],
      dateTime: map['dateTime'],
      sentByMe: map['sentByMe'],
      receiverId: map['receiverId'],
    );
  }
}

class ChatsProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ChatMessage> _chats = [];

  List<ChatMessage> get getChats => _chats;

  Future<String> saveChat(ChatMessage chatMessage) async {
    final String messageId = Uuid().v1();
    String res = 'Some error occured';

    try {
      await _firestore
          .collection('chats')
          .doc(_auth.currentUser!.uid)
          .collection(chatMessage.receiverId)
          .doc(messageId)
          .set(chatMessage.toJson());
      await _firestore
          .collection('chats')
          .doc(chatMessage.receiverId)
          .collection(_auth.currentUser!.uid)
          .doc(messageId)
          .set({
        'message': chatMessage.message,
        'dateTime': chatMessage.dateTime,
        'sentByMe': !chatMessage.sentByMe,
        'otherPersonId': chatMessage.receiverId,
      });

      res = 'Success';
    } catch (error) {
      res = error.toString();
    }
    return res;
  }
  
}
