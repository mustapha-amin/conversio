import 'package:conversio/pallette.dart';
import 'package:conversio/screens/auth/signup.dart';
import 'package:conversio/screens/auth/user_profile.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ValueNotifier<bool> isObscure = ValueNotifier<bool>(true);

  void toggleObscure() {
    isObscure.value = !isObscure.value;
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
              Text("Welcome back",
                  style: kTextStyle(
                    context: context,
                    size: 25.sp,
                    fontWeight: FontWeight.bold,
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: TextFormField(
                      style: kTextStyle(context: context, size: 15),
                      keyboardType: TextInputType.emailAddress,
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
                  ),
                  ValueListenableBuilder(
                      valueListenable: isObscure,
                      builder: (context, value, child) {
                        return TextFormField(
                          style: kTextStyle(context: context, size: 15),
                          obscureText: value,
                          decoration: InputDecoration(
                            hintText: "password",
                            hintStyle: GoogleFonts.raleway(
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                toggleObscure();
                              },
                              icon: Icon(value
                                  ? Icons.visibility
                                  : Icons.visibility_off),
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
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const UserProfile();
                  }));
                },
                child: const Text("Log in"),
              ),
              RichText(
                text: TextSpan(
                  text: "Don't have an account?",
                  style: kTextStyle(context: context, size: 12.sp),
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return const SignUpScreen();
                          }));
                        },
                      style: kTextStyle(
                          context: context,
                          size: 12.sp,
                          color: AppColors.accent),
                      text: " Sign up",
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
