import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/care_logo.dart';
import 'login_screen.dart';

// ============================================================
// LOADING SCREEN COLORS
// ============================================================

const Color _loadingNavy = Color(0xFF020817);
const Color _loadingNavy2 = Color(0xFF06152D);
const Color _loadingBlue = Color(0xFF3188FF);
const Color _loadingCyan = Color(0xFF70E8FF);
const Color _loadingPurple = Color(0xFF9B6CFF);
const Color _loadingGreen = Color(0xFF68F5B0);

// ============================================================
// LOADING SCREEN
// ============================================================

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() =>
      _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _backgroundController;
  late final AnimationController _logoController;
  late final AnimationController _ringController;
  late final AnimationController _entranceController;
  late final AnimationController _progressController;

  Timer? _navigationTimer;

  double _progress = 0.0;

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    );

    _entranceController.forward();

    _progressController.addListener(_updateProgress);

    _progressController.forward();

    _navigationTimer = Timer(
      const Duration(milliseconds: 4500),
      _openLogin,
    );
  }

  void _updateProgress() {
    if (!mounted) {
      return;
    }

    setState(() {
      _progress = _progressController.value;
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();

    _backgroundController.dispose();
    _logoController.dispose();
    _ringController.dispose();
    _entranceController.dispose();
    _progressController.dispose();

    super.dispose();
  }

  void _openLogin() {
    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (
          context,
          animation,
          secondaryAnimation,
        ) {
          return const LoginScreen();
        },
        transitionDuration:
            const Duration(milliseconds: 900),
        reverseTransitionDuration:
            const Duration(milliseconds: 500),
        transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return FadeTransition(
            opacity: curved,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _loadingNavy,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ----------------------------------------------------
          // SELF-CONTAINED BACKGROUND
          // ----------------------------------------------------

          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF010817),
                  Color(0xFF03152C),
                  Color(0xFF100D32),
                ],
                stops: [
                  0.0,
                  0.48,
                  1.0,
                ],
              ),
            ),
          ),

          // ----------------------------------------------------
          // STARS
          // ----------------------------------------------------

          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _backgroundController,
                builder: (
                  context,
                  child,
                ) {
                  return CustomPaint(
                    painter: _StarsPainter(
                      progress:
                          _backgroundController.value,
                    ),
                  );
                },
              ),
            ),
          ),

          // ----------------------------------------------------
          // AURORA
          // ----------------------------------------------------

          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _backgroundController,
                builder: (
                  context,
                  child,
                ) {
                  return CustomPaint(
                    painter: _AuroraPainter(
                      progress:
                          _backgroundController.value,
                    ),
                  );
                },
              ),
            ),
          ),

          // ----------------------------------------------------
          // CENTRAL GLOW
          // ----------------------------------------------------

          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _logoController,
                builder: (
                  context,
                  child,
                ) {
                  return CustomPaint(
                    painter: _CentralGlowPainter(
                      pulse:
                          _logoController.value,
                    ),
                  );
                },
              ),
            ),
          ),

          // ----------------------------------------------------
          // CONTENT
          // ----------------------------------------------------

          SafeArea(
            child: LayoutBuilder(
              builder: (
                context,
                constraints,
              ) {
                return Center(
                  child: SingleChildScrollView(
                    physics:
                        const BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 18,
                    ),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(
                        minHeight:
                            constraints.maxHeight -
                                36,
                      ),
                      child: Center(
                        child:
                            AnimatedBuilder(
                          animation:
                              _entranceController,
                          builder: (
                            context,
                            child,
                          ) {
                            final value =
                                Curves.easeOutCubic
                                    .transform(
                              _entranceController
                                  .value,
                            );

                            return Opacity(
                              opacity: value,
                              child:
                                  Transform.translate(
                                offset:
                                    Offset(
                                  0,
                                  25 *
                                      (1 - value),
                                ),
                                child: child,
                              ),
                            );
                          },
                          child:
                              _buildContent(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MAIN CONTENT
  // ============================================================

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPremiumBadge(),

        const SizedBox(height: 26),

        _buildLogo(),

        const SizedBox(height: 25),

        _buildBrandName(),

        const SizedBox(height: 12),

        _buildTagline(),

        const SizedBox(height: 25),

        _buildFeaturePills(),

        const SizedBox(height: 38),

        _buildLoadingRing(),

        const SizedBox(height: 13),

        _buildProgressText(),

        const SizedBox(height: 25),

        _buildSecurityStatus(),
      ],
    );
  }

  // ============================================================
  // PREMIUM BADGE
  // ============================================================

  Widget _buildPremiumBadge() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(
          alpha: 0.045,
        ),
        borderRadius:
            BorderRadius.circular(30),
        border: Border.all(
          color:
              _loadingCyan.withValues(
            alpha: 0.14,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                _loadingCyan.withValues(
              alpha: 0.04,
            ),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield_rounded,
            color: _loadingGreen,
            size: 13,
          ),
          SizedBox(width: 7),
          Text(
            'PREMIUM VEHICLE CARE',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 7,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOGO
  // ============================================================

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _logoController,
        _ringController,
      ]),
      builder: (
        context,
        child,
      ) {
        final breathing =
            1.0 +
            (_logoController.value * 0.035);

        return Transform.scale(
          scale: breathing,
          child: SizedBox(
            width: 185,
            height: 185,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle:
                      _ringController.value *
                      math.pi *
                      2,
                  child: CustomPaint(
                    size:
                        const Size(
                      185,
                      185,
                    ),
                    painter:
                        _OuterRingPainter(),
                  ),
                ),

                Container(
                  width: 148,
                  height: 148,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient:
                        const RadialGradient(
                      colors: [
                        Color(0xFF1A4278),
                        Color(0xFF0A2145),
                        Color(0xFF020A19),
                      ],
                      stops: [
                        0.0,
                        0.55,
                        1.0,
                      ],
                    ),
                    border: Border.all(
                      color:
                          _loadingCyan
                              .withValues(
                        alpha: 0.23,
                      ),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            _loadingCyan
                                .withValues(
                          alpha:
                              0.16 +
                              (_logoController
                                      .value *
                                  0.08),
                        ),
                        blurRadius: 42,
                        spreadRadius: 3,
                      ),
                      BoxShadow(
                        color:
                            _loadingPurple
                                .withValues(
                          alpha: 0.08,
                        ),
                        blurRadius: 65,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: CareLogo(
                      size: 105,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // BRAND
  // ============================================================

  Widget _buildBrandName() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'HYUNDAI ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 29,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.7,
            ),
          ),
          TextSpan(
            text: 'CARE',
            style: TextStyle(
              color: _loadingCyan,
              fontSize: 29,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.7,
            ),
          ),
          TextSpan(
            text: '+',
            style: TextStyle(
              color: _loadingPurple,
              fontSize: 33,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TAGLINE
  // ============================================================

  Widget _buildTagline() {
    return Column(
      children: [
        const Text(
          'YOUR HYUNDAI. OUR CARE. ALWAYS.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 8,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Smart care for every journey.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color:
                Colors.white.withValues(
              alpha: 0.42,
            ),
            fontSize: 8,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // FEATURE PILLS
  // ============================================================

  Widget _buildFeaturePills() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 7,
      runSpacing: 7,
      children: [
        _featurePill(
          Icons.auto_awesome_rounded,
          'SMART',
          _loadingCyan,
        ),
        _featurePill(
          Icons.shield_rounded,
          'SECURE',
          _loadingGreen,
        ),
        _featurePill(
          Icons.bolt_rounded,
          'FAST',
          _loadingBlue,
        ),
        _featurePill(
          Icons.favorite_rounded,
          'CARING',
          _loadingPurple,
        ),
      ],
    );
  }

  Widget _featurePill(
    IconData icon,
    String label,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color:
            color.withValues(
          alpha: 0.055,
        ),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color:
              color.withValues(
            alpha: 0.14,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 10,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 5.8,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOADING RING
  // ============================================================

  Widget _buildLoadingRing() {
    return AnimatedBuilder(
      animation: _ringController,
      builder: (
        context,
        child,
      ) {
        return SizedBox(
          width: 78,
          height: 78,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle:
                    _ringController.value *
                    math.pi *
                    2,
                child: CustomPaint(
                  size:
                      const Size(
                    78,
                    78,
                  ),
                  painter:
                      _ProgressRingPainter(
                    progress: _progress,
                  ),
                ),
              ),

              Container(
                width: 51,
                height: 51,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _loadingNavy2,
                  border: Border.all(
                    color:
                        Colors.white.withValues(
                      alpha: 0.07,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          _loadingCyan
                              .withValues(
                        alpha: 0.08,
                      ),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons
                      .directions_car_rounded,
                  color: _loadingCyan,
                  size: 21,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // PROGRESS TEXT
  // ============================================================

  Widget _buildProgressText() {
    final percentage =
        (_progress * 100)
            .round()
            .clamp(0, 100);

    return Column(
      children: [
        const Text(
          'INITIALIZING CARE+',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 7,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.7,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          '$percentage%',
          style: const TextStyle(
            color: _loadingCyan,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SECURITY STATUS
  // ============================================================

  Widget _buildSecurityStatus() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(
          alpha: 0.025,
        ),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color:
              Colors.white.withValues(
            alpha: 0.05,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _loadingGreen,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            'CONNECTED',
            style: TextStyle(
              color:
                  Colors.white.withValues(
                alpha: 0.32,
              ),
              fontSize: 5.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.9,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '•',
            style: TextStyle(
              color:
                  Colors.white.withValues(
                alpha: 0.18,
              ),
              fontSize: 6,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'PROTECTED',
            style: TextStyle(
              color:
                  Colors.white.withValues(
                alpha: 0.32,
              ),
              fontSize: 5.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.9,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '•',
            style: TextStyle(
              color:
                  Colors.white.withValues(
                alpha: 0.18,
              ),
              fontSize: 6,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'CARED FOR',
            style: TextStyle(
              color:
                  Colors.white.withValues(
                alpha: 0.32,
              ),
              fontSize: 5.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.9,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// OUTER RING PAINTER
// ================================================================

class _OuterRingPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius =
        size.width / 2 - 7;

    final rect =
        Rect.fromCircle(
      center: center,
      radius: radius,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    paint.color =
        _loadingCyan.withValues(
      alpha: 0.18,
    );

    canvas.drawArc(
      rect,
      -math.pi * 0.15,
      math.pi * 0.95,
      false,
      paint,
    );

    paint.color =
        _loadingPurple.withValues(
      alpha: 0.15,
    );

    canvas.drawArc(
      rect,
      math.pi * 0.80,
      math.pi * 0.72,
      false,
      paint,
    );

    paint.color =
        _loadingBlue.withValues(
      alpha: 0.10,
    );

    canvas.drawArc(
      rect,
      math.pi * 1.75,
      math.pi * 0.40,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}

// ================================================================
// PROGRESS RING PAINTER
// ================================================================

class _ProgressRingPainter extends CustomPainter {
  final double progress;

  const _ProgressRingPainter({
    required this.progress,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius =
        size.width / 2 - 3;

    final rect =
        Rect.fromCircle(
      center: center,
      radius: radius,
    );

    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color =
          Colors.white.withValues(
        alpha: 0.06,
      );

    canvas.drawCircle(
      center,
      radius,
      backgroundPaint,
    );

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..shader =
          const SweepGradient(
        colors: [
          _loadingPurple,
          _loadingBlue,
          _loadingCyan,
          _loadingGreen,
        ],
      ).createShader(rect);

    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _ProgressRingPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}

// ================================================================
// STAR PAINTER
// ================================================================

class _StarsPainter extends CustomPainter {
  final double progress;

  const _StarsPainter({
    required this.progress,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final random = math.Random(4271);

    final paint = Paint();

    for (int i = 0; i < 100; i++) {
      final x =
          random.nextDouble() *
          size.width;

      final y =
          random.nextDouble() *
          size.height;

      final twinkle =
          (math.sin(
                    progress *
                            math.pi *
                            2 +
                        i,
                  ) +
                  1) /
              2;

      final radius =
          0.35 +
          random.nextDouble() *
              1.05;

      paint.color =
          Colors.white.withValues(
        alpha:
            0.10 +
            twinkle * 0.28,
      );

      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _StarsPainter oldDelegate,
  ) {
    return oldDelegate.progress !=
        progress;
  }
}

// ================================================================
// AURORA PAINTER
// ================================================================

class _AuroraPainter extends CustomPainter {
  final double progress;

  const _AuroraPainter({
    required this.progress,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final phase =
        progress *
        math.pi *
        2;

    // ----------------------------------------------------------
    // UPPER AURORA
    // ----------------------------------------------------------

    final upperPath = Path();

    upperPath.moveTo(
      -60,
      size.height * 0.23,
    );

    for (
      double x = -60;
      x <= size.width + 60;
      x += 18
    ) {
      final y =
          size.height * 0.23 +
          math.sin(
                x / 190 + phase,
              ) *
              38;

      upperPath.lineTo(
        x,
        y,
      );
    }

    upperPath.lineTo(
      size.width + 60,
      size.height * 0.40,
    );

    upperPath.lineTo(
      -60,
      size.height * 0.40,
    );

    upperPath.close();

    final upperPaint = Paint()
      ..shader =
          const LinearGradient(
        colors: [
          Colors.transparent,
          Color(0x0870E8FF),
          Color(0x069B6CFF),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
      );

    canvas.drawPath(
      upperPath,
      upperPaint,
    );

    // ----------------------------------------------------------
    // LOWER AURORA
    // ----------------------------------------------------------

    final lowerPath = Path();

    lowerPath.moveTo(
      -60,
      size.height * 0.70,
    );

    for (
      double x = -60;
      x <= size.width + 60;
      x += 18
    ) {
      final y =
          size.height * 0.70 +
          math.sin(
                x / 220 -
                    phase * 0.7,
              ) *
              35;

      lowerPath.lineTo(
        x,
        y,
      );
    }

    lowerPath.lineTo(
      size.width + 60,
      size.height * 0.84,
    );

    lowerPath.lineTo(
      -60,
      size.height * 0.84,
    );

    lowerPath.close();

    final lowerPaint = Paint()
      ..shader =
          const LinearGradient(
        colors: [
          Colors.transparent,
          Color(0x049B6CFF),
          Color(0x063188FF),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
      );

    canvas.drawPath(
      lowerPath,
      lowerPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _AuroraPainter oldDelegate,
  ) {
    return oldDelegate.progress !=
        progress;
  }
}

// ================================================================
// CENTRAL GLOW PAINTER
// ================================================================

class _CentralGlowPainter
    extends CustomPainter {
  final double pulse;

  const _CentralGlowPainter({
    required this.pulse,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final radius =
        size.width *
        (0.30 +
            pulse * 0.035);

    final center = Offset(
      size.width * 0.50,
      size.height * 0.38,
    );

    final paint = Paint()
      ..shader =
          const RadialGradient(
        colors: [
          Color(0x1470E8FF),
          Color(0x089B6CFF),
          Colors.transparent,
        ],
        stops: [
          0.0,
          0.45,
          1.0,
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
      );

    canvas.drawCircle(
      center,
      radius,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _CentralGlowPainter oldDelegate,
  ) {
    return oldDelegate.pulse != pulse;
  }
}