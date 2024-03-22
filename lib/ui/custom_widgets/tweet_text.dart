import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:titer/ui/constants/pallete.dart';
import 'package:titer/ui/constants/routes.dart';

class TweetText extends StatelessWidget {
  final String text;
  const TweetText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];

    text.split(' ').forEach((word) {
      if (word.startsWith('#')) {
        textSpans.add(
          TextSpan(
              text: '$word ',
              style: const TextStyle(
                color: Pallete.blueColor,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Routes.hashtagScreenRoute(word),
                    ),
                  );
                }),
        );
      } else if (word.startsWith('https://') || word.startsWith('www.')) {
        textSpans.add(
          TextSpan(
            text: '$word ',
            style: const TextStyle(
              color: Pallete.blueColor,
            ),
          ),
        );
      } else {
        textSpans.add(
          TextSpan(
            text: '$word ',
            style: const TextStyle(
              color: Pallete.whiteColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      }
    });
    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}
