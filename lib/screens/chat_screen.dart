import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';

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
      body: Container(
        color: Colors.red,
        child: GestureDetector(
          onTap: () {
            print('tapped');
            FocusScope.of(context).requestFocus(null);
          },
          child: Stack(
            children: [
              Column(
                children: [
                   Expanded(
                  child: GestureDetector(
                      onTap: () {
                        print('tapped new');
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: Container(
                        color: Colors.blue,
                      ),
                    ),
                ),
                ],
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
        ),
      ),
    );
  }
}
