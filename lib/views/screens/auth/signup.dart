import 'package:conversio/pallette.dart';
import 'package:conversio/providers/auth_provider.dart';
import 'package:conversio/utils/spacing.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../providers/auth_status.dart';
import '../../../utils/enums.dart';
import 'login.dart';
import 'wrapper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  final formKey = GlobalKey<FormState>();
  ValueNotifier<bool> isObscureA = ValueNotifier<bool>(true);
  ValueNotifier<bool> isObscureB = ValueNotifier<bool>(true);

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  void toggleObscureA() {
    isObscureA.value = !isObscureA.value;
  }

  void toggleObscureB() {
    isObscureB.value = !isObscureB.value;
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
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Create an account",
                      style: kTextStyle(
                        context: context,
                        size: 25.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _emailController,
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
                          validator: (val) =>
                              val!.isEmpty ? "please enter your email" : null,
                        ),
                        addVerticalSpacing(10),
                        ValueListenableBuilder(
                            valueListenable: isObscureA,
                            builder: (context, value, child) {
                              return TextFormField(
                                controller: _passwordController,
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
                                validator: (val) => val!.isEmpty
                                    ? "please enter your password"
                                    : null,
                              );
                            }),
                        addVerticalSpacing(10),
                        ValueListenableBuilder(
                            valueListenable: isObscureB,
                            builder: (context, value, child) {
                              return TextFormField(
                                controller: _confirmPasswordController,
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
                                validator: (val) => val!.isEmpty
                                    ? "please confirm your password"
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
                        formKey.currentState!.validate()
                            ? authProvider.createAccount(
                                context,
                                _emailController.text,
                                _passwordController.text,
                              )
                            : null;
                      },
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
                                context.read<AuthStatus>().toggle();
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
