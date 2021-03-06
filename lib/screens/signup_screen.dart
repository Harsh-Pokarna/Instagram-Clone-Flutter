import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  late var scaffold;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  void signUpUser(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    if (_image == null) {
      showSnackBar('Please select an image', context);
      return;
    }

    String response = await AuthMethods().signupUser(
      email: _emailController.text,
      password: _passwordController.text,
      bio: _bioController.text,
      username: _usernameController.text,
      file: _image!,
    );

    if (response != 'success') {
      showSnackBar(response, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout())));
    }

    setState(() {
      _isLoading = false;
    });
    print(response);
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    scaffold = ScaffoldMessenger.of(context);

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(flex: 2, child: Container()),
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: primaryColor,
                  height: 64,
                ),
                const SizedBox(height: 64),
                Stack(
                  children: [
                    _image == null
                        ? const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1593085512500-5d55148d6f0d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80',
                            ),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          ),
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // text field for user name
                TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: 'User Name',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 20),
                // text filed for bio
                TextFieldInput(
                  textEditingController: _bioController,
                  hintText: 'Bio',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 20),
                // text field for email
                TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'E-mail',
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                // text filed for password
                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: 'Password',
                  isPass: true,
                  textInputType: TextInputType.text,
                ),
                GestureDetector(
                  onTap: () {
                    signUpUser(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 32),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: blueColor),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Sign Up',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Flexible(flex: 2, child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Login.',
                          style: TextStyle(
                            color: blueColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
