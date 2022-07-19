import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class MyMessageCard extends StatelessWidget {
  final String text;
  const MyMessageCard({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),
          color: blueColor,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Text(
              text, 
              style: const TextStyle(
                color: primaryColor
              ),
            ),
          ),
        ),
      ),
    );
  }
}