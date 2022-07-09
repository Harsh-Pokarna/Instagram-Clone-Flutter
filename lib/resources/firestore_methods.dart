import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
      {required String description,
      required Uint8List file,
      required String uid,
      required String username,
      required String profileImage}) async {
    String res = 'Some error occured';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        username: username,
        profileImage: profileImage,
        uid: uid,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (error) {
      res = error.toString(); 
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if(likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> postComment({
    required String postId,
    required String text,
    required User user,
  }) async {
    try {
      if(text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic': user.photoUrl,
          'username': user.username,
          'uid': user.uid,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'text': text,
        });

      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> deletePost({
    required String postId,
  }) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (error) {
      print(error.toString()) ;
    }
  }

  Future<void> followUser({
    required String currnetUid,
    required String followUid,   
  }) async {
    try { 
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(currnetUid).get();
      if((snapshot.data()! as dynamic)['following'].contains(followUid)) {
        await _firestore.collection('users').doc(followUid).update({
          'followers': FieldValue.arrayRemove([currnetUid]),
        });
        await _firestore.collection('users').doc(currnetUid).update({
          'following': FieldValue.arrayRemove([followUid]),
        });
      } else {
        await _firestore.collection('users').doc(followUid).update({
          'followers': FieldValue.arrayUnion([currnetUid]),
        });
        await _firestore.collection('users').doc(currnetUid).update({
          'following': FieldValue.arrayUnion([followUid]),
        });
      }

    } catch (error) {
      print(error.toString());
    }
  }
}
