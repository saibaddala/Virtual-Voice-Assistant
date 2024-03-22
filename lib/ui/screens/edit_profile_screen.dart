import 'dart:io';
import 'package:flutter/material.dart';
import 'package:titer/backend/providers.dart';
import 'package:titer/models/user_model.dart';
import 'package:titer/ui/constants/pallete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:titer/ui/custom_widgets/image_picker.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController bioController;
  File? profilePicFile;
  File? bannerPicFile;
  @override
  void initState() {
    nameController = TextEditingController(
        text: ref.read(currentUserDetailsProvider).value!.name);
    bioController = TextEditingController(
        text: ref.read(currentUserDetailsProvider).value!.bio);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void selectProfilePic() async {
    final File? file = await pickImage();
    if (file != null) {
      setState(() {
        profilePicFile = file;
      });
    }
  }

  void selectBannerPic() async {
    final File? file = await pickImage();
    if (file != null) {
      setState(() {
        bannerPicFile = file;
      });
    }
  }

  void updateProfile({required String name, required String bio}) async {
    String profilePicUrl = '';
    String bannerPicUrl = '';
    final storageController = ref.read(storageControllerProvider);
    if (profilePicFile != null) {
      final url =
          await storageController.updateProfilePic(profilePic: profilePicFile!);
      profilePicUrl = url;
    }
    if (bannerPicFile != null) {
      final url =
          await storageController.updateBannerPic(bannerPic: bannerPicFile!);
      bannerPicUrl = url;
    }
    final UserModel? user = ref.watch(currentUserDetailsProvider).value;
    // ignore: use_build_context_synchronously
    ref.read(userControllerProvider).updateUserProfile(
          userModel: user!.copyWith(name: name, bio: bio),
          context: context,
          profilePicUrl: profilePicUrl,
          bannerPicUrl: bannerPicUrl,
        );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(currentUserDetailsProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              updateProfile(
                name: nameController.text,
                bio: bioController.text,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: selectBannerPic,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: bannerPicFile != null
                        ? Image.file(
                            bannerPicFile!,
                            fit: BoxFit.fitWidth,
                          )
                        : user!.bannerPic.isEmpty
                            ? Container(
                                color: Pallete.blueColor,
                              )
                            : Image.network(
                                user.bannerPic,
                                fit: BoxFit.fitWidth,
                              ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: GestureDetector(
                    onTap: selectProfilePic,
                    child: profilePicFile != null
                        ? CircleAvatar(
                            backgroundImage: FileImage(profilePicFile!),
                            radius: 40,
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(user!.profilePic),
                            radius: 40,
                          ),
                  ),
                ),
              ],
            ),
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Name',
              contentPadding: EdgeInsets.all(18),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: bioController,
            decoration: const InputDecoration(
              hintText: 'Bio',
              contentPadding: EdgeInsets.all(18),
            ),
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}
