import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth  _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // signup user
  Future<String> signupUser({
    required String email,
    required String password,
    required String bio,
    required String username,
    required Uint8List file,
  }) async {
    String res = 'Some error occured';
    try {
      if(email.isEmpty || password.isEmpty || bio.isEmpty || username.isEmpty) {
        res = 'Please fill all fields';
      } else {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        final String _photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': username,
          'uid': userCredential.user!.uid,
          'email': email,
          'bio': bio,
          'photoUrl': _photoUrl,   
          'followers': [],
          'following': [],
        });
        res = 'success';

      }
    } on FirebaseAuthException catch (error) {
      if(error.code == 'invalid-email') {
        res = 'The email is badly formatted';
      } else if (error.code == 'weak-password') {
        res = 'Password should be atleast 6 characters';
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }
}
