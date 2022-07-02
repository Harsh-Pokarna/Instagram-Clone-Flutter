import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final _captionController = TextEditingController();

  void selecteImage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image'),
        content: SizedBox(
          height:104,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  var file = await pickImage(ImageSource.gallery);
                  if(file != null) {
                    setState(() {
                      _file = file;
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  width: MediaQuery.of(context).size.width,
                  child: const Text('Gallery'),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  var file = await pickImage(ImageSource.camera);
                  if(file != null) {
                    setState(() {
                      _file = file;
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  width: MediaQuery.of(context).size.width,
                  child: const Text('Camera'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void postImage(User user) async {
    try {
      
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
  User user = Provider.of<UserProvider>(context, listen: false).getUser;

    return _file == null ?  Center(
      child: IconButton(
        icon: const Icon(Icons.upload),
        color: primaryColor,
        onPressed: selecteImage,
      ),
    ) : 
     Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text('Add Post'),
        actions: [
          TextButton(
            onPressed: () => postImage(user),
            child: const Text(
              'Post',
              style: TextStyle(
                color: blueColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Write caption',
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                  controller: _captionController,
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(_file!),
                      fit: BoxFit.contain,
                      alignment: FractionalOffset.topCenter,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
