import 'dart:math' as math;
import 'glass_section.dart';
import 'package:flutter/material.dart';

class VehicleHealthCard extends StatefulWidget {
  final int health;

  const VehicleHealthCard({
    super.key,
    this.health = 82,
  });

  @override
  State<VehicleHealthCard> createState() =>
      _VehicleHealthCardState();
}

class _VehicleHealthCardState
    extends State<VehicleHealthCard>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1400,
      ),
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    return GlassSection(
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final progress =
                    controller.value *
                        widget.health /
                        100;

                return CustomPaint(
                  painter: _HealthPainter(
                    progress: progress,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Text(
                          '${(progress * 100).round()}',
                          style:
                              const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'HEALTH',
                          style: TextStyle(
                            color:
                                Colors.white38,
                            fontSize: 6,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 17),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Vehicle Health',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Your vehicle is performing well.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF6EFFE1),
                      size: 15,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'No critical issues',
                      style: TextStyle(
                        color:
                            Color(0xFF6EFFE1),
                        fontSize: 8,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _HealthPainter extends CustomPainter {
  final double progress;

  _HealthPainter({
    required this.progress,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final center =
        Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius =
        math.min(
          size.width,
          size.height,
        ) /
            2 -
            7;

    final backgroundPaint =
        Paint()
          ..style =
              PaintingStyle.stroke
          ..strokeWidth =
              7
          ..strokeCap =
              StrokeCap.round
          ..color =
              Colors.white.withValues(
            alpha: 0.08,
          );

    final progressPaint =
        Paint()
          ..style =
              PaintingStyle.stroke
          ..strokeWidth =
              7
          ..strokeCap =
              StrokeCap.round
          ..shader =
              const LinearGradient(
            colors: [
              Color(0xFF704CFF),
              Color(0xFF00DFFF),
              Color(0xFF6EFFE1),
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
      backgroundPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _HealthPainter oldDelegate,
  ) {
    return oldDelegate.progress !=
        progress;
  }
}