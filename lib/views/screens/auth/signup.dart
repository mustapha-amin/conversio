import 'package:conversio/pallette.dart';
import 'package:conversio/providers/auth_provider.dart';
import 'package:conversio/utils/spacing.dart';
import 'package:conversio/utils/textstyle.dart';
import 'package:conversio/views/shared/loader.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  FocusNode focusNode = FocusNode();
  FocusNode focusNode2 = FocusNode();
  ValueNotifier<bool> isObscureA = ValueNotifier<bool>(true);
  ValueNotifier<bool> isObscureB = ValueNotifier<bool>(true);
  ScrollController scrollController = ScrollController();

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
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body:
          authProvider.loadingStatus == true
              ? const Loader()
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 50,
                      children: [
                        Image.asset('assets/signup.png', height: 200),
                        Text(
                          "Create an account",
                          style: kTextStyle(
                            context: context,
                            size: 25,
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
                              textInputAction: TextInputAction.next,
                              onSaved: (_) {
                                scrollController.jumpTo(
                                  scrollController.position.maxScrollExtent,
                                );
                              },
                              decoration: InputDecoration(
                                hintText: "e.g johndoe@gmail.com",
                                hintStyle: GoogleFonts.raleway(
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator:
                                  (val) =>
                                      val!.isEmpty
                                          ? "please enter your email"
                                          : null,
                            ),
                            addVerticalSpacing(10),
                            ValueListenableBuilder(
                              valueListenable: isObscureA,
                              builder: (context, value, child) {
                                return TextFormField(
                                  controller: _passwordController,
                                  focusNode: focusNode,
                                  obscureText: value,
                                  textInputAction: TextInputAction.next,
                                  style: kTextStyle(context: context, size: 15),
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        toggleObscureA();
                                      },
                                      icon: Icon(
                                        value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                    ),
                                    hintText: "password",
                                    hintStyle: GoogleFonts.raleway(
                                      color: Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  validator:
                                      (val) =>
                                          val!.isEmpty
                                              ? "please enter your password"
                                              : null,
                                );
                              },
                            ),
                            addVerticalSpacing(10),
                            ValueListenableBuilder(
                              valueListenable: isObscureB,
                              builder: (context, value, child) {
                                return TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: value,
                                  focusNode: focusNode2,
                                  style: kTextStyle(context: context, size: 15),
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        toggleObscureB();
                                      },
                                      icon: Icon(
                                        value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                    ),
                                    hintText: "confirm password",
                                    hintStyle: GoogleFonts.raleway(
                                      color: Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  validator:
                                      (val) =>
                                          val! != _passwordController.text
                                              ? "passwords do not match"
                                              : null,
                                );
                              },
                            ),
                            addVerticalSpacing(30),
                            ElevatedButton(
                              style: Theme.of(
                                context,
                              ).elevatedButtonTheme.style!.copyWith(
                                minimumSize: WidgetStatePropertyAll(
                                  Size(100.w, 50),
                                ),
                                shape: WidgetStatePropertyAll(
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
                            addVerticalSpacing(30),
                            RichText(
                              text: TextSpan(
                                text: "Already have an account?",
                                style: kTextStyle(context: context, size: 14),
                                children: [
                                  TextSpan(
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            context.read<AuthStatus>().toggle();
                                          },
                                    style: kTextStyle(
                                      context: context,
                                      size: 14,
                                      color: AppColors.accent,
                                    ),
                                    text: " Sign in",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
