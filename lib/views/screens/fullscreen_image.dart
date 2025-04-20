import 'package:conversio/models/user.dart';
import 'package:conversio/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FullScreenImage extends StatelessWidget {
  ConversioUser? user;
  String? heroTag;
  FullScreenImage({this.user, this.heroTag, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Hero(
        transitionOnUserGestures: true,
        tag: heroTag!,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Center(
            child: SizedBox(
              height: 60.h,
              width: 100.w,
              child: Image.network(
                user!.profileImgUrl!,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
