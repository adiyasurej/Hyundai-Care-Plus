import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/care_background.dart';

class VehicleTrackingScreen extends StatefulWidget {
  final int? customerId;

  const VehicleTrackingScreen({
    super.key,
    this.customerId,
  });

  @override
  State<VehicleTrackingScreen> createState() =>
      _VehicleTrackingScreenState();
}

class _VehicleTrackingScreenState
    extends State<VehicleTrackingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _auroraController;
  late final AnimationController _pulseController;
  late final AnimationController _entranceController;

  bool trackingEnabled = true;
  bool securityEnabled = true;
  bool locationSharing = true;
  bool refreshing = false;

  double fuel = 68;
  double battery = 91;

  String vehicleStatus = 'Parked safely';
  String lastUpdated = 'Just now';

  final List<TripData> recentTrips = const [
    TripData(
      destination: 'Chennai Central',
      date: 'Today • 09:42 AM',
      distance: '14.8 km',
      duration: '32 min',
      icon: Icons.location_city_rounded,
    ),
    TripData(
      destination: 'OMR Service Centre',
      date: 'Yesterday • 03:18 PM',
      distance: '21.4 km',
      duration: '41 min',
      icon: Icons.build_circle_rounded,
    ),
    TripData(
      destination: 'Anna Nagar',
      date: '20 Aug • 06:12 PM',
      distance: '9.6 km',
      duration: '24 min',
      icon: Icons.home_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _auroraController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();
  }

  @override
  void dispose() {
    _auroraController.dispose();
    _pulseController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _auroraController,
            builder: (context, child) {
              return CustomPaint(
                painter: _TrackingAuroraPainter(
                  progress: _auroraController.value,
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
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                _animated(0, _buildVehicleStatus()),
                const SizedBox(height: 15),
                _animated(1, _buildMap()),
                const SizedBox(height: 15),
                _animated(2, _buildLocationDetails()),
                const SizedBox(height: 15),
                _animated(3, _buildTripStats()),
                const SizedBox(height: 15),
                _animated(4, _buildVehicleInfo()),
                const SizedBox(height: 15),
                _animated(5, _buildSecurityCard()),
                const SizedBox(height: 15),
                _animated(6, _buildRecentTrips()),
                const SizedBox(height: 20),
                _animated(7, _buildEmergencyCard()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
      child: Row(
        children: [
          _circleButton(
            Icons.arrow_back_ios_new_rounded,
            () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vehicle Tracking',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Stay connected with your Hyundai',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          _circleButton(
            Icons.refresh_rounded,
            _refreshLocation,
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleStatus() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF102F50),
            Color(0xFF171E4B),
            Color(0xFF093C41),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF70E8FF).withValues(alpha: 0.13),
        ),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final glow = 0.12 + _pulseController.value * 0.10;

              return Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: trackingEnabled
                      ? const Color(0xFF7BFFB2).withValues(alpha: 0.07)
                      : Colors.white.withValues(alpha: 0.05),
                  boxShadow: trackingEnabled
                      ? [
                          BoxShadow(
                            color: const Color(0xFF7BFFB2)
                                .withValues(alpha: glow),
                            blurRadius: 18,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  trackingEnabled
                      ? Icons.gps_fixed_rounded
                      : Icons.gps_off_rounded,
                  color: trackingEnabled
                      ? const Color(0xFF7BFFB2)
                      : Colors.white38,
                  size: 23,
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hyundai Creta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  trackingEnabled ? vehicleStatus : 'Tracking paused',
                  style: TextStyle(
                    color: trackingEnabled
                        ? const Color(0xFF7BFFB2)
                        : Colors.white38,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: trackingEnabled,
            onChanged: (value) {
              setState(() {
                trackingEnabled = value;
                vehicleStatus =
                    value ? 'Parked safely' : 'Tracking paused';
              });

              showMessage(
                value
                    ? 'Vehicle tracking enabled.'
                    : 'Vehicle tracking paused.',
              );
            },
            activeThumbColor: const Color(0xFF70E8FF),
            activeTrackColor:
                const Color(0xFF70E8FF).withValues(alpha: 0.25),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Container(
      height: 300,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _auroraController,
            builder: (context, child) {
              return CustomPaint(
                painter: _PremiumMapPainter(
                  animated: _auroraController.value,
                ),
              );
            },
          ),
          Positioned(
            left: 18,
            top: 17,
            child: _mapChip(
              Icons.location_on_rounded,
              trackingEnabled
                  ? 'LIVE LOCATION'
                  : 'LOCATION PAUSED',
              trackingEnabled
                  ? const Color(0xFF7BFFB2)
                  : Colors.white38,
            ),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              children: [
                _mapControl(
                  Icons.add_rounded,
                  () => showMessage('Map zoomed in.'),
                ),
                const SizedBox(height: 7),
                _mapControl(
                  Icons.remove_rounded,
                  () => showMessage('Map zoomed out.'),
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final scale = 1 + _pulseController.value * 0.12;

              return Center(
                child: Transform.scale(
                  scale: scale,
                  child: _vehicleMarker(),
                ),
              );
            },
          ),
          Positioned(
            left: 17,
            right: 17,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF07152C).withValues(alpha: 0.93),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.place_rounded,
                    color: Color(0xFF70E8FF),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Anna Nagar, Chennai',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Last known vehicle location',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 6.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    lastUpdated,
                    style: const TextStyle(
                      color: Color(0xFF7BFFB2),
                      fontSize: 7,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vehicleMarker() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF70E8FF).withValues(alpha: 0.08),
      ),
      child: Center(
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF0A2B46),
            border: Border.all(
              color: const Color(0xFF70E8FF).withValues(alpha: 0.75),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF70E8FF).withValues(alpha: 0.22),
                blurRadius: 17,
              ),
            ],
          ),
          child: const Icon(
            Icons.directions_car_filled_rounded,
            color: Color(0xFF70E8FF),
            size: 23,
          ),
        ),
      ),
    );
  }

  Widget _mapChip(
    IconData icon,
    String title,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF07152C).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 5),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 6.5,
              fontWeight: FontWeight.bold,
              letterSpacing: .5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapControl(
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 37,
          height: 37,
          decoration: BoxDecoration(
            color: const Color(0xFF07152C).withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white70,
            size: 17,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.location_searching_rounded,
                color: Color(0xFF70E8FF),
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Location Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _locationRow(
            Icons.location_on_rounded,
            'Current area',
            'Anna Nagar, Chennai',
          ),
          _locationRow(
            Icons.speed_rounded,
            'Current speed',
            trackingEnabled ? '0 km/h' : 'Unavailable',
          ),
          _locationRow(
            Icons.schedule_rounded,
            'Last updated',
            lastUpdated,
          ),
          _locationRow(
            Icons.gps_fixed_rounded,
            'GPS accuracy',
            trackingEnabled ? 'High accuracy' : 'Tracking disabled',
          ),
        ],
      ),
    );
  }

  Widget _locationRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white30,
            size: 16,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 8,
              ),
            ),
          ),
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

  Widget _buildTripStats() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            Icons.route_rounded,
            '14.8 km',
            'Last Trip',
            const Color(0xFF70E8FF),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _statCard(
            Icons.timer_outlined,
            '32 min',
            'Drive Time',
            const Color(0xFFB28CFF),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _statCard(
            Icons.speed_rounded,
            '42 km/h',
            'Avg Speed',
            const Color(0xFF7BFFB2),
          ),
        ),
      ],
    );
  }

  Widget _statCard(
    IconData icon,
    String value,
    String title,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white30,
              fontSize: 5.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.analytics_rounded,
                color: Color(0xFF70E8FF),
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Vehicle Information',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _vehicleMetric(
                  Icons.local_gas_station_rounded,
                  'Fuel',
                  '${fuel.round()}%',
                  fuel / 100,
                  const Color(0xFF70E8FF),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _vehicleMetric(
                  Icons.battery_full_rounded,
                  'Battery',
                  '${battery.round()}%',
                  battery / 100,
                  const Color(0xFF7BFFB2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _vehicleMetric(
    IconData icon,
    String title,
    String value,
    double progress,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.025),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 17),
              const SizedBox(width: 7),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 7,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: Colors.white.withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: securityEnabled
            ? const Color(0xFF7BFFB2).withValues(alpha: 0.025)
            : const Color(0xFFFFC857).withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: securityEnabled
              ? const Color(0xFF7BFFB2).withValues(alpha: 0.10)
              : const Color(0xFFFFC857).withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: securityEnabled
                  ? const Color(0xFF7BFFB2).withValues(alpha: 0.07)
                  : const Color(0xFFFFC857).withValues(alpha: 0.07),
            ),
            child: Icon(
              securityEnabled
                  ? Icons.shield_rounded
                  : Icons.shield_outlined,
              color: securityEnabled
                  ? const Color(0xFF7BFFB2)
                  : const Color(0xFFFFC857),
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Vehicle Security',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  securityEnabled
                      ? 'Security monitoring is active'
                      : 'Security monitoring is paused',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 6.8,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: securityEnabled,
            onChanged: (value) {
              setState(() {
                securityEnabled = value;
              });

              showMessage(
                value
                    ? 'Vehicle security enabled.'
                    : 'Vehicle security paused.',
              );
            },
            activeThumbColor: const Color(0xFF7BFFB2),
            activeTrackColor:
                const Color(0xFF7BFFB2).withValues(alpha: 0.25),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTrips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Recent Trips',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _showAllTrips,
              child: const Text(
                'View all',
                style: TextStyle(
                  color: Color(0xFF70E8FF),
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 11),
        ...recentTrips.map(
          (trip) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: _tripCard(trip),
          ),
        ),
      ],
    );
  }

  Widget _tripCard(TripData trip) {
    return GestureDetector(
      onTap: () => _showTripDetails(trip),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.035),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 41,
              height: 41,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF70E8FF).withValues(alpha: 0.05),
              ),
              child: Icon(
                trip.icon,
                color: const Color(0xFF70E8FF),
                size: 19,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.destination,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    trip.date,
                    style: const TextStyle(
                      color: Colors.white30,
                      fontSize: 6,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  trip.distance,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  trip.duration,
                  style: const TextStyle(
                    color: Colors.white24,
                    fontSize: 6,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 9),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0x33FFFFFF),
              size: 9,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard() {
    return GestureDetector(
      onTap: _showEmergencyDialog,
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: const Color(0xFFFF4F67).withValues(alpha: 0.045),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFFF4F67).withValues(alpha: 0.12),
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.emergency_rounded,
              color: Color(0xFFFF6578),
              size: 25,
            ),
            SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Need emergency assistance?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Get roadside assistance for your vehicle.',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 6.8,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFFFF6578),
              size: 11,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshLocation() async {
    if (refreshing) {
      return;
    }

    setState(() {
      refreshing = true;
      lastUpdated = 'Updating...';
    });

    await Future<void>.delayed(
      const Duration(milliseconds: 900),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      refreshing = false;
      lastUpdated = 'Just now';
      vehicleStatus = 'Location updated just now';
    });

    showMessage('Vehicle location updated.');

    await Future<void>.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      vehicleStatus = 'Parked safely';
    });
  }

  void _toggleLocationSharing(bool value) {
    setState(() {
      locationSharing = value;
    });

    showMessage(
      value
          ? 'Vehicle location sharing enabled.'
          : 'Vehicle location sharing disabled.',
    );
  }

  void _showTripDetails(TripData trip) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF07152C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sheetHandle(),
                const SizedBox(height: 20),
                const Text(
                  'Trip Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                _bottomDetail(
                  Icons.location_on_rounded,
                  'Destination',
                  trip.destination,
                ),
                _bottomDetail(
                  Icons.calendar_today_rounded,
                  'Date',
                  trip.date,
                ),
                _bottomDetail(
                  Icons.route_rounded,
                  'Distance',
                  trip.distance,
                ),
                _bottomDetail(
                  Icons.timer_rounded,
                  'Duration',
                  trip.duration,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF147DFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'DONE',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
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

  Widget _sheetHandle() {
    return Center(
      child: Container(
        width: 42,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _bottomDetail(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
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
              fontSize: 9,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAllTrips() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF07152C),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _sheetHandle(),
                const SizedBox(height: 18),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Trip History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                ...recentTrips.map(
                  (trip) => Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: _tripCard(trip),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEmergencyDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF07152C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Emergency Assistance',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Request roadside assistance for your vehicle location?',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 10,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'CANCEL',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 8,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                showMessage(
                  'Roadside assistance request started.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4F67),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'REQUEST HELP',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
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
            color: Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.10),
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

  void showMessage(String message) {
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
          content: Text(
            message,
            style: const TextStyle(fontSize: 11),
          ),
        ),
      );
  }

  Widget _animated(
    int index,
    Widget child,
  ) {
    return AnimatedBuilder(
      animation: _entranceController,
      builder: (context, animatedChild) {
        final delay = index * 0.04;
        final value = ((_entranceController.value - delay) /
                (1 - delay))
            .clamp(0.0, 1.0);

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - value)),
            child: animatedChild,
          ),
        );
      },
      child: child,
    );
  }
}

class TripData {
  final String destination;
  final String date;
  final String distance;
  final String duration;
  final IconData icon;

  const TripData({
    required this.destination,
    required this.date,
    required this.distance,
    required this.duration,
    required this.icon,
  });
}

class _PremiumMapPainter extends CustomPainter {
  final double animated;

  _PremiumMapPainter({
    required this.animated,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()
      ..color = const Color(0xFF081B2D);

    canvas.drawRect(
      Offset.zero & size,
      background,
    );

    final roadPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 16
      ..color = const Color(0xFF102D42);

    final road1 = Path()
      ..moveTo(-30, size.height * 0.78)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.58,
        size.width * 0.35,
        size.height * 0.70,
        size.width * 0.52,
        size.height * 0.42,
      )
      ..cubicTo(
        size.width * 0.66,
        size.height * 0.20,
        size.width * 0.80,
        size.height * 0.36,
        size.width + 30,
        size.height * 0.12,
      );

    canvas.drawPath(road1, roadPaint);

    final road2 = Path()
      ..moveTo(size.width * 0.08, -20)
      ..cubicTo(
        size.width * 0.24,
        size.height * 0.25,
        size.width * 0.46,
        size.height * 0.31,
        size.width * 0.64,
        size.height * 0.58,
      )
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.76,
        size.width * 0.84,
        size.height * 0.82,
        size.width + 20,
        size.height * 0.90,
      );

    canvas.drawPath(road2, roadPaint);

    roadPaint
      ..strokeWidth = 5
      ..color = const Color(0xFF0D2539);

    for (int i = 0; i < 7; i++) {
      final path = Path()
        ..moveTo(
          -20,
          size.height * (0.10 + i * 0.14),
        )
        ..cubicTo(
          size.width * 0.28,
          size.height * (0.03 + i * 0.14),
          size.width * 0.55,
          size.height * (0.20 + i * 0.08),
          size.width + 20,
          size.height * (0.05 + i * 0.13),
        );

      canvas.drawPath(path, roadPaint);
    }

    final routePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF70E8FF);

    final route = Path()
      ..moveTo(
        size.width * 0.10,
        size.height * 0.72,
      )
      ..cubicTo(
        size.width * 0.27,
        size.height * 0.60,
        size.width * 0.37,
        size.height * 0.66,
        size.width * 0.50,
        size.height * 0.46,
      )
      ..cubicTo(
        size.width * 0.62,
        size.height * 0.28,
        size.width * 0.72,
        size.height * 0.40,
        size.width * 0.90,
        size.height * 0.23,
      );

    canvas.drawPath(route, routePaint);

    final random = math.Random(8);
    final blockPaint = Paint()
      ..color = const Color(0xFF0B263A);

    for (int i = 0; i < 38; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final width = 8 + random.nextDouble() * 17;
      final height = 5 + random.nextDouble() * 12;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, width, height),
          const Radius.circular(2),
        ),
        blockPaint,
      );
    }

    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF70E8FF).withValues(alpha: 0.13),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(
            size.width * 0.50,
            size.height * 0.46,
          ),
          radius: 105,
        ),
      );

    canvas.drawCircle(
      Offset(
        size.width * 0.50,
        size.height * 0.46,
      ),
      105,
      glow,
    );

    final pulse =
        (math.sin(animated * math.pi * 2) + 1) / 2;

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0xFF70E8FF).withValues(alpha: 0.22);

    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(
        Offset(
          size.width * 0.50,
          size.height * 0.46,
        ),
        32 + i * 21 + pulse * 10,
        ringPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PremiumMapPainter oldDelegate) {
    return oldDelegate.animated != animated;
  }
}

class _TrackingAuroraPainter extends CustomPainter {
  final double progress;

  _TrackingAuroraPainter({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final t = progress * math.pi * 2;

    final cyanCenter = Offset(
      size.width * (0.18 + math.sin(t) * 0.12),
      size.height * (0.18 + math.cos(t) * 0.06),
    );

    paint.shader = RadialGradient(
      colors: [
        const Color(0xFF00E5FF).withValues(alpha: 0.075),
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
      size.width * (0.82 + math.cos(t) * 0.10),
      size.height * (0.52 + math.sin(t) * 0.07),
    );

    paint.shader = RadialGradient(
      colors: [
        const Color(0xFF8C5CFF).withValues(alpha: 0.065),
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
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;

      final opacity =
          0.15 + ((math.sin(t + i) + 1) / 2) * 0.4;

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
    covariant _TrackingAuroraPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}