import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/chat_message.dart';
import 'package:uuid/uuid.dart';

class ChatMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;     

  Future<String> saveChat(ChatMessage chatMessage) async {
    final String messageId = Uuid().v1();
    String res = 'Some error occured';

    try {
      await _firebaseFirestore
          .collection('chats')
          .doc(_auth.currentUser!.uid)
          .collection(chatMessage.receiverId)
          .doc(messageId)
          .set(chatMessage.toJson());
      await _firebaseFirestore
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