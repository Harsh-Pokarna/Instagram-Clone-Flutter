import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class MessagesScreen extends StatefulWidget {
  MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          'username',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add, color: primaryColor),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              textAlignVertical: TextAlignVertical.bottom,
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                hintText: 'Search for users',
                fillColor: mobileSearchColor,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemBuilder: (_, index) => Container(
                  margin: const EdgeInsets.only(bottom: 16, left: 16, right: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 27,
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1593085512500-5d55148d6f0d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80'),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'username',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'last message',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.camera_alt_outlined)),
                    ],
                  )),
              itemCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
