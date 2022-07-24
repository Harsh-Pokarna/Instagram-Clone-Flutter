import 'package:flutter/material.dart';
import 'package:instagram_clone/models/chat_message.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/widgets/my_message_card.dart';
import 'package:instagram_clone/widgets/sender_message_card.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

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

  void _sendMessage() {
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
              child: ListView.builder(
                itemBuilder: (_, index) => index % 2 == 0
                    ? const MyMessageCard(
                        text:
                            'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs')
                    : const SenderMessageCard(
                        text:
                            'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs'),
                itemCount: 20,
                shrinkWrap: true,
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
                  suffix:
                     GestureDetector(
                      onTap: () {},
                       child: const Padding(
                         padding: EdgeInsets.only(right: 8),
                         child: Text('Send', style: TextStyle(color: blueColor, fontWeight: FontWeight.bold)),
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
