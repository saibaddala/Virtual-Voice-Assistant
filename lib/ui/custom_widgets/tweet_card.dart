import 'package:any_link_preview/any_link_preview.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:titer/backend/providers.dart';
import 'package:titer/models/tweet_model.dart';
import 'package:titer/models/user_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:titer/ui/constants/assets_constants.dart';
import 'package:titer/ui/constants/pallete.dart';
import 'package:titer/ui/constants/routes.dart';
import 'package:titer/ui/custom_widgets/tweet_bottom_panel.dart';
import 'package:titer/ui/custom_widgets/tweet_text.dart';

class TweetCard extends ConsumerStatefulWidget {
  final TweetModel tweet;
  final UserModel user;
  const TweetCard({
    super.key,
    required this.tweet,
    required this.user,
  });

  @override
  ConsumerState<TweetCard> createState() => _TweetCardState();
}

class _TweetCardState extends ConsumerState<TweetCard> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Routes.userProfileScreenRoute(
                      widget.user,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.user.profilePic,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.tweet.retweetedBy.isNotEmpty)
                      Row(
                        children: [
                          SvgPicture.asset(
                            AssetsConstants.retweetIcon,
                            width: 17,
                            height: 17,
                            colorFilter: const ColorFilter.mode(
                              Pallete.greyColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          Text(
                            ' ${widget.user.name} retweeted',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Pallete.greyColor,
                            ),
                          ),
                        ],
                      ),
                    Row(
                      children: [
                        Text(
                          widget.user.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.user.isTwitterBlue)
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: SvgPicture.asset(
                              AssetsConstants.verifiedIcon,
                              width: 18,
                              height: 18,
                              colorFilter: const ColorFilter.mode(
                                Pallete.blueColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        const SizedBox(width: 10),
                        Text(
                          '@${widget.user.uid.substring(0, 9)}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.circle_rounded,
                          size: 3,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            timeago.format(widget.tweet.tweetedAt,
                                locale: 'en_short'),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Icon(Icons.more_horiz_outlined),
                        )
                      ],
                    ),
                    if (widget.tweet.repliedTo != '')
                      ref
                          .watch(getTweetByIdProvider(widget.tweet.repliedTo))
                          .when(data: (data) {
                        final originalTweetUser =
                            ref.watch(userDetailsProvider(data.uid)).value;
                        return RichText(
                          text: TextSpan(children: [
                            const TextSpan(
                              text: 'Replying to',
                              style: TextStyle(
                                color: Pallete.greyColor,
                              ),
                            ),
                            TextSpan(
                              text: ' @${originalTweetUser!.name}',
                              style: const TextStyle(
                                color: Pallete.blueColor,
                              ),
                            ),
                          ]),
                        );
                      }, error: (error, stackTrace) {
                        return const Center(
                          child: Text("Some Error Occurred"),
                        );
                      }, loading: () {
                        return const SizedBox();
                      }),
                    TweetText(
                      text: widget.tweet.text,
                    ),
                    if (widget.tweet.tweetType == 'image')
                      Stack(
                        children: [
                          Column(
                            children: [
                              CarouselSlider(
                                items: widget.tweet.imageLinks
                                    .map(
                                      (imageLink) => Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(imageLink),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                options: CarouselOptions(
                                  viewportFraction: 1,
                                  enableInfiniteScroll: false,
                                  onPageChanged: (int index,
                                      CarouselPageChangedReason reason) {
                                    currentIndex = index;
                                    setState(() {});
                                  },
                                ),
                              ),
                              if (widget.tweet.imageLinks.length > 1)
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: widget.tweet.imageLinks
                                        .asMap()
                                        .entries
                                        .map((e) {
                                      return Container(
                                        width: 5,
                                        height: 5,
                                        margin: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(
                                              currentIndex == e.key ? .9 : .4),
                                        ),
                                      );
                                    }).toList()),
                            ],
                          )
                        ],
                      ),
                    if (widget.tweet.link.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5, right: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)),
                          child: AnyLinkPreview(
                            link: widget.tweet.link,
                          ),
                        ),
                      ),
                    TweetBottomPanel(tweet: widget.tweet),
                  ],
                ),
              ),
            )
          ],
        ),
        const Divider(),
      ],
    );
  }
}
