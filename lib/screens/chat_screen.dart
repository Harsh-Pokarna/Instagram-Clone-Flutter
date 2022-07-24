import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/chat_message.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/chat_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/my_message_card.dart';
import 'package:instagram_clone/widgets/sender_message_card.dart';

class ChatScreen extends StatefulWidget {
  final model.User user;
  ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage(ChatMessage chatMessage) async {
    try {
      await ChatMethods().saveChat(chatMessage);
    } catch (error) {
      showSnackBar(error.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(placeHolderUrl),
            ),
            const SizedBox(width: 10),
            Text(
              'username',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.video_call_outlined,
                color: primaryColor,
                size: 36,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 65),
              height: double.infinity,
              width: double.infinity,
              color: mobileBackgroundColor,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection(widget.user.uid)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        ChatMessage chatMessage = ChatMessage.fromSanp(
                            snapshot.data!.docs[index].data());
                        if (chatMessage.sentByMe) {
                          return MyMessageCard(text: chatMessage.message);
                        } else {
                          return SenderMessageCard(text: chatMessage.message);
                        }
                      },
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                    );
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(color: primaryColor));
                  }
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                  ),
                  suffix: GestureDetector(
                    onTap: () {
                      _sendMessage(ChatMessage(
                          message: _messageController.text,
                          dateTime: DateTime.now(),
                          sentByMe: true,
                          receiverId: widget.user.uid));
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Text('Send',
                          style: TextStyle(
                              color: blueColor, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: mobileSearchColor,
                  filled: true,
                ),
                controller: _messageController,
              ),
            ),
          )
        ],
      ),
    );
  }
}
