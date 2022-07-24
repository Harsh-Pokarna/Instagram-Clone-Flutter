import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ChatMessage with ChangeNotifier {
  final String message;
  final dateTime;
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
  
  
}
