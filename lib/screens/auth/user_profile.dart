import 'package:conversio/pallette.dart';
import 'package:conversio/providers/theme_provider.dart';
import 'package:conversio/utils/spacing.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                    child: Icon(
                      Icons.person,
                      size: 20.w,
                      color: Colors.grey,
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    right: -2,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 10.w,
                        maxHeight: 10.h,
                      ),
                      child: IconButton(
                        color: Colors.white70,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        icon: Icon(
                          Icons.camera_alt,
                          size: 8.w,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  )
                ],
              ),
              addVerticalSpacing(10),
              TextField(
                style: kTextStyle(context: context, size: 12.sp),
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: "username",
                  hintStyle: GoogleFonts.raleway(
                    color: Colors.grey,
                  ),
                ),
              ),
              addVerticalSpacing(5),
              TextField(
                style: kTextStyle(context: context, size: 12.sp),
                controller: bioController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "bio",
                  hintStyle: GoogleFonts.raleway(
                    color: Colors.grey,
                  ),
                ),
              ),
              addVerticalSpacing(20.h),
              SizedBox(
                width: 100.w,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<ThemeProvider>().toggleTheme();
                  },
                  child: const Text("Proceed"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
