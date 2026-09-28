import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/care_background.dart';
import '../widgets/care_logo.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ======================================================
  // CONTROLLERS
  // ======================================================

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;

  // ======================================================
  // PHP API
  //
  // Flutter Web is running on the SAME laptop as XAMPP.
  // ======================================================

  static const String registerUrl =
      'http://192.168.1.7/hyundai_care_plus_api/register.php';

  // ======================================================
  // REGISTER
  // ======================================================

  Future<void> register() async {
    debugPrint('REGISTER BUTTON PRESSED');

    // ----------------------------------------------------
    // VALIDATION
    // ----------------------------------------------------

    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage('Please fill all fields');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      showMessage('Please enter a valid email address');
      return;
    }

    if (phone.length < 10) {
      showMessage('Please enter a valid phone number');
      return;
    }

    if (password.length < 6) {
      showMessage(
        'Password must contain at least 6 characters',
      );
      return;
    }

    if (password != confirmPassword) {
      showMessage('Passwords do not match');
      return;
    }

    // ----------------------------------------------------
    // LOADING
    // ----------------------------------------------------

    setState(() {
      isLoading = true;
    });

    try {
      debugPrint('REGISTER URL: $registerUrl');

      // --------------------------------------------------
      // HTTP POST
      // --------------------------------------------------

      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'phone': phone,
          'email': email,
          'password': password,
        }),
      );

      // --------------------------------------------------
      // DEBUG
      // --------------------------------------------------

      debugPrint(
        'REGISTER STATUS: ${response.statusCode}',
      );

      debugPrint(
        'REGISTER RESPONSE: ${response.body}',
      );

      if (!mounted) return;

      // --------------------------------------------------
      // SERVER ERROR
      // --------------------------------------------------

      if (response.statusCode != 200) {
        showMessage(
          'Server error: ${response.statusCode}',
        );
        return;
      }

      // --------------------------------------------------
      // EMPTY RESPONSE
      // --------------------------------------------------

      if (response.body.trim().isEmpty) {
        showMessage(
          'Server returned an empty response',
        );
        return;
      }

      // --------------------------------------------------
      // JSON RESPONSE
      // --------------------------------------------------

      dynamic decoded;

      try {
        decoded = jsonDecode(response.body);
      } catch (e) {
        debugPrint(
          'REGISTER JSON ERROR: $e',
        );

        showMessage(
          'Invalid response from server',
        );

        return;
      }

      if (decoded is! Map<String, dynamic>) {
        showMessage(
          'Unexpected server response',
        );
        return;
      }

      final bool success =
          decoded['success'] == true;

      // --------------------------------------------------
      // SUCCESS
      // --------------------------------------------------

      if (success) {
        final String message =
            decoded['message']?.toString() ??
                'Account created successfully';

        showMessage(
          '$message 🎉',
        );

        // Give the user a moment to see success.
        await Future.delayed(
          const Duration(
            milliseconds: 900,
          ),
        );

        if (!mounted) return;

        // Go to LOGIN.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const LoginScreen(),
          ),
        );

        return;
      }

      // --------------------------------------------------
      // PHP / MYSQL ERROR
      // --------------------------------------------------

      final String message =
          decoded['message']?.toString() ??
              'Registration failed';

      final dynamic error =
          decoded['error'];

      if (error != null &&
          error.toString().trim().isNotEmpty) {
        showMessage(
          '$message: ${error.toString()}',
        );
      } else {
        showMessage(message);
      }
    } catch (e) {
      debugPrint(
        'REGISTER ERROR: $e',
      );

      if (!mounted) return;

      showMessage(
        'Unable to connect to server',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ======================================================
  // MESSAGE
  // ======================================================

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 4),
        ),
      );
  }

  // ======================================================
  // DISPOSE
  // ======================================================

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  // ======================================================
  // BUILD
  // ======================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF4F8FF),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF002C5F),

        foregroundColor:
            Colors.white,

        elevation: 0,

        title: const Text(
          'Create Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: CareBackground(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 28,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 10),

                // ==================================================
                // LOGO
                // ==================================================

                const Center(
                  child: CareLogo(
                    size: 90,
                  ),
                ),

                const SizedBox(height: 18),

                const Center(
                  child: Text(
                    'Hyundai Care+',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight.w800,
                      color:
                          Color(0xFF002C5F),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: Text(
                    'Create your account',
                    style: TextStyle(
                      fontSize: 15,
                      color:
                          Colors.grey.shade600,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // ==================================================
                // NAME
                // ==================================================

                _buildTextField(
                  controller:
                      nameController,
                  label: 'Full Name',
                  hint:
                      'Enter your full name',
                  icon:
                      Icons.person_outline,
                ),

                const SizedBox(height: 16),

                // ==================================================
                // PHONE
                // ==================================================

                _buildTextField(
                  controller:
                      phoneController,
                  label:
                      'Phone Number',
                  hint:
                      'Enter your phone number',
                  icon:
                      Icons.phone_outlined,
                  keyboardType:
                      TextInputType.phone,
                ),

                const SizedBox(height: 16),

                // ==================================================
                // EMAIL
                // ==================================================

                _buildTextField(
                  controller:
                      emailController,
                  label: 'Email',
                  hint:
                      'Enter your email',
                  icon:
                      Icons.email_outlined,
                  keyboardType:
                      TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                // ==================================================
                // PASSWORD
                // ==================================================

                _buildPasswordField(
                  controller:
                      passwordController,
                  label: 'Password',
                  hide:
                      hidePassword,
                  onToggle: () {
                    setState(() {
                      hidePassword =
                          !hidePassword;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // CONFIRM PASSWORD
                // ==================================================

                _buildPasswordField(
                  controller:
                      confirmPasswordController,
                  label:
                      'Confirm Password',
                  hide:
                      hideConfirmPassword,
                  onToggle: () {
                    setState(() {
                      hideConfirmPassword =
                          !hideConfirmPassword;
                    });
                  },
                ),

                const SizedBox(height: 28),

                // ==================================================
                // CREATE ACCOUNT BUTTON
                // ==================================================

                SizedBox(
                  width:
                      double.infinity,
                  height: 56,

                  child: ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : register,

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                        0xFF002C5F,
                      ),

                      foregroundColor:
                          Colors.white,

                      elevation: 5,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),

                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,

                            child:
                                CircularProgressIndicator(
                              color:
                                  Colors.white,
                              strokeWidth:
                                  2.5,
                            ),
                          )
                        : const Text(
                            'Create Account',
                            style:
                                TextStyle(
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // LOGIN
                // ==================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color:
                            Colors.grey.shade700,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LoginScreen(),
                          ),
                        );
                      },

                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color:
                              Color(0xFF315D9B),
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ==================================================
                // FOOTER
                // ==================================================

                const Center(
                  child: Text(
                    'Drive Safe. We Care. 💙',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ======================================================
  // TEXT FIELD
  // ======================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,

      keyboardType:
          keyboardType,

      decoration:
          InputDecoration(
        labelText: label,
        hintText: hint,

        prefixIcon: Icon(
          icon,
          color:
              const Color(0xFF315D9B),
        ),

        filled: true,

        fillColor:
            Colors.white,

        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide:
              BorderSide.none,
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide:
              BorderSide(
            color:
                Colors.grey.shade300,
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide:
              const BorderSide(
            color:
                Color(0xFF002C5F),
            width: 2,
          ),
        ),
      ),
    );
  }

  // ======================================================
  // PASSWORD FIELD
  // ======================================================

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool hide,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,

      obscureText: hide,

      decoration:
          InputDecoration(
        labelText: label,

        hintText:
            'Enter your password',

        prefixIcon:
            const Icon(
          Icons.lock_outline,
          color:
              Color(0xFF315D9B),
        ),

        suffixIcon:
            IconButton(
          onPressed: onToggle,

          icon: Icon(
            hide
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,

            color:
                const Color(
              0xFF315D9B,
            ),
          ),
        ),

        filled: true,

        fillColor:
            Colors.white,

        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide:
              BorderSide.none,
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide:
              BorderSide(
            color:
                Colors.grey.shade300,
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide:
              const BorderSide(
            color:
                Color(0xFF002C5F),
            width: 2,
          ),
        ),
      ),
    );
  }
}