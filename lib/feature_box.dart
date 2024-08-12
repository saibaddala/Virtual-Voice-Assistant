import 'package:flutter/material.dart';
import 'package:virtual_voice_assistant/pallete.dart';

class FeatureBox extends StatelessWidget {
  final String headerText;
  final String contentText;
  final Color color;

  const FeatureBox({
    super.key,
    required this.headerText,
    required this.contentText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20).copyWith(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headerText,
              style: const TextStyle(
                fontFamily: 'Cera Pro',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Pallete.blackColor,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              contentText,
              style: const TextStyle(
                fontFamily: 'Cera Pro',
                color: Pallete.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
