import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FullScreenImage extends StatelessWidget {
  String? imgUrl;
  String? heroTag;
  FullScreenImage({this.imgUrl, this.heroTag, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
            tooltip: 'update picture',
          ),
        ],
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
                imgUrl!,
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
