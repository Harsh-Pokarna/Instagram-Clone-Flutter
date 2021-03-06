import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'uid': uid,
        'photoUrl': photoUrl,
        'username': username,
        'bio': bio,
        'followers': followers,
        'following': following,
      };

  static User fromSanp(DocumentSnapshot snapshot) {
    var map = snapshot.data() as Map<String, dynamic>;
    return User(
      email: map['email'],
      uid: map['uid'],
      photoUrl: map['photoUrl'],
      username: map['username'],
      bio: map['bio'],
      followers: map['followers'],
      following: map['following'],
    );
  }
}
