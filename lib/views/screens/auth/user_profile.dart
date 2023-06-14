import 'package:conversio/models/user.dart';
import 'package:conversio/pallette.dart';
import 'package:conversio/providers/theme_provider.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:conversio/services/database.dart';
import 'package:conversio/utils/spacing.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';
import '../home.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? imageError = 'select an image';

  File? selectedImage;

  Future<void> selectImage() async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService databaseService = DatabaseService();
    return SafeArea(
      child: AuthService.user!.displayName != null
          ? const Home()
          : Scaffold(
              resizeToAvoidBottomInset: false,
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Set up your profile",
                        style: kTextStyle(
                          context: context,
                          size: 23.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      addVerticalSpacing(10),
                      Stack(
                        children: [
                          CircleAvatar(
                              radius: 20.w,
                              backgroundImage: selectedImage != null
                                  ? FileImage(
                                      selectedImage!,
                                    )
                                  : null,
                              child: selectedImage == null
                                  ? Icon(
                                      Icons.person,
                                      size: 20.w,
                                      color: Colors.grey,
                                    )
                                  : null),
                          Positioned(
                            bottom: -4,
                            right: -2,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 10.w,
                                maxHeight: 10.h,
                              ),
                              child: IconButton(
                                color: Colors.white,
                                style: IconButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                ),
                                icon: Icon(
                                  Icons.camera_alt,
                                  size: 8.w,
                                ),
                                onPressed: selectImage,
                              ),
                            ),
                          )
                        ],
                      ),
                      addVerticalSpacing(10),
                      TextFormField(
                        style: kTextStyle(context: context, size: 12.sp),
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: "username",
                          hintStyle: GoogleFonts.raleway(
                            color: Colors.grey,
                          ),
                        ),
                        validator: (val) =>
                            val!.isEmpty ? "Please enter your user name" : null,
                      ),
                      addVerticalSpacing(5),
                      TextFormField(
                        style: kTextStyle(context: context, size: 12.sp),
                        controller: bioController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: "bio",
                          hintStyle: GoogleFonts.raleway(
                            color: Colors.grey,
                          ),
                        ),
                        validator: (val) =>
                            val!.isEmpty ? "Please enter your user bio" : null,
                      ),
                      addVerticalSpacing(20.h),
                      SizedBox(
                        width: 100.w,
                        child: ElevatedButton(
                          onPressed: () {
                            formKey.currentState!.validate() &&
                                    selectedImage != null
                                ? databaseService
                                    .createUser(ConversioUser(
                                      id: AuthService.userid,
                                      name: usernameController.text.trim(),
                                      email: AuthService.user!.email,
                                      bio: bioController.text.trim(),
                                      profileImgUrl: selectedImage!.path,
                                    ))
                                    .whenComplete(() =>
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return const Home();
                                        })))
                                : selectedImage == null
                                    ? ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                        SnackBar(
                                          content: Text(imageError!),
                                        ),
                                      )
                                    : null;
                          },
                          child: const Text("Proceed"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
