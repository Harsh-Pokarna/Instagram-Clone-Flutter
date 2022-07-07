import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/user.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String profileImage;
  final String postId;
  final datePublished;
  final String postUrl;
  final List likes;

  Post({
    required this.description,
    required this.username,
    required this.profileImage,
    required this.uid,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'uid': uid,
        'username': username,
        'profileImage': profileImage,
        'postId': postId,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'likes': likes,
      };

  static Post fromSanp(Map map) {
    return Post(
      description: map['description'],
      username: map['username'],
      profileImage: map['profileImage'],
      uid: map['uid'],
      postId: map['postId'],
      datePublished: map['datePublished'],
      postUrl: map['postUrl'],
      likes: map['likes'],
    );
  }
}
