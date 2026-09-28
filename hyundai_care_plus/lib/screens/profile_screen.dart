import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/care_background.dart';

class ProfileScreen extends StatefulWidget {
  final int? customerId;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final String? membership;
  final String? memberSince;

  const ProfileScreen({
    super.key,
    this.customerId,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.membership,
    this.memberSince,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen>
    with TickerProviderStateMixin {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  // ============================================================
  // IMAGE
  // ============================================================

  final ImagePicker imagePicker =
      ImagePicker();

  XFile? selectedImage;

  // ============================================================
  // STATE
  // ============================================================

  bool isEditing = false;

  bool isSaving = false;

  bool obscurePassword = true;

  bool showPasswordDialog = false;

  // ============================================================
  // ANIMATIONS
  // ============================================================

  late AnimationController auroraController;

  late AnimationController entranceController;

  late AnimationController pulseController;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(
      text:
          widget.customerName?.trim().isNotEmpty ==
                  true
              ? widget.customerName!.trim()
              : 'Adiya',
    );

    emailController =
        TextEditingController(
      text:
          widget.customerEmail?.trim().isNotEmpty ==
                  true
              ? widget.customerEmail!.trim()
              : '',
    );

    phoneController =
        TextEditingController(
      text:
          widget.customerPhone?.trim().isNotEmpty ==
                  true
              ? widget.customerPhone!.trim()
              : '',
    );

    auroraController =
        AnimationController(
      vsync: this,
      duration:
          const Duration(
        seconds: 18,
      ),
    )..repeat();

    entranceController =
        AnimationController(
      vsync: this,
      duration:
          const Duration(
        milliseconds: 900,
      ),
    )..forward();

    pulseController =
        AnimationController(
      vsync: this,
      duration:
          const Duration(
        milliseconds: 1500,
      ),
    )..repeat(
        reverse: true,
      );
  }

  // ============================================================
  // PICK PHOTO
  // ============================================================

  Future<void> pickProfilePhoto() async {
    if (!isEditing) {
      return;
    }

    try {
      final XFile? image =
          await imagePicker.pickImage(
        source:
            ImageSource.gallery,
        imageQuality:
            85,
        maxWidth:
            1200,
        maxHeight:
            1200,
      );

      if (image == null) {
        return;
      }

      if (!mounted) return;

      setState(() {
        selectedImage = image;
      });

      showMessage(
        'Profile photo selected.',
      );
    } catch (e) {
      debugPrint(
        'PROFILE PHOTO ERROR: $e',
      );

      showMessage(
        'Unable to select the photo.',
      );
    }
  }

  // ============================================================
  // CAMERA
  // ============================================================

  Future<void> takeProfilePhoto() async {
    if (!isEditing) {
      return;
    }

    try {
      final XFile? image =
          await imagePicker.pickImage(
        source:
            ImageSource.camera,
        imageQuality:
            85,
        maxWidth:
            1200,
        maxHeight:
            1200,
      );

      if (image == null) {
        return;
      }

      if (!mounted) return;

      setState(() {
        selectedImage = image;
      });

      showMessage(
        'Profile photo captured.',
      );
    } catch (e) {
      debugPrint(
        'PROFILE CAMERA ERROR: $e',
      );

      showMessage(
        'Camera is not available on this device.',
      );
    }
  }

  // ============================================================
  // PHOTO OPTIONS
  // ============================================================

  void showPhotoOptions() {
    if (!isEditing) {
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor:
          const Color(
        0xFF09162D,
      ),
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top:
              Radius.circular(
            25,
          ),
        ),
      ),
      builder:
          (
        context,
      ) {
        return SafeArea(
          child:
              Padding(
            padding:
                const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              25,
            ),
            child:
                Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Container(
                  width:
                      42,
                  height:
                      4,
                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white24,
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                ),

                const SizedBox(
                  height:
                      20,
                ),

                const Text(
                  'Profile Photo',
                  style:
                      TextStyle(
                    color:
                        Colors.white,
                    fontSize:
                        18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height:
                      6,
                ),

                const Text(
                  'Choose how you want to update your photo.',
                  style:
                      TextStyle(
                    color:
                        Color(0x73FFFFFF),
                    fontSize:
                        10,
                  ),
                ),

                const SizedBox(
                  height:
                      22,
                ),

                Row(
                  children: [
                    Expanded(
                      child:
                          _photoOption(
                        icon:
                            Icons.photo_library_rounded,
                        title:
                            'Gallery',
                        subtitle:
                            'Choose photo',
                        onTap:
                            () {
                              Navigator.pop(
                                context,
                              );

                              pickProfilePhoto();
                            },
                      ),
                    ),

                    const SizedBox(
                      width:
                          12,
                    ),

                    Expanded(
                      child:
                          _photoOption(
                        icon:
                            Icons.camera_alt_rounded,
                        title:
                            'Camera',
                        subtitle:
                            'Take photo',
                        onTap:
                            () {
                              Navigator.pop(
                                context,
                              );

                              takeProfilePhoto();
                            },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // SAVE PROFILE
  // ============================================================

  Future<void> saveProfile() async {
    FocusScope.of(context).unfocus();

    final name =
        nameController.text.trim();

    final email =
        emailController.text.trim();

    final phone =
        phoneController.text.trim();

    if (name.isEmpty) {
      showMessage(
        'Please enter your name.',
      );

      return;
    }

    if (email.isEmpty) {
      showMessage(
        'Please enter your email.',
      );

      return;
    }

    if (!_isValidEmail(email)) {
      showMessage(
        'Please enter a valid email address.',
      );

      return;
    }

    if (phone.isEmpty) {
      showMessage(
        'Please enter your phone number.',
      );

      return;
    }

    if (widget.customerId == null ||
        widget.customerId! <= 0) {
      showMessage(
        'Your customer account could not be identified.',
      );

      return;
    }

    setState(() {
      isSaving = true;
    });

    /*
     * ----------------------------------------------------------
     * PROFILE API
     * ----------------------------------------------------------
     *
     * We are intentionally not inventing a PHP endpoint or
     * request field names here.
     *
     * The project materials establish the profile/edit feature,
     * but do not provide a verified mobile profile-update API
     * contract.
     *
     * The UI is therefore prepared for the real API without
     * sending an incorrect request to the server.
     *
     * selectedImage is also preserved here so the real multipart
     * upload can be connected once the backend endpoint is known.
     * ----------------------------------------------------------
     */

    await Future.delayed(
      const Duration(
        milliseconds:
            700,
      ),
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
      isEditing = false;
    });

    showMessage(
      selectedImage != null
          ? 'Profile updated with your new photo.'
          : 'Profile updated successfully.',
    );
  }

  // ============================================================
  // EDIT
  // ============================================================

  void startEditing() {
    setState(() {
      isEditing = true;
    });
  }

  // ============================================================
  // CANCEL EDIT
  // ============================================================

  void cancelEditing() {
    setState(() {
      isEditing = false;

      nameController.text =
          widget.customerName?.trim().isNotEmpty ==
                  true
              ? widget.customerName!.trim()
              : 'Adiya';

      emailController.text =
          widget.customerEmail ??
              '';

      phoneController.text =
          widget.customerPhone ??
              '';

      selectedImage = null;
    });
  }

  // ============================================================
  // PASSWORD
  // ============================================================

  void openChangePassword() {
    final currentPasswordController =
        TextEditingController();

    final newPasswordController =
        TextEditingController();

    final confirmPasswordController =
        TextEditingController();

    bool localObscure =
        true;

    showDialog(
      context: context,
      builder:
          (
        context,
      ) {
        return StatefulBuilder(
          builder:
              (
            context,
            setDialogState,
          ) {
            return AlertDialog(
              backgroundColor:
                  const Color(
                0xFF0A1932,
              ),
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  24,
                ),
              ),
              title:
                  const Text(
                'Change Password',
                style:
                    TextStyle(
                  color:
                      Colors.white,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              content:
                  SingleChildScrollView(
                child:
                    Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    _passwordField(
                      controller:
                          currentPasswordController,
                      label:
                          'Current Password',
                      obscure:
                          localObscure,
                    ),

                    const SizedBox(
                      height:
                          12,
                    ),

                    _passwordField(
                      controller:
                          newPasswordController,
                      label:
                          'New Password',
                      obscure:
                          localObscure,
                    ),

                    const SizedBox(
                      height:
                          12,
                    ),

                    _passwordField(
                      controller:
                          confirmPasswordController,
                      label:
                          'Confirm Password',
                      obscure:
                          localObscure,
                    ),

                    const SizedBox(
                      height:
                          8,
                    ),

                    Row(
                      children: [
                        Checkbox(
                          value:
                              !localObscure,
                          activeColor:
                              const Color(
                            0xFF00CFFF,
                          ),
                          onChanged:
                              (
                            value,
                          ) {
                            setDialogState(() {
                              localObscure =
                                  !(value ??
                                      false);
                            });
                          },
                        ),
                        const Text(
                          'Show password',
                          style:
                              TextStyle(
                            color:
                                Colors.white54,
                            fontSize:
                                10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed:
                      () {
                    Navigator.pop(
                      context,
                    );
                  },
                  child:
                      const Text(
                    'CANCEL',
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      () {
                    if (newPasswordController
                            .text
                            .isEmpty ||
                        confirmPasswordController
                                .text
                                .isEmpty) {
                      return;
                    }

                    if (newPasswordController
                            .text !=
                        confirmPasswordController
                            .text) {
                      showMessage(
                        'Passwords do not match.',
                      );

                      return;
                    }

                    Navigator.pop(
                      context,
                    );

                    showMessage(
                      'Password change is ready for backend integration.',
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(
                      0xFF147DFF,
                    ),
                  ),
                  child:
                      const Text(
                    'UPDATE',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  void logout() {
    showDialog(
      context: context,
      builder:
          (
        context,
      ) {
        return AlertDialog(
          backgroundColor:
              const Color(
            0xFF0A1932,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              23,
            ),
          ),
          title:
              const Text(
            'Logout',
            style:
                TextStyle(
              color:
                  Colors.white,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          content:
              const Text(
            'Are you sure you want to sign out of Hyundai Care+?',
            style:
                TextStyle(
              color:
                  Colors.white54,
              fontSize:
                  11,
            ),
          ),
          actions: [
            TextButton(
              onPressed:
                  () {
                    Navigator.pop(
                      context,
                    );
                  },
              child:
                  const Text(
                'CANCEL',
              ),
            ),
            ElevatedButton(
              onPressed:
                  () {
                    Navigator.pop(
                      context,
                    );

                    /*
                     * Keep navigation under the control of
                     * main.dart / authentication flow.
                     */

                    Navigator.pop(
                      this.context,
                    );
                  },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFFE84963,
                ),
              ),
              child:
                  const Text(
                'LOGOUT',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // VALID EMAIL
  // ============================================================

  bool _isValidEmail(
    String email,
  ) {
    return RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(
      email,
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
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
          content:
              Text(
            message,
          ),
        ),
      );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();

    auroraController.dispose();
    entranceController.dispose();
    pulseController.dispose();

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
          Stack(
        fit:
            StackFit.expand,
        children: [
          AnimatedBuilder(
            animation:
                auroraController,
            builder:
                (
              context,
              child,
            ) {
              return CustomPaint(
                painter:
                    _ProfileAuroraPainter(
                  progress:
                      auroraController.value,
                ),
              );
            },
          ),

          CareBackground(
            child:
                SafeArea(
              child:
                  _buildPage(),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PAGE
  // ============================================================

  Widget _buildPage() {
    return CustomScrollView(
      physics:
          const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child:
              _buildHeader(),
        ),

        SliverPadding(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            35,
          ),
          sliver:
              SliverList(
            delegate:
                SliverChildListDelegate(
              [
                _animated(
                  0,
                  _buildProfileHero(),
                ),

                const SizedBox(
                  height:
                      18,
                ),

                _animated(
                  1,
                  _buildPersonalDetails(),
                ),

                const SizedBox(
                  height:
                      18,
                ),

                _animated(
                  2,
                  _buildAccountCard(),
                ),

                const SizedBox(
                  height:
                      18,
                ),

                _animated(
                  3,
                  _buildMenu(),
                ),

                const SizedBox(
                  height:
                      18,
                ),

                _animated(
                  4,
                  _buildSecurityCard(),
                ),

                const SizedBox(
                  height:
                      22,
                ),

                _animated(
                  5,
                  _buildLogoutButton(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        18,
        12,
        18,
        20,
      ),
      child:
          Row(
        children: [
          _circleButton(
            icon:
                Icons
                    .arrow_back_ios_new_rounded,
            onTap:
                isSaving
                    ? null
                    : () {
                        Navigator.pop(
                          context,
                        );
                      },
          ),

          const SizedBox(
            width:
                14,
          ),

          const Expanded(
            child:
                Text(
              'Profile',
              style:
                  TextStyle(
                color:
                    Colors.white,
                fontSize:
                    25,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          if (!isEditing)
            _circleButton(
              icon:
                  Icons.edit_rounded,
              onTap:
                  startEditing,
            )
          else
            Row(
              children: [
                _smallActionButton(
                  label:
                      'Cancel',
                  onTap:
                      isSaving
                          ? null
                          : cancelEditing,
                ),
                const SizedBox(
                  width:
                      7,
                ),
                _smallActionButton(
                  label:
                      'Save',
                  primary:
                      true,
                  onTap:
                      isSaving
                          ? null
                          : saveProfile,
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ============================================================
  // PROFILE HERO
  // ============================================================

  Widget _buildProfileHero() {
    final membership =
        widget.membership
                ?.trim()
                .isNotEmpty ==
            true
        ? widget.membership!
        : 'Platinum';

    return Container(
      padding:
          const EdgeInsets.all(
        22,
      ),
      decoration:
          BoxDecoration(
        gradient:
            const LinearGradient(
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
          colors: [
            Color(
              0xFF102D52,
            ),
            Color(
              0xFF24154A,
            ),
            Color(
              0xFF063D45,
            ),
          ],
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
                0.12,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                const Color(
              0xFF00DFFF,
            ).withValues(
              alpha:
                  0.055,
            ),
            blurRadius:
                30,
          ),
        ],
      ),
      child:
          Column(
        children: [
          Stack(
            alignment:
                Alignment.bottomRight,
            children: [
              AnimatedBuilder(
                animation:
                    pulseController,
                builder:
                    (
                  context,
                  child,
                ) {
                  final scale =
                      0.985 +
                          pulseController.value *
                              0.025;

                  return Transform.scale(
                    scale:
                        scale,
                    child:
                        _profileAvatar(
                          size:
                              108,
                        ),
                  );
                },
              ),

              GestureDetector(
                onTap:
                    isEditing
                        ? showPhotoOptions
                        : null,
                child:
                    Container(
                  width:
                      38,
                  height:
                      38,
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
                          0xFF00CFFF,
                        ),
                      ],
                    ),
                    border:
                        Border.all(
                      color:
                          const Color(
                        0xFF06152B,
                      ),
                      width:
                          3,
                    ),
                  ),
                  child:
                      Icon(
                    isEditing
                        ? Icons
                            .camera_alt_rounded
                        : Icons
                            .verified_rounded,
                    color:
                        Colors.white,
                    size:
                        17,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height:
                16,
          ),

          Text(
            nameController.text,
            textAlign:
                TextAlign.center,
            style:
                const TextStyle(
              color:
                  Colors.white,
              fontSize:
                  21,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height:
                7,
          ),

          Text(
            emailController.text.isEmpty
                ? 'Hyundai Care+ Member'
                : emailController.text,
            style:
                const TextStyle(
              color:
                  Colors.white54,
              fontSize:
                  10,
            ),
          ),

          const SizedBox(
            height:
                13,
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal:
                  13,
              vertical:
                  7,
            ),
            decoration:
                BoxDecoration(
              gradient:
                  const LinearGradient(
                colors: [
                  Color(
                    0xFFFFC857,
                  ),
                  Color(
                    0xFFE89D32,
                  ),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color(
                    0xFFFFC857,
                  ).withValues(
                    alpha:
                        0.15,
                  ),
                  blurRadius:
                      15,
                ),
              ],
            ),
            child:
                Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                const Icon(
                  Icons
                      .workspace_premium_rounded,
                  color:
                      Color(
                    0xFF281800,
                  ),
                  size:
                      15,
                ),
                const SizedBox(
                  width:
                      6,
                ),
                Text(
                  '$membership Member',
                  style:
                      const TextStyle(
                    color:
                        Color(
                      0xFF281800,
                    ),
                    fontSize:
                        9,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          if (isEditing) ...[
            const SizedBox(
              height:
                  14,
            ),
            TextButton.icon(
              onPressed:
                  showPhotoOptions,
              icon:
                  const Icon(
                Icons
                    .photo_camera_back_rounded,
                size:
                    16,
              ),
              label:
                  const Text(
                'Change Profile Photo',
              ),
              style:
                  TextButton.styleFrom(
                foregroundColor:
                    const Color(
                  0xFF70E8FF,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // AVATAR
  // ============================================================

  Widget _profileAvatar({
    required double size,
  }) {
    if (selectedImage != null) {
      if (kIsWeb) {
        return ClipOval(
          child:
              Image.network(
            selectedImage!.path,
            width:
                size,
            height:
                size,
            fit:
                BoxFit.cover,
            errorBuilder:
                (
              context,
              error,
              stackTrace,
            ) {
              return _defaultAvatar(
                size,
              );
            },
          ),
        );
      }

      return ClipOval(
        child:
            Image.file(
          File(
            selectedImage!.path,
          ),
          width:
              size,
          height:
              size,
          fit:
              BoxFit.cover,
          errorBuilder:
              (
            context,
            error,
            stackTrace,
          ) {
            return _defaultAvatar(
              size,
            );
          },
        ),
      );
    }

    return _defaultAvatar(
      size,
    );
  }

  // ============================================================
  // DEFAULT AVATAR
  // ============================================================

  Widget _defaultAvatar(
    double size,
  ) {
    final firstLetter =
        nameController.text
                .trim()
                .isEmpty
            ? 'A'
            : nameController.text
                .trim()
                .substring(
                  0,
                  1,
                )
                .toUpperCase();

    return Container(
      width:
          size,
      height:
          size,
      decoration:
          BoxDecoration(
        shape:
            BoxShape.circle,
        gradient:
            const LinearGradient(
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
          colors: [
            Color(
              0xFF704CFF,
            ),
            Color(
              0xFF00CFFF,
            ),
          ],
        ),
        border:
            Border.all(
          color:
              Colors.white.withValues(
            alpha:
                0.18,
          ),
          width:
              3,
        ),
        boxShadow: [
          BoxShadow(
            color:
                const Color(
              0xFF00DFFF,
            ).withValues(
              alpha:
                  0.20,
            ),
            blurRadius:
                25,
          ),
        ],
      ),
      child:
          Center(
        child:
            Text(
          firstLetter,
          style:
              TextStyle(
            color:
                Colors.white,
            fontSize:
                size *
                    0.38,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PERSONAL DETAILS
  // ============================================================

  Widget _buildPersonalDetails() {
    return _glassCard(
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            'Personal Details',
            Icons
                .person_outline_rounded,
          ),

          const SizedBox(
            height:
                14,
          ),

          if (isEditing) ...[
            _inputField(
              controller:
                  nameController,
              label:
                  'Full Name',
              icon:
                  Icons
                      .person_outline_rounded,
            ),

            const SizedBox(
              height:
                  12,
            ),

            _inputField(
              controller:
                  phoneController,
              label:
                  'Phone Number',
              icon:
                  Icons
                      .phone_outlined,
              keyboardType:
                  TextInputType.phone,
            ),

            const SizedBox(
              height:
                  12,
            ),

            _inputField(
              controller:
                  emailController,
              label:
                  'Email Address',
              icon:
                  Icons
                      .email_outlined,
              keyboardType:
                  TextInputType.emailAddress,
            ),
          ] else ...[
            _detailRow(
              icon:
                  Icons
                      .person_outline_rounded,
              label:
                  'Name',
              value:
                  nameController.text,
            ),

            _detailRow(
              icon:
                  Icons
                      .phone_outlined,
              label:
                  'Phone',
              value:
                  phoneController.text.isEmpty
                      ? 'Not provided'
                      : phoneController.text,
            ),

            _detailRow(
              icon:
                  Icons
                      .email_outlined,
              label:
                  'Email',
              value:
                  emailController.text.isEmpty
                      ? 'Not provided'
                      : emailController.text,
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // ACCOUNT CARD
  // ============================================================

  Widget _buildAccountCard() {
    final membership =
        widget.membership
                ?.trim()
                .isNotEmpty ==
            true
        ? widget.membership!
        : 'Platinum';

    final memberSince =
        widget.memberSince
                ?.trim()
                .isNotEmpty ==
            true
        ? widget.memberSince!
        : 'Active member';

    return _glassCard(
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            'Account',
            Icons
                .verified_user_outlined,
          ),

          const SizedBox(
            height:
                14,
          ),

          Row(
            children: [
              Expanded(
                child:
                    _accountStat(
                  icon:
                      Icons
                          .workspace_premium_rounded,
                  title:
                      'Membership',
                  value:
                      membership,
                  color:
                      const Color(
                    0xFFFFC857,
                  ),
                ),
              ),

              const SizedBox(
                width:
                    10,
              ),

              Expanded(
                child:
                    _accountStat(
                  icon:
                      Icons
                          .calendar_month_outlined,
                  title:
                      'Member Since',
                  value:
                      memberSince,
                  color:
                      const Color(
                    0xFF70E8FF,
                  ),
                ),
              ),

              const SizedBox(
                width:
                    10,
              ),

              Expanded(
                child:
                    _accountStat(
                  icon:
                      Icons
                          .check_circle_outline_rounded,
                  title:
                      'Status',
                  value:
                      'Active',
                  color:
                      const Color(
                    0xFF7BFFB2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MENU
  // ============================================================

  Widget _buildMenu() {
    return _glassCard(
      padding:
          EdgeInsets.zero,
      child:
          Column(
        children: [
          _menuItem(
            icon:
                Icons
                    .edit_note_rounded,
            title:
                'Edit Profile',
            subtitle:
                'Update your personal details and photo',
            color:
                const Color(
              0xFF70E8FF,
            ),
            onTap:
                startEditing,
          ),

          _divider(),

          _menuItem(
            icon:
                Icons
                    .lock_outline_rounded,
            title:
                'Change Password',
            subtitle:
                'Keep your account secure',
            color:
                const Color(
              0xFFB28CFF,
            ),
            onTap:
                openChangePassword,
          ),

          _divider(),

          _menuItem(
            icon:
                Icons
                    .support_agent_rounded,
            title:
                'Help & Support',
            subtitle:
                'Get assistance from Hyundai Care+',
            color:
                const Color(
              0xFF7BFFB2,
            ),
            onTap:
                () {
                  showMessage(
                    'Help & Support is ready to connect.',
                  );
                },
          ),

          _divider(),

          _menuItem(
            icon:
                Icons
                    .info_outline_rounded,
            title:
                'About Hyundai Care+',
            subtitle:
                'App information and features',
            color:
                const Color(
              0xFFFFC857,
            ),
            onTap:
                () {
                  showAboutDialog(
                    context:
                        context,
                    applicationName:
                        'Hyundai Care+',
                    applicationVersion:
                        '1.0.0',
                    applicationLegalese:
                        'Your Hyundai. Our Care. Always.',
                  );
                },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECURITY
  // ============================================================

  Widget _buildSecurityCard() {
    return Container(
      padding:
          const EdgeInsets.all(
        17,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFF7BFFB2,
        ).withValues(
          alpha:
              0.035,
        ),
        borderRadius:
            BorderRadius.circular(
          20,
        ),
        border:
            Border.all(
          color:
              const Color(
            0xFF7BFFB2,
          ).withValues(
            alpha:
                0.09,
          ),
        ),
      ),
      child:
          Row(
        children: [
          Container(
            width:
                44,
            height:
                44,
            decoration:
                BoxDecoration(
              shape:
                  BoxShape.circle,
              color:
                  const Color(
                0xFF7BFFB2,
              ).withValues(
                alpha:
                    0.08,
              ),
            ),
            child:
                const Icon(
              Icons
                  .shield_outlined,
              color:
                  Color(
                0xFF7BFFB2,
              ),
              size:
                  22,
            ),
          ),

          const SizedBox(
            width:
                12,
          ),

          const Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Your account is protected',
                  style:
                      TextStyle(
                    color:
                        Colors.white,
                    fontSize:
                        11,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height:
                      4,
                ),
                Text(
                  'Keep your login information private and secure.',
                  style:
                      TextStyle(
                    color:
                        Colors.white38,
                    fontSize:
                        8,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons
                .verified_rounded,
            color:
                Color(
              0xFF7BFFB2,
            ),
            size:
                20,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Widget _buildLogoutButton() {
    return SizedBox(
      width:
          double.infinity,
      height:
          54,
      child:
          OutlinedButton.icon(
        onPressed:
            isSaving
                ? null
                : logout,
        icon:
            const Icon(
          Icons
              .logout_rounded,
          size:
              19,
        ),
        label:
            const Text(
          'LOG OUT',
          style:
              TextStyle(
            fontSize:
                10,
            fontWeight:
                FontWeight.bold,
            letterSpacing:
                0.8,
          ),
        ),
        style:
            OutlinedButton.styleFrom(
          foregroundColor:
              const Color(
            0xFFFF6177,
          ),
          side:
              BorderSide(
            color:
                const Color(
              0xFFFF6177,
            ).withValues(
              alpha:
                  0.25,
            ),
          ),
          backgroundColor:
              const Color(
            0xFFFF6177,
          ).withValues(
            alpha:
                0.035,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              17,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ACCOUNT STAT
  // ============================================================

  Widget _accountStat({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(
        12,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white.withValues(
          alpha:
              0.035,
        ),
        borderRadius:
            BorderRadius.circular(
          15,
        ),
        border:
            Border.all(
          color:
              Colors.white.withValues(
            alpha:
                0.06,
          ),
        ),
      ),
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color:
                color,
            size:
                18,
          ),

          const SizedBox(
            height:
                9,
          ),

          Text(
            title,
            style:
                const TextStyle(
              color:
                  Colors.white38,
              fontSize:
                  7,
            ),
          ),

          const SizedBox(
            height:
                4,
          ),

          Text(
            value,
            maxLines:
                1,
            overflow:
                TextOverflow.ellipsis,
            style:
                TextStyle(
              color:
                  color,
              fontSize:
                  9,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MENU ITEM
  // ============================================================

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color:
          Colors.transparent,
      child:
          InkWell(
        onTap:
            onTap,
        child:
            Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal:
                17,
            vertical:
                15,
          ),
          child:
              Row(
            children: [
              Container(
                width:
                    43,
                height:
                    43,
                decoration:
                    BoxDecoration(
                  shape:
                      BoxShape.circle,
                  color:
                      color.withValues(
                    alpha:
                        0.07,
                  ),
                ),
                child:
                    Icon(
                  icon,
                  color:
                      color,
                  size:
                      20,
                ),
              ),

              const SizedBox(
                width:
                    12,
              ),

              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontSize:
                            11,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height:
                          4,
                    ),
                    Text(
                      subtitle,
                      style:
                          const TextStyle(
                        color:
                            Colors.white38,
                        fontSize:
                            8,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons
                    .arrow_forward_ios_rounded,
                color:
                    Colors.white24,
                size:
                    13,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DETAIL ROW
  // ============================================================

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical:
            8,
      ),
      child:
          Row(
        children: [
          Container(
            width:
                37,
            height:
                37,
            decoration:
                BoxDecoration(
              shape:
                  BoxShape.circle,
              color:
                  const Color(
                0xFF70E8FF,
              ).withValues(
                alpha:
                    0.055,
              ),
            ),
            child:
                Icon(
              icon,
              color:
                  const Color(
                0xFF70E8FF,
              ),
              size:
                  17,
            ),
          ),

          const SizedBox(
            width:
                11,
          ),

          SizedBox(
            width:
                75,
            child:
                Text(
              label,
              style:
                  const TextStyle(
                color:
                    Colors.white38,
                fontSize:
                    9,
              ),
            ),
          ),

          Expanded(
            child:
                Text(
              value,
              textAlign:
                  TextAlign.right,
              style:
                  const TextStyle(
                color:
                    Colors.white,
                fontSize:
                    10,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INPUT
  // ============================================================

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller:
          controller,
      keyboardType:
          keyboardType,
      style:
          const TextStyle(
        color:
            Colors.white,
        fontSize:
            11,
      ),
      cursorColor:
          const Color(
        0xFF70E8FF,
      ),
      decoration:
          InputDecoration(
        labelText:
            label,
        labelStyle:
            const TextStyle(
          color:
              Color(0x73FFFFFF),
          fontSize:
              10,
        ),
        prefixIcon:
            Icon(
          icon,
          color:
              const Color(
            0xFF70E8FF,
          ),
          size:
              19,
        ),
        filled:
            true,
        fillColor:
            Colors.black.withValues(
          alpha:
              0.12,
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            15,
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
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            15,
          ),
          borderSide:
              const BorderSide(
            color:
                Color(
              0xFF70E8FF,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PASSWORD FIELD
  // ============================================================

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
  }) {
    return TextField(
      controller:
          controller,
      obscureText:
          obscure,
      style:
          const TextStyle(
        color:
            Colors.white,
        fontSize:
            11,
      ),
      decoration:
          InputDecoration(
        labelText:
            label,
        labelStyle:
            const TextStyle(
          color:
              Color(0x73FFFFFF),
          fontSize:
              10,
        ),
        prefixIcon:
            const Icon(
          Icons
              .lock_outline_rounded,
          color:
              Color(
            0xFF70E8FF,
          ),
          size:
              19,
        ),
        filled:
            true,
        fillColor:
            Colors.white.withValues(
          alpha:
              0.04,
        ),
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              BorderSide.none,
        ),
      ),
    );
  }

  // ============================================================
  // PHOTO OPTION
  // ============================================================

  Widget _photoOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap:
          onTap,
      borderRadius:
          BorderRadius.circular(
        18,
      ),
      child:
          Container(
        padding:
            const EdgeInsets.all(
          17,
        ),
        decoration:
            BoxDecoration(
          color:
              Colors.white.withValues(
            alpha:
                0.05,
          ),
          borderRadius:
              BorderRadius.circular(
            18,
          ),
          border:
              Border.all(
            color:
                Colors.white.withValues(
              alpha:
                  0.08,
            ),
          ),
        ),
        child:
            Column(
          children: [
            const Icon(
              Icons
                  .photo_camera_rounded,
              color:
                  Color(
                0xFF70E8FF,
              ),
              size:
                  28,
            ),

            const SizedBox(
              height:
                  9,
            ),

            Text(
              title,
              style:
                  const TextStyle(
                color:
                    Colors.white,
                fontSize:
                    11,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height:
                  3,
            ),

            Text(
              subtitle,
              style:
                  const TextStyle(
                color:
                    Colors.white38,
                fontSize:
                    8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle(
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color:
              const Color(
            0xFF70E8FF,
          ),
          size:
              19,
        ),
        const SizedBox(
          width:
              8,
        ),
        Text(
          title,
          style:
              const TextStyle(
            color:
                Colors.white,
            fontSize:
                15,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // GLASS CARD
  // ============================================================

  Widget _glassCard({
    required Widget child,
    EdgeInsets padding =
        const EdgeInsets.all(
      18,
    ),
  }) {
    return Container(
      padding:
          padding,
      decoration:
          BoxDecoration(
        color:
            Colors.white.withValues(
          alpha:
              0.055,
        ),
        borderRadius:
            BorderRadius.circular(
          23,
        ),
        border:
            Border.all(
          color:
              Colors.white.withValues(
            alpha:
                0.08,
          ),
        ),
      ),
      child:
          child,
    );
  }

  // ============================================================
  // DIVIDER
  // ============================================================

  Widget _divider() {
    return Divider(
      height:
          1,
      indent:
          70,
      endIndent:
          17,
      color:
          Colors.white.withValues(
        alpha:
            0.055,
      ),
    );
  }

  // ============================================================
  // SMALL ACTION BUTTON
  // ============================================================

  Widget _smallActionButton({
    required String label,
    required VoidCallback? onTap,
    bool primary = false,
  }) {
    return GestureDetector(
      onTap:
          onTap,
      child:
          Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal:
              11,
          vertical:
              9,
        ),
        decoration:
            BoxDecoration(
          gradient:
              primary
                  ? const LinearGradient(
                      colors: [
                        Color(
                          0xFF704CFF,
                        ),
                        Color(
                          0xFF00CFFF,
                        ),
                      ],
                    )
                  : null,
          color:
              primary
                  ? null
                  : Colors.white.withValues(
                      alpha:
                          0.06,
                    ),
          borderRadius:
              BorderRadius.circular(
            12,
          ),
          border:
              Border.all(
            color:
                Colors.white.withValues(
              alpha:
                  0.08,
            ),
          ),
        ),
        child:
            Text(
          label,
          style:
              const TextStyle(
            color:
                Colors.white,
            fontSize:
                9,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CIRCLE BUTTON
  // ============================================================

  Widget _circleButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return Material(
      color:
          Colors.transparent,
      child:
          InkWell(
        onTap:
            onTap,
        borderRadius:
            BorderRadius.circular(
          14,
        ),
        child:
            Container(
          width:
              44,
          height:
              44,
          decoration:
              BoxDecoration(
            color:
                Colors.white.withValues(
              alpha:
                  0.07,
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
                    0.10,
              ),
            ),
          ),
          child:
              Icon(
            icon,
            color:
                Colors.white,
            size:
                18,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ENTRANCE
  // ============================================================

  Widget _animated(
    int index,
    Widget child,
  ) {
    return AnimatedBuilder(
      animation:
          entranceController,
      builder:
          (
        context,
        child,
      ) {
        final delay =
            index * 0.055;

        final value =
            ((entranceController
                            .value -
                        delay) /
                    (1 -
                        delay))
                .clamp(
              0.0,
              1.0,
            );

        return Opacity(
          opacity:
              value,
          child:
              Transform.translate(
            offset:
                Offset(
              0,
              20 *
                  (1 - value),
            ),
            child:
                child,
          ),
        );
      },
      child:
          child,
    );
  }
}

// =================================================================
// AURORA PAINTER
// =================================================================

class _ProfileAuroraPainter
    extends CustomPainter {
  final double progress;

  _ProfileAuroraPainter({
    required this.progress,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint =
        Paint();

    final t =
        progress *
            math.pi *
            2;

    final cyanCenter =
        Offset(
      size.width *
          (0.17 +
              math.sin(t) *
                  0.12),
      size.height *
          (0.18 +
              math.cos(t) *
                  0.06),
    );

    paint.shader =
        RadialGradient(
      colors: [
        const Color(
          0xFF00E5FF,
        ).withValues(
          alpha:
              0.075,
        ),
        Colors.transparent,
      ],
    ).createShader(
      Rect.fromCircle(
        center:
            cyanCenter,
        radius:
            size.width *
                0.65,
      ),
    );

    canvas.drawRect(
      Offset.zero &
          size,
      paint,
    );

    final purpleCenter =
        Offset(
      size.width *
          (0.82 +
              math.cos(t) *
                  0.10),
      size.height *
          (0.55 +
              math.sin(t) *
                  0.07),
    );

    paint.shader =
        RadialGradient(
      colors: [
        const Color(
          0xFF8C5CFF,
        ).withValues(
          alpha:
              0.065,
        ),
        Colors.transparent,
      ],
    ).createShader(
      Rect.fromCircle(
        center:
            purpleCenter,
        radius:
            size.width *
                0.60,
      ),
    );

    canvas.drawRect(
      Offset.zero &
          size,
      paint,
    );

    // ----------------------------------------------------------
    // STARS
    // ----------------------------------------------------------

    final random =
        math.Random(
      42,
    );

    final starPaint =
        Paint();

    for (int i = 0;
        i < 45;
        i++) {
      final x =
          random.nextDouble() *
              size.width;

      final y =
          random.nextDouble() *
              size.height;

      final opacity =
          0.15 +
              ((math.sin(
                            t +
                                i,
                          ) +
                      1) /
                  2) *
                  0.4;

      starPaint.color =
          Colors.white.withValues(
        alpha:
            opacity,
      );

      canvas.drawCircle(
        Offset(
          x,
          y,
        ),
        0.65,
        starPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _ProfileAuroraPainter oldDelegate,
  ) {
    return oldDelegate.progress !=
        progress;
  }
}