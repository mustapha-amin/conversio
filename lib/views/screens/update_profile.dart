import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';
import '../../models/user.dart';
import '../../pallette.dart';
import '../../services/auth_service.dart';
import '../../services/database.dart';
import '../../utils/spacing.dart';
import '../../utils/textstyle.dart';
import 'home.dart';

class UpdateProfile extends StatefulWidget {
  ConversioUser? user;
  UpdateProfile({this.user, super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
  void initState() {
    usernameController.text = widget.user!.name!;
    bioController.text = widget.user!.bio!;
    emailController.text = widget.user!.email!;
    super.initState();
  }

  void updateProfile() {
    if (usernameController.text != widget.user!.name!) {
      DatabaseService().updateUserName(usernameController.text);
    }

    if (bioController.text != widget.user!.bio) {
      DatabaseService().updateBio(bioController.text);
    }

    if (emailController.text != widget.user!.email) {
      DatabaseService().updateEmail(emailController.text);
    }

    if (selectedImage != null) {
      DatabaseService().updateProfilePic(selectedImage!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Text("Update profile"),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "cancel",
                style: kTextStyle(
                  context: context,
                  size: 13,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        resizeToAvoidBottomInset: true,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        selectedImage != null
                            ? CircleAvatar(
                              radius: 20.w,
                              backgroundImage: FileImage(selectedImage!),
                            )
                            : CircleAvatar(
                              radius: 20.w,
                              backgroundImage: NetworkImage(
                                widget.user!.profileImgUrl!,
                              ),
                            ),
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
                              icon: Icon(Icons.camera_alt, size: 8.w),
                              onPressed: selectImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                    addVerticalSpacing(10),
                    TextFormField(
                      style: kTextStyle(context: context, size: 12),
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: "username",
                        hintStyle: GoogleFonts.raleway(color: Colors.grey),
                      ),
                      validator:
                          (val) =>
                              val!.isEmpty ? "Username cannot be empty" : null,
                    ),
                    addVerticalSpacing(5),
                    TextFormField(
                      style: kTextStyle(context: context, size: 12),
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "email",
                        hintStyle: GoogleFonts.raleway(color: Colors.grey),
                      ),
                      validator:
                          (val) =>
                              val!.isEmpty ? "Email cannot be empty" : null,
                    ),
                    addVerticalSpacing(5),
                    TextFormField(
                      maxLines: 2,
                      style: kTextStyle(context: context, size: 12),
                      controller: bioController,
                      decoration: InputDecoration(
                        hintText: "bio",
                        hintStyle: GoogleFonts.raleway(color: Colors.grey),
                      ),
                      validator:
                          (val) => val!.isEmpty ? "Bio cannot be empty" : null,
                    ),
                    addVerticalSpacing(20.h),
                    SizedBox(
                      width: 100.w,
                      child: ElevatedButton(
                        onPressed: () {
                          updateProfile();
                          Navigator.pop(context);
                        },
                        child: const Text("Update"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
