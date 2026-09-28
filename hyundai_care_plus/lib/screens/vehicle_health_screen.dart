import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/care_background.dart';

class VehicleHealthScreen extends StatefulWidget {
  final int? customerId;

  const VehicleHealthScreen({
    super.key,
    this.customerId,
  });

  @override
  State<VehicleHealthScreen> createState() =>
      _VehicleHealthScreenState();
}

class _VehicleHealthScreenState
    extends State<VehicleHealthScreen>
    with TickerProviderStateMixin {
  late final AnimationController auroraController;
  late final AnimationController entranceController;
  late final AnimationController scanController;

  bool scanning = false;
  int healthScore = 92;

  final List<HealthItem> healthItems = const [
    HealthItem(
      title: 'Engine',
      subtitle: 'Engine performance is optimal',
      value: 96,
      status: 'Excellent',
      icon: Icons.settings_rounded,
      color: Color(0xFF7BFFB2),
    ),
    HealthItem(
      title: 'Battery',
      subtitle: 'Battery charge and voltage are healthy',
      value: 88,
      status: 'Good',
      icon: Icons.battery_charging_full_rounded,
      color: Color(0xFF70E8FF),
    ),
    HealthItem(
      title: 'Tyres',
      subtitle: 'Tyre pressure and tread look good',
      value: 91,
      status: 'Excellent',
      icon: Icons.tire_repair_rounded,
      color: Color(0xFF7BFFB2),
    ),
    HealthItem(
      title: 'Brakes',
      subtitle: 'Brake system requires attention soon',
      value: 78,
      status: 'Good',
      icon: Icons.speed_rounded,
      color: Color(0xFFFFC857),
    ),
    HealthItem(
      title: 'Engine Oil',
      subtitle: 'Oil level is within the recommended range',
      value: 94,
      status: 'Excellent',
      icon: Icons.opacity_rounded,
      color: Color(0xFF7BFFB2),
    ),
    HealthItem(
      title: 'Coolant',
      subtitle: 'Coolant temperature is normal',
      value: 90,
      status: 'Good',
      icon: Icons.thermostat_rounded,
      color: Color(0xFF70E8FF),
    ),
  ];

  @override
  void initState() {
    super.initState();

    auroraController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
  }

  @override
  void dispose() {
    auroraController.dispose();
    entranceController.dispose();
    scanController.dispose();
    super.dispose();
  }

  Future<void> runHealthScan() async {
    if (scanning) {
      return;
    }

    setState(() {
      scanning = true;
    });

    try {
      await scanController.forward(from: 0);
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        scanning = false;
        healthScore = 94;
      });

      showMessage(
        'Vehicle health scan completed successfully.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: auroraController,
            builder: (context, child) {
              return CustomPaint(
                painter: _HealthAuroraPainter(
                  progress: auroraController.value,
                ),
              );
            },
          ),
          CareBackground(
            child: SafeArea(
              child: _buildPage(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: _buildHeader(),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            30,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                _animated(
                  0,
                  _buildHealthScore(),
                ),
                const SizedBox(height: 16),
                _animated(
                  1,
                  _buildScanCard(),
                ),
                const SizedBox(height: 18),
                _animated(
                  2,
                  _buildVehicleSummary(),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Vehicle Systems',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  healthItems.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 11,
                      ),
                      child: _animated(
                        index + 3,
                        _healthCard(
                          healthItems[index],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                _animated(
                  10,
                  _buildMaintenanceAlert(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        12,
        18,
        20,
      ),
      child: Row(
        children: [
          _circleButton(
            Icons.arrow_back_ios_new_rounded,
            () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Vehicle Health',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Your vehicle, intelligently monitored',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          _circleButton(
            Icons.history_rounded,
            () {
              showMessage(
                'Health scan history opened.',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHealthScore() {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF102F50),
            Color(0xFF171F50),
            Color(0xFF093A3E),
          ],
        ),
        borderRadius: BorderRadius.circular(27),
        border: Border.all(
          color: const Color(0xFF70E8FF)
              .withValues(alpha: 0.13),
        ),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(
                Icons.monitor_heart_rounded,
                color: Color(0xFF70E8FF),
                size: 21,
              ),
              SizedBox(width: 8),
              Text(
                'DIGITAL VEHICLE HEALTH',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 6.5,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Icon(
                Icons.verified_rounded,
                color: Color(0xFF7BFFB2),
                size: 17,
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: 175,
            height: 175,
            child: AnimatedBuilder(
              animation: scanController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _HealthGaugePainter(
                    score: healthScore,
                    scanProgress:
                        scanning
                            ? scanController.value
                            : 0,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          '$healthScore',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          '/ 100',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 8,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          scanning
                              ? 'SCANNING'
                              : 'EXCELLENT',
                          style: TextStyle(
                            color: scanning
                                ? const Color(0xFF70E8FF)
                                : const Color(0xFF7BFFB2),
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
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
          const SizedBox(height: 10),
          Text(
            scanning
                ? 'Checking vehicle systems...'
                : 'Your vehicle is in excellent condition.',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanCard() {
    return GestureDetector(
      onTap: runHealthScan,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF70E8FF)
              .withValues(alpha: 0.035),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: const Color(0xFF70E8FF)
                .withValues(alpha: 0.10),
          ),
        ),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: scanController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: scanning
                      ? scanController.value *
                          math.pi *
                          2
                      : 0,
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF70E8FF)
                          .withValues(alpha: 0.07),
                    ),
                    child: const Icon(
                      Icons.radar_rounded,
                      color: Color(0xFF70E8FF),
                      size: 22,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    scanning
                        ? 'Scanning vehicle...'
                        : 'Run health scan',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    scanning
                        ? 'Checking engine, battery, tyres and more'
                        : 'Perform a complete digital vehicle check',
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 7,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white24,
              size: 11,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleSummary() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color:
              Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 67,
            height: 67,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: const Color(0xFF70E8FF)
                  .withValues(alpha: 0.05),
            ),
            child: const Icon(
              Icons.directions_car_filled_rounded,
              color: Color(0xFF70E8FF),
              size: 34,
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Hyundai Creta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'TN 01 AB 4589',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 7,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Last checked • 22 Aug 2026',
                  style: TextStyle(
                    color: Colors.white24,
                    fontSize: 6.5,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.local_gas_station_rounded,
                color: Color(0xFF70E8FF),
                size: 18,
              ),
              const SizedBox(height: 5),
              const Text(
                '15.8',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'km/l',
                style: TextStyle(
                  color: Colors.white30,
                  fontSize: 6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _healthCard(
    HealthItem item,
  ) {
    return GestureDetector(
      onTap: () => _showHealthDetails(item),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color:
              Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color:
                Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(14),
                color:
                    item.color.withValues(
                  alpha: 0.055,
                ),
              ),
              child: Icon(
                item.icon,
                color: item.color,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${item.value}%',
                        style: TextStyle(
                          color: item.color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 6.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: item.value / 100,
                      minHeight: 4,
                      backgroundColor:
                          Colors.white.withValues(
                        alpha: 0.06,
                      ),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(
                        item.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0x33FFFFFF),
              size: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceAlert() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            const Color(0xFFFFC857)
                .withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color:
              const Color(0xFFFFC857)
                  .withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 41,
            height: 41,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  const Color(0xFFFFC857)
                      .withValues(alpha: 0.08),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFFFC857),
              size: 20,
            ),
          ),
          const SizedBox(width: 11),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Brake service recommended',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Your brake health is at 78%. Consider a service inspection soon.',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 6.8,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              showMessage(
                'Opening service booking...',
              );
            },
            child: const Text(
              'BOOK',
              style: TextStyle(
                color: Color(0xFFFFC857),
                fontSize: 7,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHealthDetails(
    HealthItem item,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF07152C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              22,
              18,
              22,
              28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(17),
                        color:
                            item.color.withValues(
                          alpha: 0.07,
                        ),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.color,
                        size: 27,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item.status,
                            style: TextStyle(
                              color: item.color,
                              fontSize: 8,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${item.value}%',
                      style: TextStyle(
                        color: item.color,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 21),
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: item.value / 100,
                    minHeight: 8,
                    backgroundColor:
                        Colors.white.withValues(
                      alpha: 0.06,
                    ),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(
                      item.color,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _detailRow(
                  Icons.info_outline_rounded,
                  'Status',
                  item.status,
                ),
                _detailRow(
                  Icons.analytics_outlined,
                  'Health Score',
                  '${item.value} / 100',
                ),
                _detailRow(
                  Icons.update_rounded,
                  'Last Updated',
                  '22 Aug 2026',
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      showMessage(
                        'Detailed ${item.title} report opened.',
                      );
                    },
                    icon: const Icon(
                      Icons.analytics_rounded,
                      size: 17,
                    ),
                    label: const Text(
                      'VIEW DETAILED REPORT',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF147DFF),
                      foregroundColor: Colors.white,
                      minimumSize:
                          const Size(
                        double.infinity,
                        48,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
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

  Widget _detailRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF70E8FF),
            size: 17,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 8,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color:
                Colors.white.withValues(alpha: 0.07),
            borderRadius:
                BorderRadius.circular(14),
            border: Border.all(
              color:
                  Colors.white.withValues(alpha: 0.10),
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

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
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Text(message),
        ),
      );
  }

  Widget _animated(
    int index,
    Widget child,
  ) {
    return AnimatedBuilder(
      animation: entranceController,
      builder: (context, child) {
        final delay = (index * 0.035).clamp(
          0.0,
          0.8,
        );

        final value = (
          (entranceController.value - delay) /
          (1 - delay)
        ).clamp(0.0, 1.0);

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              16 * (1 - value),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class HealthItem {
  final String title;
  final String subtitle;
  final int value;
  final String status;
  final IconData icon;
  final Color color;

  const HealthItem({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.status,
    required this.icon,
    required this.color,
  });
}

class _HealthGaugePainter extends CustomPainter {
  final int score;
  final double scanProgress;

  const _HealthGaugePainter({
    required this.score,
    required this.scanProgress,
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
        math.min(size.width, size.height) / 2 -
        10;

    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(
        alpha: 0.07,
      );

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      math.pi * 0.75,
      math.pi * 1.5,
      false,
      backgroundPaint,
    );

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF70E8FF);

    final scoreProgress =
        (score / 100).clamp(0.0, 1.0);

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      math.pi * 0.75,
      math.pi * 1.5 * scoreProgress,
      false,
      progressPaint,
    );

    if (scanProgress > 0) {
      final scanPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = const Color(0xFF7BFFB2)
            .withValues(alpha: 0.7);

      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius + 9,
        ),
        math.pi * 0.75 +
            math.pi *
                1.5 *
                scanProgress,
        0.22,
        false,
        scanPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _HealthGaugePainter oldDelegate,
  ) {
    return oldDelegate.score != score ||
        oldDelegate.scanProgress != scanProgress;
  }
}

class _HealthAuroraPainter extends CustomPainter {
  final double progress;

  const _HealthAuroraPainter({
    required this.progress,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint();
    final t = progress * math.pi * 2;

    final cyanCenter = Offset(
      size.width *
          (0.18 + math.sin(t) * 0.12),
      size.height *
          (0.18 + math.cos(t) * 0.06),
    );

    paint.shader = RadialGradient(
      colors: [
        const Color(0xFF00E5FF).withValues(
          alpha: 0.075,
        ),
        Colors.transparent,
      ],
    ).createShader(
      Rect.fromCircle(
        center: cyanCenter,
        radius: size.width * 0.65,
      ),
    );

    canvas.drawRect(
      Offset.zero & size,
      paint,
    );

    final purpleCenter = Offset(
      size.width *
          (0.82 + math.cos(t) * 0.10),
      size.height *
          (0.52 + math.sin(t) * 0.07),
    );

    paint.shader = RadialGradient(
      colors: [
        const Color(0xFF8C5CFF).withValues(
          alpha: 0.065,
        ),
        Colors.transparent,
      ],
    ).createShader(
      Rect.fromCircle(
        center: purpleCenter,
        radius: size.width * 0.60,
      ),
    );

    canvas.drawRect(
      Offset.zero & size,
      paint,
    );

    final random = math.Random(42);
    final starPaint = Paint();

    for (int i = 0; i < 45; i++) {
      final x =
          random.nextDouble() * size.width;
      final y =
          random.nextDouble() * size.height;

      final opacity =
          0.15 +
          ((math.sin(t + i) + 1) / 2) * 0.4;

      starPaint.color = Colors.white.withValues(
        alpha: opacity,
      );

      canvas.drawCircle(
        Offset(x, y),
        0.65,
        starPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _HealthAuroraPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}