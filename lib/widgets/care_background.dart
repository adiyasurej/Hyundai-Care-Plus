import 'dart:math' as math;

import 'package:flutter/material.dart';

enum CareBackgroundStyle {
  midnightAurora,
  arcticDaylight,
}

class CareTheme {
  CareTheme._();

  static final ValueNotifier<CareBackgroundStyle>
      background =
      ValueNotifier<CareBackgroundStyle>(
    CareBackgroundStyle.midnightAurora,
  );

  static const Color primaryBlue =
      Color(0xFF147DFF);

  static const Color cyan =
      Color(0xFF70E8FF);

  static const Color navy =
      Color(0xFF020817);

  static const Color lightBackground =
      Color(0xFFF3F7FC);

  static bool get isDark =>
      background.value ==
      CareBackgroundStyle.midnightAurora;

  static List<Color> get gradientColors {
    if (isDark) {
      return const [
        Color(0xFF020817),
        Color(0xFF071A35),
        Color(0xFF160D35),
      ];
    }

    return const [
      Color(0xFFF8FCFF),
      Color(0xFFEAF6FF),
      Color(0xFFDDEEFF),
    ];
  }

  static Color get cardColor {
    return isDark
        ? Colors.white.withValues(alpha: 0.045)
        : Colors.white.withValues(alpha: 0.82);
  }

  static Color get borderColor {
    return isDark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFF164A70)
            .withValues(alpha: 0.12);
  }

  static Color get primaryText {
    return isDark
        ? Colors.white
        : const Color(0xFF07152C);
  }

  static Color get secondaryText {
    return isDark
        ? Colors.white54
        : const Color(0xFF536579);
  }

  static String get backgroundName {
    return isDark
        ? 'Midnight Aurora'
        : 'Arctic Daylight';
  }

  static String get backgroundDescription {
    return isDark
        ? 'Dark & mystical'
        : 'Clean & refreshing';
  }

  static IconData get backgroundIcon {
    return isDark
        ? Icons.nightlight_round
        : Icons.wb_sunny_rounded;
  }

  static void setBackground(
    CareBackgroundStyle value,
  ) {
    background.value = value;
  }
}

class CareBackground extends StatelessWidget {
  final Widget child;

  const CareBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<
        CareBackgroundStyle>(
      valueListenable: CareTheme.background,
      builder: (
        context,
        background,
        _,
      ) {
        return AnimatedContainer(
          duration:
              const Duration(milliseconds: 550),
          curve: Curves.easeInOut,
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: CareTheme.gradientColors,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (background ==
                  CareBackgroundStyle.midnightAurora)
                const _MidnightAurora(),
              if (background ==
                  CareBackgroundStyle.arcticDaylight)
                const _ArcticDaylight(),
              child,
            ],
          ),
        );
      },
    );
  }
}

class CareBackgroundView extends StatelessWidget {
  final Widget child;

  const CareBackgroundView({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CareBackground(
      child: child,
    );
  }
}

/// Theme button.
///
/// If no child is supplied, it automatically
/// displays the current theme icon.
class CareThemeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;

  const CareThemeButton({
    super.key,
    this.child,
    this.onPressed,
  });

  void _toggleTheme() {
    if (onPressed != null) {
      onPressed!();
      return;
    }

    final CareBackgroundStyle next =
        CareTheme.isDark
            ? CareBackgroundStyle.arcticDaylight
            : CareBackgroundStyle.midnightAurora;

    CareTheme.setBackground(next);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleTheme,
        borderRadius:
            BorderRadius.circular(14),
        child: Container(
          width: 48,
          height: 44,
          padding:
              const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: CareTheme.cardColor,
            borderRadius:
                BorderRadius.circular(14),
            border: Border.all(
              color: CareTheme.borderColor,
            ),
          ),
          child: child ??
              Icon(
                CareTheme.backgroundIcon,
                color: CareTheme.cyan,
                size: 20,
              ),
        ),
      ),
    );
  }
}

class _MidnightAurora extends StatelessWidget {
  const _MidnightAurora();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: CustomPaint(
        painter: _AuroraPainter(),
      ),
    );
  }
}

class _ArcticDaylight extends StatelessWidget {
  const _ArcticDaylight();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: CustomPaint(
        painter: _ArcticPainter(),
      ),
    );
  }
}

class _AuroraPainter extends CustomPainter {
  const _AuroraPainter();

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final double width = size.width;
    final double height = size.height;

    final glowPaint = Paint()
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        55,
      );

    final glowRect = Rect.fromCenter(
      center: Offset(
        width * 0.52,
        height * 0.25,
      ),
      width: width * 0.72,
      height: height * 0.28,
    );

    glowPaint.shader =
        const RadialGradient(
      colors: [
        Color(0x5530D9FF),
        Color(0x222C8BFF),
        Colors.transparent,
      ],
    ).createShader(glowRect);

    canvas.drawOval(
      glowRect,
      glowPaint,
    );

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final paths = <Path>[
      Path()
        ..moveTo(
          -20,
          height * 0.27,
        )
        ..cubicTo(
          width * 0.22,
          height * 0.05,
          width * 0.52,
          height * 0.48,
          width + 20,
          height * 0.16,
        ),
      Path()
        ..moveTo(
          -20,
          height * 0.43,
        )
        ..cubicTo(
          width * 0.25,
          height * 0.66,
          width * 0.62,
          height * 0.15,
          width + 20,
          height * 0.37,
        ),
      Path()
        ..moveTo(
          -20,
          height * 0.65,
        )
        ..cubicTo(
          width * 0.28,
          height * 0.43,
          width * 0.67,
          height * 0.78,
          width + 20,
          height * 0.53,
        ),
    ];

    const colors = <Color>[
      Color(0x4470E8FF),
      Color(0x333C9DFF),
      Color(0x443EBCFF),
    ];

    for (int i = 0; i < paths.length; i++) {
      linePaint.color = colors[i];
      canvas.drawPath(
        paths[i],
        linePaint,
      );
    }

    final starPaint = Paint()
      ..color =
          Colors.white.withValues(alpha: 0.38);

    const starPositions = <List<double>>[
      [0.08, 0.11],
      [0.19, 0.18],
      [0.31, 0.08],
      [0.46, 0.15],
      [0.61, 0.09],
      [0.77, 0.18],
      [0.91, 0.11],
      [0.70, 0.31],
      [0.39, 0.34],
      [0.12, 0.47],
      [0.85, 0.55],
      [0.56, 0.64],
    ];

    for (final position in starPositions) {
      canvas.drawCircle(
        Offset(
          width * position[0],
          height * position[1],
        ),
        1.35,
        starPaint,
      );
    }

    final smallStarPaint = Paint()
      ..color =
          const Color(0x5570E8FF);

    for (int i = 0; i < 14; i++) {
      final double x =
          (math.sin(i * 2.71) + 1) *
              width /
              2;

      final double y =
          (math.cos(i * 1.93) + 1) *
              height /
              2;

      canvas.drawCircle(
        Offset(x, y),
        0.9,
        smallStarPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _AuroraPainter oldDelegate,
  ) {
    return false;
  }
}

class _ArcticPainter extends CustomPainter {
  const _ArcticPainter();

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final double width = size.width;
    final double height = size.height;

    final glowPaint = Paint()
      ..shader =
          const RadialGradient(
        colors: [
          Color(0x553BB9FF),
          Color(0x22147DFF),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCenter(
          center: Offset(
            width * 0.72,
            height * 0.16,
          ),
          width: width * 0.65,
          height: height * 0.38,
        ),
      );

    canvas.drawCircle(
      Offset(
        width * 0.72,
        height * 0.16,
      ),
      width * 0.28,
      glowPaint,
    );

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = const Color(0x33147DFF);

    final first = Path()
      ..moveTo(
        -20,
        height * 0.48,
      )
      ..cubicTo(
        width * 0.22,
        height * 0.29,
        width * 0.45,
        height * 0.66,
        width * 0.73,
        height * 0.43,
      )
      ..cubicTo(
        width * 0.86,
        height * 0.32,
        width * 0.95,
        height * 0.43,
        width + 20,
        height * 0.34,
      );

    final second = Path()
      ..moveTo(
        -20,
        height * 0.67,
      )
      ..cubicTo(
        width * 0.24,
        height * 0.51,
        width * 0.53,
        height * 0.82,
        width + 20,
        height * 0.57,
      );

    canvas.drawPath(
      first,
      linePaint,
    );

    canvas.drawPath(
      second,
      linePaint,
    );

    final dotPaint = Paint()
      ..color = const Color(0x33147DFF);

    for (int i = 0; i < 20; i++) {
      final double x =
          (math.sin(i * 1.7) + 1) *
              width /
              2;

      final double y =
          (math.cos(i * 2.2) + 1) *
              height /
              2;

      canvas.drawCircle(
        Offset(x, y),
        1,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _ArcticPainter oldDelegate,
  ) {
    return false;
  }
}