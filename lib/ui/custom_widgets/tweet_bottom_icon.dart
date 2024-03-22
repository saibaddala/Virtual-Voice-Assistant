import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:titer/ui/constants/pallete.dart';

class TweetBottomIcon extends StatelessWidget {
  final String iconPath;
  final String val;
  final VoidCallback onTap;
  const TweetBottomIcon({
    super.key,
    required this.iconPath,
    required this.val,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            width: 17,
            height: 17,
            iconPath,
            colorFilter: const ColorFilter.mode(
              Pallete.greyColor,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 5),
          Text(val),
        ],
      ),
    );
  }
}
