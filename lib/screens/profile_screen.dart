import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  var postLeng = 0;
  int followers = 0, following = 0;
  bool isFollowing = false;
  bool _isLoading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postLeng = postSnapshot.docs.length;
      userData = userSnapshot.data()!;
      followers = userData['followers'].length;
      following = userData['following'].length;
      isFollowing = userData['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(color: primaryColor),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(userData['photoUrl']),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColum(postLeng, 'posts'),
                                    buildStatColum(followers, 'followers'),
                                    buildStatColum(following, 'following'),
                                  ],
                                ),
                                FirebaseAuth.instance.currentUser!.uid ==
                                        widget.uid
                                    ? FollowButton(
                                        backgroundColor: primaryColor,
                                        textColor: Colors.black,
                                        text: 'Sign Out',
                                        function: () async {
                                          await AuthMethods().signOut();
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const LoginScreen()));
                                        },
                                      )
                                    : isFollowing
                                        ? FollowButton(
                                            backgroundColor: primaryColor,
                                            textColor: Colors.black,
                                            text: 'Unfollow',
                                            function: () async {
                                              setState(() {
                                                isFollowing = false;
                                                followers--;
                                              });
                                              await FirestoreMethods()
                                                  .followUser(
                                                      currnetUid: FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                      followUid: widget.uid);
                                            },
                                          )
                                        : FollowButton(
                                            backgroundColor: blueColor,
                                            textColor: primaryColor,
                                            text: 'Follow',
                                            function: () async {
                                              setState(() {
                                                isFollowing = true;
                                                followers++;
                                              });
                                              await FirestoreMethods()
                                                  .followUser(
                                                      currnetUid: FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                      followUid: widget.uid);
                                            },
                                          ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          userData['bio'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(color: Colors.grey),
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      );
                    } else {
                      return GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 2,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) => Container(
                                child: Image.network(
                                  snapshot.data!.docs[index]['postUrl'],
                                  fit: BoxFit.cover,
                                ),
                              ));
                    }
                  },
                )
              ],
            ),
          );
  }

  Column buildStatColum(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ],
    );
  }
}
