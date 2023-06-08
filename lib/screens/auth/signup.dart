import 'package:conversio/pallette.dart';
import 'package:conversio/utils/spacing.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  ValueNotifier<bool> isObscureA = ValueNotifier<bool>(true);
  ValueNotifier<bool> isObscureB = ValueNotifier<bool>(true);

  void toggleObscureA() {
    isObscureA.value = !isObscureA.value;
  }

  void toggleObscureB() {
    isObscureB.value = !isObscureB.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Create an account",
                  style: kTextStyle(
                    context: context,
                    size: 25.sp,
                    fontWeight: FontWeight.bold,
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    style: kTextStyle(context: context, size: 15),
                    decoration: InputDecoration(
                      hintText: "email",
                      hintStyle: GoogleFonts.raleway(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  addVerticalSpacing(10),
                  ValueListenableBuilder(
                      valueListenable: isObscureA,
                      builder: (context, value, child) {
                        return TextFormField(
                          obscureText: value,
                          style: kTextStyle(context: context, size: 15),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                toggleObscureA();
                              },
                              icon: Icon(value
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            hintText: "password",
                            hintStyle: GoogleFonts.raleway(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        );
                      }),
                  addVerticalSpacing(10),
                  ValueListenableBuilder(
                      valueListenable: isObscureB,
                      builder: (context, value, child) {
                        return TextFormField(
                          obscureText: value,
                          style: kTextStyle(context: context, size: 15),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                toggleObscureB();
                              },
                              icon: Icon(value
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            hintText: "confirm password",
                            hintStyle: GoogleFonts.raleway(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        );
                      }),
                ],
              ),
              ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                      minimumSize: MaterialStatePropertyAll(
                        Size(100.w, 10.h),
                      ),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                onPressed: () {},
                child: const Text("Create account"),
              ),
              RichText(
                text: TextSpan(
                  text: "Already have an account?",
                  style: kTextStyle(context: context, size: 12.sp),
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return const LoginScreen();
                          }));
                        },
                      style: kTextStyle(
                          context: context,
                          size: 12.sp,
                          color: AppColors.accent),
                      text: " Sign in",
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
