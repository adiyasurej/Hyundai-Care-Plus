import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/care_background.dart';

class RoadsideAssistanceScreen extends StatefulWidget {
  final int? customerId;

  const RoadsideAssistanceScreen({
    super.key,
    this.customerId,
  });

  @override
  State<RoadsideAssistanceScreen> createState() =>
      _RoadsideAssistanceScreenState();
}

class _RoadsideAssistanceScreenState
    extends State<RoadsideAssistanceScreen> {
  bool requestActive = false;
  bool locationSharing = true;

  String selectedService = '';

  Timer? _timer;
  int etaMinutes = 12;

  final List<AssistanceService> services = const [
    AssistanceService(
      title: 'Battery',
      subtitle: 'Jump start / battery issue',
      icon: Icons.battery_alert_rounded,
      color: Color(0xFFFFC857),
    ),
    AssistanceService(
      title: 'Flat Tyre',
      subtitle: 'Tyre replacement assistance',
      icon: Icons.tire_repair_rounded,
      color: Color(0xFF70E8FF),
    ),
    AssistanceService(
      title: 'Fuel Delivery',
      subtitle: 'Emergency fuel assistance',
      icon: Icons.local_gas_station_rounded,
      color: Color(0xFF7BFFB2),
    ),
    AssistanceService(
      title: 'Towing',
      subtitle: 'Vehicle towing service',
      icon: Icons.local_shipping_rounded,
      color: Color(0xFFB28CFF),
    ),
    AssistanceService(
      title: 'Lockout',
      subtitle: 'Keys locked inside vehicle',
      icon: Icons.lock_open_rounded,
      color: Color(0xFFFF7A90),
    ),
    AssistanceService(
      title: 'Other',
      subtitle: 'Something else',
      icon: Icons.more_horiz_rounded,
      color: Color(0xFF70E8FF),
    ),
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: CareBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _header(),
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
                      _emergencyBanner(),
                      const SizedBox(height: 17),
                      if (requestActive) ...[
                        _activeRequestCard(),
                        const SizedBox(height: 17),
                      ],
                      _locationCard(),
                      const SizedBox(height: 19),
                      _sectionHeader(),
                      const SizedBox(height: 11),
                      _serviceGrid(),
                      const SizedBox(height: 19),
                      _quickEmergencyCard(),
                      const SizedBox(height: 19),
                      _safetyCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        12,
        18,
        21,
      ),
      child: Row(
        children: [
          _iconButton(
            Icons.arrow_back_ios_new_rounded,
            () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Roadside Assistance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Help whenever and wherever you need it',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 8.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF7BFFB2).withValues(
                alpha: 0.06,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF7BFFB2).withValues(
                  alpha: 0.12,
                ),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  color: Color(0xFF7BFFB2),
                  size: 6,
                ),
                SizedBox(width: 5),
                Text(
                  '24/7',
                  style: TextStyle(
                    color: Color(0xFF7BFFB2),
                    fontSize: 6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emergencyBanner() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF321323),
            Color(0xFF21132B),
          ],
        ),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: const Color(0xFFFF6578).withValues(
            alpha: 0.14,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF6578).withValues(
                    alpha: 0.08,
                  ),
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: Color(0xFFFF6578),
                  size: 25,
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need immediate help?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Our roadside support team is available 24/7.',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 6.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _startEmergencyRequest,
              icon: const Icon(
                Icons.sos_rounded,
                size: 19,
              ),
              label: const Text(
                'REQUEST EMERGENCY ASSISTANCE',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF405B),
                foregroundColor: Colors.white,
                minimumSize: const Size(
                  double.infinity,
                  47,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                textStyle: const TextStyle(
                  fontSize: 6.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _activeRequestCard() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF70E8FF).withValues(
          alpha: 0.035,
        ),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: const Color(0xFF70E8FF).withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF70E8FF).withValues(
                    alpha: 0.07,
                  ),
                ),
                child: const Icon(
                  Icons.local_shipping_rounded,
                  color: Color(0xFF70E8FF),
                  size: 21,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ASSISTANCE ON THE WAY',
                      style: TextStyle(
                        color: Color(0xFF70E8FF),
                        fontSize: 6,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Support vehicle is being dispatched',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$etaMinutes min',
                style: const TextStyle(
                  color: Color(0xFF70E8FF),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.68,
              minHeight: 5,
              backgroundColor: Colors.white.withValues(
                alpha: 0.06,
              ),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                Color(0xFF70E8FF),
              ),
            ),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: Color(0xFF7BFFB2),
                size: 13,
              ),
              const SizedBox(width: 5),
              const Expanded(
                child: Text(
                  'Your location has been shared with the assistance team.',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 6,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _cancelRequest,
                child: const Text(
                  'CANCEL',
                  style: TextStyle(
                    color: Color(0xFFFF6578),
                    fontSize: 5.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _locationCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.035,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.06,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF70E8FF).withValues(
                alpha: 0.06,
              ),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: Color(0xFF70E8FF),
              size: 21,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assistance location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Anna Nagar, Chennai',
                  style: TextStyle(
                    color: Colors.white30,
                    fontSize: 6.5,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: locationSharing,
            onChanged: (value) {
              setState(() {
                locationSharing = value;
              });

              showMessage(
                value
                    ? 'Location sharing enabled.'
                    : 'Location sharing disabled.',
              );
            },
            activeThumbColor: const Color(0xFF70E8FF),
            activeTrackColor:
                const Color(0xFF70E8FF).withValues(
              alpha: 0.20,
            ),
            inactiveThumbColor: Colors.white30,
            inactiveTrackColor: Colors.white10,
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader() {
    return const Row(
      children: [
        Icon(
          Icons.build_circle_rounded,
          color: Color(0xFF70E8FF),
          size: 18,
        ),
        SizedBox(width: 8),
        Text(
          'Choose Assistance',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _serviceGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.62,
      ),
      itemBuilder: (context, index) {
        return _serviceCard(services[index]);
      },
    );
  }

  Widget _serviceCard(
    AssistanceService service,
  ) {
    final selected = selectedService == service.title;

    return GestureDetector(
      onTap: () {
        if (selected) {
          setState(() {
            selectedService = '';
          });
          return;
        }

        _confirmService(service);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: selected
              ? service.color.withValues(alpha: 0.07)
              : Colors.white.withValues(alpha: 0.035),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? service.color.withValues(alpha: 0.25)
                : Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 37,
                  height: 37,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    color: service.color.withValues(
                      alpha: 0.07,
                    ),
                  ),
                  child: Icon(
                    service.icon,
                    color: service.color,
                    size: 19,
                  ),
                ),
                const Spacer(),
                if (selected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: service.color,
                    size: 16,
                  ),
              ],
            ),
            const Spacer(),
            Text(
              service.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              service.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white30,
                fontSize: 5.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickEmergencyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6578).withValues(
          alpha: 0.025,
        ),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFFF6578).withValues(
            alpha: 0.08,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.flash_on_rounded,
                color: Color(0xFFFFC857),
                size: 18,
              ),
              SizedBox(width: 7),
              Text(
                'Quick Emergency',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _quickAction(
                  Icons.call_rounded,
                  'CALL SUPPORT',
                  () {
                    showMessage(
                      'Calling roadside support...',
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _quickAction(
                  Icons.local_shipping_rounded,
                  'REQUEST TOW',
                  () {
                    _selectQuickService('Towing');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickAction(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: 0.035,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFF70E8FF),
              size: 19,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 5.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _safetyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.025,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.shield_rounded,
            color: Color(0xFF7BFFB2),
            size: 21,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Stay safe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'If you are in immediate danger, contact local emergency services first.',
                  style: TextStyle(
                    color: Colors.white30,
                    fontSize: 6,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmService(
    AssistanceService service,
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
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: service.color.withValues(
                      alpha: 0.07,
                    ),
                  ),
                  child: Icon(
                    service.icon,
                    color: service.color,
                    size: 27,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  service.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  service.subtitle,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 7,
                  ),
                ),
                const SizedBox(height: 17),
                const Text(
                  'Request roadside assistance at your current location?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 8,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white54,
                          side: BorderSide(
                            color: Colors.white.withValues(
                              alpha: 0.10,
                            ),
                          ),
                          minimumSize: const Size(0, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'CANCEL',
                          style: TextStyle(
                            fontSize: 7,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          _startAssistance(
                            service.title,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF147DFF),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'REQUEST HELP',
                          style: TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  void _startEmergencyRequest() {
    _startAssistance('Emergency Assistance');
  }

  void _startAssistance(
    String service,
  ) {
    if (!locationSharing) {
      showMessage(
        'Please enable location sharing first.',
      );
      return;
    }

    _timer?.cancel();

    setState(() {
      requestActive = true;
      selectedService = service;
      etaMinutes = 12;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) {
        if (!mounted || !requestActive) {
          timer.cancel();
          return;
        }

        if (etaMinutes > 3) {
          setState(() {
            etaMinutes--;
          });
        }
      },
    );

    showMessage(
      '$service request created.',
    );
  }

  void _selectQuickService(
    String service,
  ) {
    _startAssistance(service);
  }

  void _cancelRequest() {
    _timer?.cancel();

    setState(() {
      requestActive = false;
      selectedService = '';
      etaMinutes = 12;
    });

    showMessage(
      'Assistance request cancelled.',
    );
  }

  Widget _iconButton(
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
            color: Colors.white.withValues(
              alpha: 0.07,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.10,
              ),
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
    if (!mounted) return;

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
}

class AssistanceService {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const AssistanceService({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}