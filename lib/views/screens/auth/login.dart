import 'package:conversio/pallette.dart';
import 'package:conversio/providers/auth_provider.dart';
import 'package:conversio/services/database.dart';
import 'package:conversio/utils/enums.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:conversio/views/screens/auth/user_profile.dart';
import 'package:conversio/views/screens/auth/wrapper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../providers/auth_status.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formkey = GlobalKey<FormState>();
  ValueNotifier<bool> isObscure = ValueNotifier<bool>(true);

  void toggleObscure() {
    isObscure.value = !isObscure.value;
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: authProvider.loadingStatus == true
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Welcome back",
                      style: kTextStyle(
                        context: context,
                        size: 25.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: TextFormField(
                            controller: _emailController,
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
                            validator: (val) =>
                                val!.isEmpty ? "please enter your email" : null,
                          ),
                        ),
                        ValueListenableBuilder(
                            valueListenable: isObscure,
                            builder: (context, value, child) {
                              return TextFormField(
                                controller: _passwordController,
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
                                validator: (val) => val!.isEmpty
                                    ? "please enter your password"
                                    : null,
                              );
                            }),
                      ],
                    ),
                    ElevatedButton(
                      style:
                          Theme.of(context).elevatedButtonTheme.style!.copyWith(
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
                        _formkey.currentState!.validate()
                            ? authProvider.logIn(
                                context,
                                _emailController.text,
                                _passwordController.text,
                              )
                            : null;
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
                                context.read<AuthStatus>().toggle();
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
