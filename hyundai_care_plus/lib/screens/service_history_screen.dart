import 'package:flutter/material.dart';

class ServiceHistoryScreen extends StatefulWidget {
  final int? customerId;

  const ServiceHistoryScreen({
    super.key,
    this.customerId,
  });

  @override
  State<ServiceHistoryScreen> createState() =>
      _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState
    extends State<ServiceHistoryScreen> {
  int _selectedTab = 0;

  final List<_ServiceRecord> _records = [
    _ServiceRecord(
      title: 'General Service',
      vehicle: 'Hyundai i20 • TN 07 AB 1234',
      date: '23 Aug 2026',
      center: 'Hyundai Service Center',
      location: 'Chennai',
      amount: '₹4,500.00',
      type: 'Paid',
      icon: Icons.build_circle_rounded,
    ),
    _ServiceRecord(
      title: 'Oil Change',
      vehicle: 'Hyundai i20 • TN 07 AB 1234',
      date: '15 May 2026',
      center: 'Hyundai Service Center',
      location: 'Chennai',
      amount: '₹1,200.00',
      type: 'Paid',
      icon: Icons.oil_barrel_rounded,
    ),
    _ServiceRecord(
      title: 'Wheel Alignment',
      vehicle: 'Hyundai i20 • TN 07 AB 1234',
      date: '10 Mar 2026',
      center: 'Hyundai Service Center',
      location: 'Chennai',
      amount: '₹850.00',
      type: 'Paid',
      icon: Icons.tire_repair_rounded,
    ),
    _ServiceRecord(
      title: 'Free Inspection',
      vehicle: 'Hyundai i20 • TN 07 AB 1234',
      date: '12 Jan 2026',
      center: 'Hyundai Service Center',
      location: 'Chennai',
      amount: 'FREE',
      type: 'Free',
      icon: Icons.fact_check_rounded,
    ),
  ];

  List<_ServiceRecord> get filteredRecords {
    if (_selectedTab == 1) {
      return _records
          .where((record) => record.type == 'Paid')
          .toList();
    }

    if (_selectedTab == 2) {
      return _records
          .where((record) => record.type == 'Free')
          .toList();
    }

    return _records;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: Stack(
        children: [
          const Positioned.fill(
            child: _GalaxyBackground(),
          ),
          SafeArea(
            child: Column(
              children: [
                _header(),
                _tabs(),
                Expanded(
                  child: filteredRecords.isEmpty
                      ? _emptyState()
                      : ListView.builder(
                          padding:
                              const EdgeInsets.fromLTRB(
                            16,
                            12,
                            16,
                            30,
                          ),
                          itemCount:
                              filteredRecords.length,
                          itemBuilder: (context, index) {
                            return _serviceCard(
                              filteredRecords[index],
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        14,
        12,
        14,
        12,
      ),
      child: Row(
        children: [
          _iconButton(
            Icons.arrow_back_rounded,
            () => Navigator.pop(context),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Service History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Your complete service journey',
                  style: TextStyle(
                    color: Color(0x88FFFFFF),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _iconButton(
            Icons.refresh_rounded,
            () {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    const labels = [
      'All',
      'Paid',
      'Free',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: Row(
        children: List.generate(
          labels.length,
          (index) {
            final selected =
                _selectedTab == index;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTab = index;
                  });
                },
                child: AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 180),
                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF1687FF)
                        : Colors.white
                            .withValues(alpha: 0.055),
                    borderRadius:
                        BorderRadius.circular(14),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF55DFFF)
                          : Colors.white
                              .withValues(alpha: 0.08),
                    ),
                  ),
                  child: Text(
                    labels[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : Colors.white60,
                      fontSize: 13,
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _serviceCard(
    _ServiceRecord record,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white
            .withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: const Color(0xFF70E8FF)
              .withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF1687FF)
                      .withValues(alpha: 0.12),
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: Icon(
                  record.icon,
                  color: const Color(0xFF70E8FF),
                  size: 27,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.vehicle,
                      style: const TextStyle(
                        color: Color(0x99FFFFFF),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _statusChip(record.type),
            ],
          ),
          const SizedBox(height: 17),
          _detailRow(
            Icons.calendar_today_rounded,
            'Service Date',
            record.date,
          ),
          _detailRow(
            Icons.location_on_rounded,
            'Service Center',
            '${record.center}, ${record.location}',
          ),
          _detailRow(
            Icons.payments_rounded,
            'Service Cost',
            record.amount,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showDetails(record);
              },
              icon: const Icon(
                Icons.visibility_rounded,
                size: 17,
              ),
              label: const Text(
                'VIEW DETAILS',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    const Color(0xFF70E8FF),
                side: BorderSide(
                  color: const Color(0xFF70E8FF)
                      .withValues(alpha: 0.30),
                ),
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String type) {
    final free = type == 'Free';

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: (free
                ? const Color(0xFF62E6A7)
                : const Color(0xFF70E8FF))
            .withValues(alpha: 0.10),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: free
              ? const Color(0xFF62E6A7)
              : const Color(0xFF70E8FF),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _detailRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white38,
            size: 17,
          ),
          const SizedBox(width: 9),
          Text(
            '$title  ',
            style: const TextStyle(
              color: Color(0x70FFFFFF),
              fontSize: 12,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.history_rounded,
            color: Color(0x6670E8FF),
            size: 70,
          ),
          const SizedBox(height: 15),
          const Text(
            'No Service Records',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Your completed services will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.white
          .withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 45,
          height: 45,
          child: Icon(
            icon,
            color: Colors.white,
            size: 21,
          ),
        ),
      ),
    );
  }

  void _showDetails(
    _ServiceRecord record,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A1830),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                record.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                record.vehicle,
                style: const TextStyle(
                  color: Color(0xFF70E8FF),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Date: ${record.date}\n'
                'Center: ${record.center}, ${record.location}\n'
                'Amount: ${record.amount}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pop(context),
                  child: const Text('CLOSE'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ServiceRecord {
  final String title;
  final String vehicle;
  final String date;
  final String center;
  final String location;
  final String amount;
  final String type;
  final IconData icon;

  const _ServiceRecord({
    required this.title,
    required this.vehicle,
    required this.date,
    required this.center,
    required this.location,
    required this.amount,
    required this.type,
    required this.icon,
  });
}

class _GalaxyBackground extends StatelessWidget {
  const _GalaxyBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF031426),
            Color(0xFF071D37),
            Color(0xFF100B2A),
          ],
        ),
      ),
    );
  }
}