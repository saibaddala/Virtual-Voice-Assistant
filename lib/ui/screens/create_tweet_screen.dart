import 'dart:io';
import 'package:flutter/material.dart';
import 'package:titer/backend/providers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:titer/ui/constants/pallete.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:titer/ui/custom_widgets/loading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:titer/ui/constants/assets_constants.dart';
import 'package:titer/ui/custom_widgets/image_picker.dart';
import 'package:titer/ui/custom_widgets/round_button.dart';

class CreateTweetScreen extends ConsumerStatefulWidget {
  const CreateTweetScreen({super.key});

  @override
  ConsumerState<CreateTweetScreen> createState() => _CreateTweetScreenState();
}

class _CreateTweetScreenState extends ConsumerState<CreateTweetScreen> {
  final TextEditingController tweetTextController = TextEditingController();
  List<File> imagesPicked = [];

  @override
  void dispose() {
    tweetTextController.dispose();
    super.dispose();
  }

  void pickImage() async {
    imagesPicked = await pickImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tweetController = ref.read(tweetControllerProvider.notifier);
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final bool isLoading = ref.watch(tweetControllerProvider);
    return isLoading
        ? const Scaffold(body: LoadingPage())
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                RoundedButton(
                  text: "Tweet",
                  backgroundColor: Pallete.blueColor,
                  textColor: Pallete.whiteColor,
                  onTap: () {
                    tweetController.shareTweet(
                      uid: currentUser!.uid,
                      images: imagesPicked,
                      text: tweetTextController.text,
                      context: context,
                      repliedToTweetId: '',
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            currentUser!.profilePic,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: tweetTextController,
                            maxLines: null,
                            decoration: const InputDecoration(
                              hintText: "What's happening??",
                              hintStyle: TextStyle(color: Colors.white30),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (imagesPicked.isNotEmpty)
                      CarouselSlider(
                        items: imagesPicked
                            .map(
                              (file) => Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Image.file(file),
                              ),
                            )
                            .toList(),
                        options: CarouselOptions(
                          height: 400,
                          enableInfiniteScroll: false,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      pickImage();
                    },
                    child: SvgPicture.asset(
                      AssetsConstants.galleryIcon,
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () {},
                    child: SvgPicture.asset(
                      AssetsConstants.gifIcon,
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () {},
                    child: SvgPicture.asset(
                      AssetsConstants.emojiIcon,
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
