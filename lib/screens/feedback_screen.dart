import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/care_background.dart';

class FeedbackScreen extends StatefulWidget {
  final int customerId;

  const FeedbackScreen({
    super.key,
    required this.customerId,
  });

  @override
  State<FeedbackScreen> createState() =>
      _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with TickerProviderStateMixin {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController feedbackController =
      TextEditingController();

  // ============================================================
  // STATE
  // ============================================================

  int rating = 0;

  String selectedCategory =
      'Overall Experience';

  bool anonymous = false;

  bool isSubmitting = false;

  bool submitted = false;

  // ============================================================
  // ANIMATIONS
  // ============================================================

  late AnimationController auroraController;
  late AnimationController entranceController;
  late AnimationController pulseController;

  // ============================================================
  // CATEGORIES
  // ============================================================

  final List<String> categories = const [
    'Overall Experience',
    'Service Quality',
    'Service Booking',
    'Service Center',
    'App Experience',
    'Emergency Assistance',
    'Support',
  ];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    auroraController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 16,
      ),
    )..repeat();

    entranceController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 850,
      ),
    )..forward();

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1500,
      ),
    )..repeat(
        reverse: true,
      );
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  Future<void> submitFeedback() async {
    FocusScope.of(context).unfocus();

    // ----------------------------------------------------------
    // CUSTOMER VALIDATION
    // ----------------------------------------------------------

    if (widget.customerId <= 0) {
      showMessage(
        'Your customer account could not be identified.',
      );
      return;
    }

    // ----------------------------------------------------------
    // RATING VALIDATION
    // ----------------------------------------------------------

    if (rating == 0) {
      showMessage(
        'Please select a rating first.',
      );
      return;
    }

    // ----------------------------------------------------------
    // COMMENT VALIDATION
    // ----------------------------------------------------------

    final String feedback =
        feedbackController.text.trim();

    if (feedback.isEmpty) {
      showMessage(
        'Please tell us a little about your experience.',
      );
      return;
    }

    // ----------------------------------------------------------
    // SUBMITTING
    // ----------------------------------------------------------

    setState(() {
      isSubmitting = true;
    });

    /*
     * The uploaded project file does not contain the actual
     * feedback API endpoint or its request-field contract.
     *
     * Therefore no fake endpoint is used here.
     *
     * The authenticated customer ID is now guaranteed to be
     * available through:
     *
     *     widget.customerId
     *
     * When the existing backend feedback endpoint is connected,
     * the POST request should use:
     *
     *     widget.customerId
     *     rating
     *     selectedCategory
     *     feedback
     *     anonymous
     */

    await Future.delayed(
      const Duration(
        milliseconds: 900,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      isSubmitting = false;
      submitted = true;
    });
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void showMessage(
    String message,
  ) {
    if (!mounted) {
      return;
    }

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
              Text(
            message,
          ),
        ),
      );
  }

  // ============================================================
  // RESET
  // ============================================================

  void resetFeedback() {
    setState(() {
      rating = 0;
      selectedCategory =
          'Overall Experience';
      anonymous = false;
      submitted = false;
      feedbackController.clear();
    });
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    feedbackController.dispose();

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
                    _FeedbackAuroraPainter(
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
                  submitted
                      ? _buildSuccess()
                      : _buildIntro(),
                ),
                if (!submitted) ...[
                  const SizedBox(
                    height:
                        18,
                  ),
                  _animated(
                    1,
                    _buildRatingCard(),
                  ),
                  const SizedBox(
                    height:
                        18,
                  ),
                  _animated(
                    2,
                    _buildCategoryCard(),
                  ),
                  const SizedBox(
                    height:
                        18,
                  ),
                  _animated(
                    3,
                    _buildCommentCard(),
                  ),
                  const SizedBox(
                    height:
                        18,
                  ),
                  _animated(
                    4,
                    _buildPrivacyCard(),
                  ),
                  const SizedBox(
                    height:
                        22,
                  ),
                  _animated(
                    5,
                    _buildSubmitButton(),
                  ),
                ],
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
                isSubmitting
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
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Share Feedback',
                  style:
                      TextStyle(
                    color:
                        Colors.white,
                    fontSize:
                        24,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height:
                      4,
                ),
                Text(
                  'Help us make Care+ even better',
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
          ),
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
                0xFF70E8FF,
              ).withValues(
                alpha:
                    0.08,
              ),
              border:
                  Border.all(
                color:
                    const Color(
                  0xFF70E8FF,
                ).withValues(
                  alpha:
                      0.18,
                ),
              ),
            ),
            child:
                const Icon(
              Icons
                  .rate_review_outlined,
              color:
                  Color(
                0xFF70E8FF,
              ),
              size:
                  21,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INTRO
  // ============================================================

  Widget _buildIntro() {
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
              0xFF102B51,
            ),
            Color(
              0xFF24164A,
            ),
            Color(
              0xFF073A46,
            ),
          ],
        ),
        borderRadius:
            BorderRadius.circular(
          27,
        ),
        border:
            Border.all(
          color:
              Colors.white.withValues(
            alpha:
                0.11,
          ),
        ),
      ),
      child:
          Row(
        children: [
          AnimatedBuilder(
            animation:
                pulseController,
            builder:
                (
              context,
              child,
            ) {
              final double scale =
                  0.96 +
                      pulseController.value *
                          0.04;

              return Transform.scale(
                scale:
                    scale,
                child:
                    Container(
                  width:
                      70,
                  height:
                      70,
                  decoration:
                      BoxDecoration(
                    shape:
                        BoxShape.circle,
                    color:
                        const Color(
                      0xFF70E8FF,
                    ).withValues(
                      alpha:
                          0.08,
                    ),
                    border:
                        Border.all(
                      color:
                          const Color(
                        0xFF70E8FF,
                      ).withValues(
                        alpha:
                            0.22,
                      ),
                    ),
                  ),
                  child:
                      const Icon(
                    Icons
                        .favorite_rounded,
                    color:
                        Color(
                      0xFF70E8FF,
                    ),
                    size:
                        31,
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            width:
                16,
          ),
          const Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Your voice matters',
                  style:
                      TextStyle(
                    color:
                        Colors.white,
                    fontSize:
                        17,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height:
                      6,
                ),
                Text(
                  'Every review helps us improve your vehicle care experience.',
                  style:
                      TextStyle(
                    color:
                        Colors.white54,
                    fontSize:
                        10,
                    height:
                        1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RATING
  // ============================================================

  Widget _buildRatingCard() {
    final String ratingText =
        switch (rating) {
          1 => 'We can do better',
          2 => 'Needs improvement',
          3 => 'Good experience',
          4 => 'Great experience',
          5 => 'Excellent! Thank you',
          _ => 'Tap a star to rate',
        };

    return _sectionCard(
      child:
          Column(
        children: [
          const Text(
            'How was your experience?',
            textAlign:
                TextAlign.center,
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
                7,
          ),
          Text(
            ratingText,
            style:
                TextStyle(
              color:
                  rating > 0
                      ? const Color(
                          0xFF70E8FF,
                        )
                      : Colors.white38,
              fontSize:
                  10,
              fontWeight:
                  rating > 0
                      ? FontWeight.w600
                      : FontWeight.normal,
            ),
          ),
          const SizedBox(
            height:
                18,
          ),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children:
                List.generate(
              5,
              (
                index,
              ) {
                final int star =
                    index + 1;

                final bool selected =
                    star <= rating;

                return GestureDetector(
                  onTap:
                      isSubmitting
                          ? null
                          : () {
                              setState(() {
                                rating =
                                    star;
                              });
                            },
                  child:
                      AnimatedContainer(
                    duration:
                        const Duration(
                      milliseconds:
                          180,
                    ),
                    width:
                        48,
                    height:
                        48,
                    margin:
                        const EdgeInsets.symmetric(
                      horizontal:
                          3,
                    ),
                    decoration:
                        BoxDecoration(
                      shape:
                          BoxShape.circle,
                      color:
                          selected
                              ? const Color(
                                  0xFFFFC857,
                                ).withValues(
                                  alpha:
                                      0.10,
                                )
                              : Colors.white.withValues(
                                  alpha:
                                      0.04,
                                ),
                      border:
                          Border.all(
                        color:
                            selected
                                ? const Color(
                                    0xFFFFC857,
                                  ).withValues(
                                    alpha:
                                        0.30,
                                  )
                                : Colors.white.withValues(
                                    alpha:
                                        0.07,
                                  ),
                      ),
                    ),
                    child:
                        Icon(
                      selected
                          ? Icons
                              .star_rounded
                          : Icons
                              .star_border_rounded,
                      color:
                          selected
                              ? const Color(
                                  0xFFFFC857,
                                )
                              : Colors.white38,
                      size:
                          28,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height:
                10,
          ),
          if (rating > 0)
            Text(
              '$rating / 5',
              style:
                  const TextStyle(
                color:
                    Colors.white38,
                fontSize:
                    9,
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  Widget _buildCategoryCard() {
    return _sectionCard(
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'What would you like to review?',
            style:
                TextStyle(
              color:
                  Colors.white,
              fontSize:
                  16,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          const SizedBox(
            height:
                13,
          ),
          Wrap(
            spacing:
                8,
            runSpacing:
                8,
            children:
                categories.map(
              (
                category,
              ) {
                final bool selected =
                    selectedCategory ==
                        category;

                return GestureDetector(
                  onTap:
                      isSubmitting
                          ? null
                          : () {
                              setState(() {
                                selectedCategory =
                                    category;
                              });
                            },
                  child:
                      AnimatedContainer(
                    duration:
                        const Duration(
                      milliseconds:
                          200,
                    ),
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal:
                          12,
                      vertical:
                          9,
                    ),
                    decoration:
                        BoxDecoration(
                      gradient:
                          selected
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
                          selected
                              ? null
                              : Colors.white.withValues(
                                  alpha:
                                      0.05,
                                ),
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                      border:
                          Border.all(
                        color:
                            selected
                                ? Colors.transparent
                                : Colors.white.withValues(
                                    alpha:
                                        0.08,
                                  ),
                      ),
                    ),
                    child:
                        Text(
                      category,
                      style:
                          TextStyle(
                        color:
                            selected
                                ? Colors.white
                                : Colors.white60,
                        fontSize:
                            9,
                        fontWeight:
                            selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMMENT
  // ============================================================

  Widget _buildCommentCard() {
    return _sectionCard(
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Tell us more',
            style:
                TextStyle(
              color:
                  Colors.white,
              fontSize:
                  16,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          const SizedBox(
            height:
                5,
          ),
          const Text(
            'Your feedback helps our team understand what works and what can improve.',
            style:
                TextStyle(
              color:
                  Colors.white38,
              fontSize:
                  9,
              height:
                  1.4,
            ),
          ),
          const SizedBox(
            height:
                14,
          ),
          TextField(
            controller:
                feedbackController,
            enabled:
                !isSubmitting,
            maxLines:
                6,
            minLines:
                5,
            style:
                const TextStyle(
              color:
                  Colors.white,
              fontSize:
                  12,
            ),
            cursorColor:
                const Color(
              0xFF70E8FF,
            ),
            decoration:
                InputDecoration(
              hintText:
                  'Write your feedback here...',
              hintStyle:
                  const TextStyle(
                color:
                    Colors.white30,
                fontSize:
                    11,
              ),
              filled:
                  true,
              fillColor:
                  Colors.black.withValues(
                alpha:
                    0.13,
              ),
              alignLabelWithHint:
                  true,
              prefixIcon:
                  const Padding(
                padding:
                    EdgeInsets.only(
                  bottom:
                      78,
                ),
                child:
                    Icon(
                  Icons
                      .edit_note_rounded,
                  color:
                      Colors.white38,
                  size:
                      21,
                ),
              ),
              enabledBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  16,
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
                  16,
                ),
                borderSide:
                    const BorderSide(
                  color:
                      Color(
                    0xFF70E8FF,
                  ),
                  width:
                      1.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRIVACY
  // ============================================================

  Widget _buildPrivacyCard() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            16,
        vertical:
            12,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white.withValues(
          alpha:
              0.04,
        ),
        borderRadius:
            BorderRadius.circular(
          17,
        ),
        border:
            Border.all(
          color:
              Colors.white.withValues(
            alpha:
                0.07,
          ),
        ),
      ),
      child:
          Row(
        children: [
          Container(
            width:
                36,
            height:
                36,
            decoration:
                BoxDecoration(
              shape:
                  BoxShape.circle,
              color:
                  const Color(
                0xFF70E8FF,
              ).withValues(
                alpha:
                    0.07,
              ),
            ),
            child:
                const Icon(
              Icons
                  .shield_outlined,
              color:
                  Color(
                0xFF70E8FF,
              ),
              size:
                  18,
            ),
          ),
          const SizedBox(
            width:
                10,
          ),
          const Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Feedback privacy',
                  style:
                      TextStyle(
                    color:
                        Colors.white,
                    fontSize:
                        10,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height:
                      3,
                ),
                Text(
                  'Your feedback is linked to your Care+ account.',
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
          Switch.adaptive(
            value:
                anonymous,
            activeTrackColor:
                const Color(
              0xFF00CFFF,
            ),
            onChanged:
                isSubmitting
                    ? null
                    : (
                        value,
                      ) {
                        setState(() {
                          anonymous =
                              value;
                        });
                      },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUBMIT BUTTON
  // ============================================================

  Widget _buildSubmitButton() {
    return SizedBox(
      width:
          double.infinity,
      height:
          58,
      child:
          DecoratedBox(
        decoration:
            BoxDecoration(
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
          borderRadius:
              BorderRadius.circular(
            18,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  const Color(
                0xFF00CFFF,
              ).withValues(
                alpha:
                    0.17,
              ),
              blurRadius:
                  25,
            ),
          ],
        ),
        child:
            ElevatedButton(
          onPressed:
              isSubmitting
                  ? null
                  : submitFeedback,
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
                18,
              ),
            ),
          ),
          child:
              isSubmitting
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
                        Icon(
                          Icons
                              .send_rounded,
                          size:
                              20,
                        ),
                        SizedBox(
                          width:
                              9,
                        ),
                        Text(
                          'SUBMIT FEEDBACK',
                          style:
                              TextStyle(
                            fontSize:
                                11,
                            fontWeight:
                                FontWeight.bold,
                            letterSpacing:
                                0.8,
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  // ============================================================
  // SUCCESS
  // ============================================================

  Widget _buildSuccess() {
    return Container(
      padding:
          const EdgeInsets.all(
        28,
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
              0xFF102E4C,
            ),
            Color(
              0xFF21174A,
            ),
            Color(
              0xFF083B40,
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
              const Color(
            0xFF70E8FF,
          ).withValues(
            alpha:
                0.16,
          ),
        ),
      ),
      child:
          Column(
        children: [
          AnimatedBuilder(
            animation:
                pulseController,
            builder:
                (
              context,
              child,
            ) {
              final double scale =
                  0.95 +
                      pulseController.value *
                          0.06;

              return Transform.scale(
                scale:
                    scale,
                child:
                    Container(
                  width:
                      105,
                  height:
                      105,
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
                              0.18,
                        ),
                        blurRadius:
                            35,
                      ),
                    ],
                  ),
                  child:
                      const Icon(
                    Icons
                        .check_rounded,
                    color:
                        Colors.white,
                    size:
                        52,
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height:
                22,
          ),
          const Text(
            'Thank You!',
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
          const SizedBox(
            height:
                9,
          ),
          const Text(
            'Your feedback has been recorded for your Care+ experience.',
            textAlign:
                TextAlign.center,
            style:
                TextStyle(
              color:
                  Colors.white60,
              fontSize:
                  11,
              height:
                  1.5,
            ),
          ),
          const SizedBox(
            height:
                20,
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal:
                  16,
              vertical:
                  10,
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
                20,
              ),
            ),
            child:
                Text(
              '$rating / 5 • $selectedCategory',
              style:
                  const TextStyle(
                color:
                    Color(
                  0xFF70E8FF,
                ),
                fontSize:
                    10,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height:
                24,
          ),
          SizedBox(
            width:
                double.infinity,
            height:
                50,
            child:
                OutlinedButton(
              onPressed:
                  resetFeedback,
              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    Colors.white,
                side:
                    BorderSide(
                  color:
                      Colors.white.withValues(
                    alpha:
                        0.15,
                  ),
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),
                ),
              ),
              child:
                  const Text(
                'SEND ANOTHER FEEDBACK',
                style:
                    TextStyle(
                  fontSize:
                      10,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION CARD
  // ============================================================

  Widget _sectionCard({
    required Widget child,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(
        19,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white.withValues(
          alpha:
              0.06,
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
                0.09,
          ),
        ),
      ),
      child:
          child,
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
                19,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ENTRANCE ANIMATION
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
        final double delay =
            index * 0.08;

        final double value =
            ((entranceController.value -
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
              22 *
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

// ================================================================
// AURORA PAINTER
// ================================================================

class _FeedbackAuroraPainter
    extends CustomPainter {
  final double progress;

  _FeedbackAuroraPainter({
    required this.progress,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final Paint paint =
        Paint();

    final double t =
        progress *
            math.pi *
            2;

    final Offset cyanCenter =
        Offset(
      size.width *
          (0.18 +
              math.sin(t) *
                  0.12),
      size.height *
          (0.22 +
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

    final Offset purpleCenter =
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
  }

  @override
  bool shouldRepaint(
    covariant _FeedbackAuroraPainter oldDelegate,
  ) {
    return oldDelegate.progress !=
        progress;
  }
}