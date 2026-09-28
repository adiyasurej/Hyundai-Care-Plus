import 'package:flutter/material.dart';

import '../widgets/care_background.dart';

class MaintenanceScheduleScreen extends StatefulWidget {
  final int? customerId;

  const MaintenanceScheduleScreen({
    super.key,
    this.customerId,
  });

  @override
  State<MaintenanceScheduleScreen> createState() =>
      _MaintenanceScheduleScreenState();
}

class _MaintenanceScheduleScreenState
    extends State<MaintenanceScheduleScreen> {
  bool showCompleted = true;

  final List<MaintenanceItem> upcoming = const [
    MaintenanceItem(
      title: 'Regular Service',
      subtitle: 'General inspection & maintenance',
      date: '28 Aug 2026',
      distance: '2,450 km remaining',
      status: 'UPCOMING',
      icon: Icons.build_circle_rounded,
      color: Color(0xFF70E8FF),
    ),
    MaintenanceItem(
      title: 'Engine Oil Check',
      subtitle: 'Oil level & engine inspection',
      date: '12 Sep 2026',
      distance: '3,100 km remaining',
      status: 'UPCOMING',
      icon: Icons.oil_barrel_rounded,
      color: Color(0xFFFFC857),
    ),
    MaintenanceItem(
      title: 'Brake Inspection',
      subtitle: 'Brake pads & brake fluid',
      date: '04 Oct 2026',
      distance: '4,200 km remaining',
      status: 'PLANNED',
      icon: Icons.speed_rounded,
      color: Color(0xFFB28CFF),
    ),
  ];

  final List<MaintenanceItem> completed = const [
    MaintenanceItem(
      title: 'Periodic Maintenance',
      subtitle: 'Full vehicle inspection',
      date: '18 Jun 2026',
      distance: '24,680 km',
      status: 'COMPLETED',
      icon: Icons.verified_rounded,
      color: Color(0xFF7BFFB2),
    ),
    MaintenanceItem(
      title: 'Wheel Alignment',
      subtitle: 'Alignment & balancing',
      date: '03 Apr 2026',
      distance: '21,240 km',
      status: 'COMPLETED',
      icon: Icons.tire_repair_rounded,
      color: Color(0xFF70E8FF),
    ),
    MaintenanceItem(
      title: 'Air Filter Replacement',
      subtitle: 'Air filter inspection & replacement',
      date: '11 Jan 2026',
      distance: '17,890 km',
      status: 'COMPLETED',
      icon: Icons.air_rounded,
      color: Color(0xFFB28CFF),
    ),
  ];

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
                      _healthBanner(),
                      const SizedBox(height: 16),
                      _nextServiceCard(),
                      const SizedBox(height: 20),
                      _sectionHeader(
                        'Maintenance Timeline',
                        Icons.timeline_rounded,
                      ),
                      const SizedBox(height: 12),
                      ...upcoming.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: _maintenanceCard(item),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _completedToggle(),
                      if (showCompleted) ...[
                        const SizedBox(height: 12),
                        ...completed.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: 10,
                            ),
                            child: _maintenanceCard(item),
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      _reminderCard(),
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
        22,
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
                  'Maintenance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Stay ahead of your vehicle maintenance',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          _iconButton(
            Icons.add_alert_rounded,
            _addReminder,
          ),
        ],
      ),
    );
  }

  Widget _healthBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF7BFFB2).withValues(
          alpha: 0.025,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF7BFFB2).withValues(
            alpha: 0.09,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF7BFFB2).withValues(
                alpha: 0.07,
              ),
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: Color(0xFF7BFFB2),
              size: 23,
            ),
          ),
          const SizedBox(width: 11),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vehicle is in good condition',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'No critical maintenance issues detected.',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 6.5,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            '92%',
            style: TextStyle(
              color: Color(0xFF7BFFB2),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _nextServiceCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF102F52),
            Color(0xFF171E4B),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF70E8FF).withValues(
            alpha: 0.11,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.event_available_rounded,
                color: Color(0xFF70E8FF),
                size: 19,
              ),
              SizedBox(width: 8),
              Text(
                'NEXT SERVICE',
                style: TextStyle(
                  color: Color(0xFF70E8FF),
                  fontSize: 6.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              Spacer(),
              Text(
                'IN 2 DAYS',
                style: TextStyle(
                  color: Color(0xFFFFC857),
                  fontSize: 6,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Regular Service',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            '28 Aug 2026 • Hyundai Care+ Anna Nagar',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 7,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _nextInfo(
                  Icons.speed_rounded,
                  'ODOMETER',
                  '27,550 km',
                ),
              ),
              Expanded(
                child: _nextInfo(
                  Icons.calendar_month_rounded,
                  'DATE',
                  '28 Aug',
                ),
              ),
              Expanded(
                child: _nextInfo(
                  Icons.location_on_rounded,
                  'CENTRE',
                  '2.8 km',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _bookService,
              icon: const Icon(
                Icons.calendar_month_rounded,
                size: 15,
              ),
              label: const Text(
                'MANAGE SERVICE',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF147DFF),
                foregroundColor: Colors.white,
                minimumSize: const Size(
                  double.infinity,
                  43,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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

  Widget _nextInfo(
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.white38,
          size: 14,
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white24,
            fontSize: 5,
            letterSpacing: .5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 6.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF70E8FF),
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _maintenanceCard(
    MaintenanceItem item,
  ) {
    final completed = item.status == 'COMPLETED';

    return GestureDetector(
      onTap: () => _showMaintenance(item),
      child: Container(
        padding: const EdgeInsets.all(14),
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
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: item.color.withValues(
                  alpha: 0.06,
                ),
              ),
              child: Icon(
                item.icon,
                color: item.color,
                size: 21,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      color: Colors.white30,
                      fontSize: 6,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Icon(
                        completed
                            ? Icons.check_circle_rounded
                            : Icons.calendar_today_rounded,
                        color: completed
                            ? const Color(0xFF7BFFB2)
                            : item.color,
                        size: 11,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          completed
                              ? item.date
                              : '${item.date} • ${item.distance}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: completed
                                ? const Color(0xFF7BFFB2)
                                : Colors.white38,
                            fontSize: 5.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 7),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: completed
                    ? const Color(0xFF7BFFB2)
                        .withValues(alpha: 0.06)
                    : item.color.withValues(
                        alpha: 0.06,
                      ),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                item.status,
                style: TextStyle(
                  color: completed
                      ? const Color(0xFF7BFFB2)
                      : item.color,
                  fontSize: 4.8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _completedToggle() {
    return GestureDetector(
      onTap: () {
        setState(() {
          showCompleted = !showCompleted;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: 0.025,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.history_rounded,
              color: Colors.white38,
              size: 17,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Completed Maintenance',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              showCompleted
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: Colors.white38,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }

  Widget _reminderCard() {
    return GestureDetector(
      onTap: _addReminder,
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: const Color(0xFFB28CFF).withValues(
            alpha: 0.035,
          ),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: const Color(0xFFB28CFF).withValues(
              alpha: 0.10,
            ),
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.notifications_active_rounded,
              color: Color(0xFFB28CFF),
              size: 23,
            ),
            SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create a maintenance reminder',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Never miss an important service interval.',
                    style: TextStyle(
                      color: Colors.white30,
                      fontSize: 6.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.add_circle_outline_rounded,
              color: Color(0xFFB28CFF),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  void _showMaintenance(
    MaintenanceItem item,
  ) {
    final completed = item.status == 'COMPLETED';

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
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(14),
                        color: item.color.withValues(
                          alpha: 0.07,
                        ),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 19),
                _detailRow(
                  Icons.info_outline_rounded,
                  item.subtitle,
                ),
                _detailRow(
                  Icons.calendar_month_rounded,
                  item.date,
                ),
                _detailRow(
                  Icons.speed_rounded,
                  item.distance,
                ),
                _detailRow(
                  completed
                      ? Icons.check_circle_rounded
                      : Icons.pending_actions_rounded,
                  item.status,
                ),
                const SizedBox(height: 16),
                if (!completed)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        _bookService();
                      },
                      icon: const Icon(
                        Icons.calendar_month_rounded,
                        size: 15,
                      ),
                      label: const Text(
                        'BOOK SERVICE',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF147DFF),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(
                          double.infinity,
                          45,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 7,
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

  Widget _detailRow(
    IconData icon,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 11,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF70E8FF),
            size: 15,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 7.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _bookService() {
    showMessage(
      'Service booking selected.',
    );
  }

  void _addReminder() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF07152C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Maintenance Reminder',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'A reminder will help you stay on top of your next maintenance requirement.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 9,
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
                  fontSize: 7,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                showMessage(
                  'Maintenance reminder created.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF147DFF),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'CREATE',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
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

class MaintenanceItem {
  final String title;
  final String subtitle;
  final String date;
  final String distance;
  final String status;
  final IconData icon;
  final Color color;

  const MaintenanceItem({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.distance,
    required this.status,
    required this.icon,
    required this.color,
  });
}