import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home_screen.dart';
import 'register_screen.dart';
import '../widgets/care_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ============================================================
  // API
  // ============================================================

  static const String loginApi =
      'http://192.168.1.7/hyundai_care_plus_api/login.php';

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  // ============================================================
  // STATE
  // ============================================================

  bool isLoading = false;
  bool obscurePassword = true;

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> login() async {
    FocusScope.of(context).unfocus();

    final String email =
        emailController.text.trim();

    final String password =
        passwordController.text;

    // ----------------------------------------------------------
    // VALIDATION
    // ----------------------------------------------------------

    if (email.isEmpty) {
      showMessage(
        'Please enter your email address.',
      );
      return;
    }

    if (!isValidEmail(email)) {
      showMessage(
        'Please enter a valid email address.',
      );
      return;
    }

    if (password.isEmpty) {
      showMessage(
        'Please enter your password.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      debugPrint(
        'LOGIN EMAIL: $email',
      );

      final response = await http.post(
        Uri.parse(loginApi),
        headers: const {
          'Content-Type':
              'application/json',
          'Accept':
              'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      debugPrint(
        'LOGIN STATUS: ${response.statusCode}',
      );

      debugPrint(
        'LOGIN RESPONSE: ${response.body}',
      );

      if (!mounted) return;

      // --------------------------------------------------------
      // HTTP ERROR
      // --------------------------------------------------------

      if (response.statusCode != 200) {
        showMessage(
          'Server error: ${response.statusCode}',
        );
        return;
      }

      if (response.body.trim().isEmpty) {
        showMessage(
          'The server returned an empty response.',
        );
        return;
      }

      // --------------------------------------------------------
      // JSON
      // --------------------------------------------------------

      dynamic decoded;

      try {
        decoded = jsonDecode(
          response.body,
        );
      } catch (e) {
        debugPrint(
          'LOGIN JSON ERROR: $e',
        );

        showMessage(
          'Invalid response from server.',
        );
        return;
      }

      if (decoded is! Map) {
        showMessage(
          'Unexpected response from server.',
        );
        return;
      }

      final Map<String, dynamic> data =
          Map<String, dynamic>.from(
        decoded,
      );

      // --------------------------------------------------------
      // LOGIN FAILED
      // --------------------------------------------------------

      if (data['success'] != true) {
        showMessage(
          data['message']?.toString() ??
              'Invalid email or password.',
        );
        return;
      }

      // --------------------------------------------------------
      // CUSTOMER
      // --------------------------------------------------------

      final dynamic customerData =
          data['customer'];

      if (customerData is! Map) {
        showMessage(
          'Customer information was not returned.',
        );
        return;
      }

      final Map<String, dynamic> customer =
          Map<String, dynamic>.from(
        customerData,
      );

      // --------------------------------------------------------
      // REAL CUSTOMER ID
      // --------------------------------------------------------

      final int? customerId =
          int.tryParse(
        customer['customer_id']
                ?.toString() ??
            '',
      );

      if (customerId == null ||
          customerId <= 0) {
        showMessage(
          'Invalid customer account information.',
        );
        return;
      }

      // --------------------------------------------------------
      // CUSTOMER DETAILS
      // --------------------------------------------------------

      final String name =
          customer['name']
                  ?.toString()
                  .trim() ??
              '';

      final String phone =
          customer['phone']
                  ?.toString()
                  .trim() ??
              '';

      final String customerEmail =
          customer['email']
                  ?.toString()
                  .trim()
                  .isNotEmpty ==
              true
          ? customer['email']
              .toString()
              .trim()
          : email;

      final String membership =
          customer['membership']
                  ?.toString()
                  .trim() ??
              '';

      final String status =
          customer['status']
                  ?.toString()
                  .trim()
                  .isNotEmpty ==
              true
          ? customer['status']
              .toString()
              .trim()
          : 'Active';

      debugPrint(
        'LOGGED IN CUSTOMER ID: $customerId',
      );

      debugPrint(
        'CUSTOMER NAME: $name',
      );

      // --------------------------------------------------------
      // GO TO HOME
      // --------------------------------------------------------

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomeScreen(
              customerId:
                  customerId,
              customerName:
                  name,
              customerPhone:
                  phone,
              customerEmail:
                  customerEmail,
              customerMembership:
                  membership,
              customerStatus:
                  status,
            );
          },
        ),
      );
    } catch (e) {
      debugPrint(
        'LOGIN ERROR: $e',
      );

      if (!mounted) return;

      showMessage(
        'Unable to connect to the server.',
      );
    } finally {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  // ============================================================
  // EMAIL VALIDATION
  // ============================================================

  bool isValidEmail(
    String email,
  ) {
    return RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(email);
  }

  // ============================================================
  // FORGOT PASSWORD
  // ============================================================

  void forgotPassword() {
    final TextEditingController controller =
        TextEditingController(
      text:
          emailController.text.trim(),
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title:
              const Text(
            'Reset Password',
          ),
          content:
              Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              const Text(
                'Enter your registered email address to begin password recovery.',
              ),
              const SizedBox(
                height: 18,
              ),
              TextField(
                controller:
                    controller,
                keyboardType:
                    TextInputType.emailAddress,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Email address',
                  prefixIcon:
                      Icon(
                    Icons
                        .email_outlined,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
                  const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final String email =
                    controller.text.trim();

                if (email.isEmpty ||
                    !isValidEmail(email)) {
                  showMessage(
                    'Enter a valid email address.',
                  );
                  return;
                }

                Navigator.pop(
                  dialogContext,
                );

                showMessage(
                  'Password recovery will be available soon.',
                );
              },
              child:
                  const Text(
                'Continue',
              ),
            ),
          ],
        );
      },
    ).then((_) {
      controller.dispose();
    });
  }

  // ============================================================
  // REGISTER
  // ============================================================

  void openRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const RegisterScreen(),
      ),
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void showMessage(
    String message,
  ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior:
              SnackBarBehavior.floating,
          margin:
              const EdgeInsets.all(
            16,
          ),
          duration:
              const Duration(
            seconds: 3,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
          content:
              Text(message),
        ),
      );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(
        0xFF020817,
      ),
      body:
          CareBackground(
        child:
            SafeArea(
          child:
              Center(
            child:
                SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 30,
              ),
              child:
                  ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth: 480,
                ),
                child:
                    Column(
                  children: [
                    // ==================================================
                    // THEME BUTTON
                    // ==================================================

                    Align(
                      alignment:
                          Alignment.topRight,
                      child:
                          Container(
                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white.withValues(
                            alpha:
                                0.08,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                          border:
                              Border.all(
                            color:
                                Colors.white.withValues(
                              alpha:
                                  0.12,
                            ),
                          ),
                        ),
                        child:
                            const CareThemeButton(),
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    // ==================================================
                    // BRAND
                    // ==================================================

                    Container(
                      width: 82,
                      height: 82,
                      decoration:
                          BoxDecoration(
                        shape:
                            BoxShape.circle,
                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(
                              0xFF704CFF,
                            ),
                            Color(
                              0xFF00DFFF,
                            ),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(
                              0xFF00DFFF,
                            ).withValues(
                              alpha:
                                  0.22,
                            ),
                            blurRadius:
                                28,
                          ),
                        ],
                      ),
                      child:
                          const Icon(
                        Icons
                            .directions_car_filled_rounded,
                        color:
                            Colors.white,
                        size:
                            42,
                      ),
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    const Text(
                      'HYUNDAI',
                      style:
                          TextStyle(
                        color:
                            Colors.white,
                        fontSize:
                            28,
                        fontWeight:
                            FontWeight.bold,
                        letterSpacing:
                            5,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    ShaderMask(
                      shaderCallback:
                          (bounds) {
                        return const LinearGradient(
                          colors: [
                            Color(
                              0xFFB56CFF,
                            ),
                            Color(
                              0xFF54DFFF,
                            ),
                            Color(
                              0xFF6CFFE0,
                            ),
                          ],
                        ).createShader(
                          bounds,
                        );
                      },
                      child:
                          const Text(
                        'CARE+',
                        style:
                            TextStyle(
                          color:
                              Colors.white,
                          fontSize:
                              22,
                          fontWeight:
                              FontWeight.w600,
                          letterSpacing:
                              6,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    const Text(
                      'Your Hyundai. Our Care. Always.',
                      textAlign:
                          TextAlign.center,
                      style:
                          TextStyle(
                        color:
                            Colors.white70,
                        fontSize:
                            12,
                        letterSpacing:
                            0.8,
                      ),
                    ),

                    const SizedBox(
                      height: 28,
                    ),

                    // ==================================================
                    // LOGIN CARD
                    // ==================================================

                    Container(
                      padding:
                          const EdgeInsets.all(
                        24,
                      ),
                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white.withValues(
                          alpha:
                              0.10,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          28,
                        ),
                        border:
                            Border.all(
                          color:
                              Colors.white.withValues(
                            alpha:
                                0.18,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withValues(
                              alpha:
                                  0.25,
                            ),
                            blurRadius:
                                30,
                            offset:
                                const Offset(
                              0,
                              15,
                            ),
                          ),
                        ],
                      ),
                      child:
                          Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome Back',
                            style:
                                TextStyle(
                              color:
                                  Colors.white,
                              fontSize:
                                  27,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 7,
                          ),

                          const Text(
                            'Sign in to continue to Hyundai Care+',
                            style:
                                TextStyle(
                              color:
                                  Colors.white70,
                              fontSize:
                                  13,
                            ),
                          ),

                          const SizedBox(
                            height: 25,
                          ),

                          _glassField(
                            controller:
                                emailController,
                            label:
                                'Email Address',
                            hint:
                                'Enter your email',
                            icon:
                                Icons
                                    .email_outlined,
                            keyboardType:
                                TextInputType.emailAddress,
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          _glassField(
                            controller:
                                passwordController,
                            label:
                                'Password',
                            hint:
                                'Enter your password',
                            icon:
                                Icons
                                    .lock_outline,
                            obscureText:
                                obscurePassword,
                            suffix:
                                IconButton(
                              onPressed: () {
                                setState(() {
                                  obscurePassword =
                                      !obscurePassword;
                                });
                              },
                              icon:
                                  Icon(
                                obscurePassword
                                    ? Icons
                                        .visibility_outlined
                                    : Icons
                                        .visibility_off_outlined,
                                color:
                                    Colors.white70,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 7,
                          ),

                          Align(
                            alignment:
                                Alignment.centerRight,
                            child:
                                TextButton(
                              onPressed:
                                  isLoading
                                      ? null
                                      : forgotPassword,
                              child:
                                  const Text(
                                'Forgot Password?',
                                style:
                                    TextStyle(
                                  color:
                                      Color(
                                    0xFF70E8FF,
                                  ),
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          // ==================================================
                          // LOGIN BUTTON
                          // ==================================================

                          SizedBox(
                            width:
                                double.infinity,
                            height:
                                54,
                            child:
                                DecoratedBox(
                              decoration:
                                  BoxDecoration(
                                gradient:
                                    const LinearGradient(
                                  colors: [
                                    Color(
                                      0xFF6C4CFF,
                                    ),
                                    Color(
                                      0xFF00BFFF,
                                    ),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.circular(
                                  15,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(
                                      0xFF00BFFF,
                                    ).withValues(
                                      alpha:
                                          0.25,
                                    ),
                                    blurRadius:
                                        20,
                                    offset:
                                        const Offset(
                                      0,
                                      8,
                                    ),
                                  ),
                                ],
                              ),
                              child:
                                  ElevatedButton(
                                onPressed:
                                    isLoading
                                        ? null
                                        : login,
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.transparent,
                                  disabledBackgroundColor:
                                      Colors.transparent,
                                  shadowColor:
                                      Colors.transparent,
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                      15,
                                    ),
                                  ),
                                ),
                                child:
                                    isLoading
                                        ? const SizedBox(
                                            width:
                                                24,
                                            height:
                                                24,
                                            child:
                                                CircularProgressIndicator(
                                              color:
                                                  Colors.white,
                                              strokeWidth:
                                                  2.5,
                                            ),
                                          )
                                        : const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'SIGN IN',
                                                style:
                                                    TextStyle(
                                                  color:
                                                      Colors.white,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  fontSize:
                                                      15,
                                                  letterSpacing:
                                                      1,
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    10,
                                              ),
                                              Icon(
                                                Icons
                                                    .arrow_forward_rounded,
                                                color:
                                                    Colors.white,
                                                size:
                                                    20,
                                              ),
                                            ],
                                          ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 22,
                          ),

                          // ==================================================
                          // REGISTER
                          // ==================================================

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style:
                                    TextStyle(
                                  color:
                                      Colors.white60,
                                  fontSize:
                                      13,
                                ),
                              ),
                              GestureDetector(
                                onTap:
                                    isLoading
                                        ? null
                                        : openRegister,
                                child:
                                    const Text(
                                  'Create Account',
                                  style:
                                      TextStyle(
                                    color:
                                        Color(
                                      0xFF70E8FF,
                                    ),
                                    fontSize:
                                        13,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons
                              .verified_user_outlined,
                          color:
                              Colors.white54,
                          size:
                              15,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'Secure Hyundai Care+ Login',
                          style:
                              TextStyle(
                            color:
                                Colors.white54,
                            fontSize:
                                11,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // GLASS TEXT FIELD
  // ============================================================

  Widget _glassField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return TextField(
      controller:
          controller,
      keyboardType:
          keyboardType,
      obscureText:
          obscureText,
      enabled:
          !isLoading,
      style:
          const TextStyle(
        color:
            Colors.white,
      ),
      cursorColor:
          const Color(
        0xFF70E8FF,
      ),
      decoration:
          InputDecoration(
        labelText:
            label,
        hintText:
            hint,
        labelStyle:
            const TextStyle(
          color:
              Colors.white70,
        ),
        hintStyle:
            const TextStyle(
          color:
              Colors.white38,
        ),
        prefixIcon:
            Icon(
          icon,
          color:
              Colors.white70,
        ),
        suffixIcon:
            suffix,
        filled:
            true,
        fillColor:
            Colors.white.withValues(
          alpha:
              0.08,
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              BorderSide(
            color:
                Colors.white.withValues(
              alpha:
                  0.12,
            ),
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              const BorderSide(
            color:
                Color(
              0xFF70E8FF,
            ),
            width:
                1.5,
          ),
        ),
        disabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              BorderSide(
            color:
                Colors.white.withValues(
              alpha:
                  0.08,
            ),
          ),
        ),
      ),
    );
  }
}