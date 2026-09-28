import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/care_background.dart';

class ServiceStatusScreen extends StatefulWidget {
  final int customerId;

  const ServiceStatusScreen({
    super.key,
    required this.customerId,
  });

  @override
  State<ServiceStatusScreen> createState() =>
      _ServiceStatusScreenState();
}

class _ServiceStatusScreenState
    extends State<ServiceStatusScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  bool _loading = true;
  bool _connectionError = false;
  String _errorMessage = '';

  List<ServiceStatusItem> _services = [];

  int _selectedTab = 0;

  static const Color background = Color(0xFF020817);
  static const Color card = Color(0xFF0B172B);
  static const Color cyan = Color(0xFF70E8FF);
  static const Color blue = Color(0xFF287BFF);
  static const Color purple = Color(0xFF8C6CFF);
  static const Color green = Color(0xFF62E6A7);
  static const Color yellow = Color(0xFFFFC857);
  static const Color red = Color(0xFFFF687E);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _loadServices();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ============================================================
  // API
  // ============================================================

  Future<void> _loadServices() async {
    if (!mounted) return;

    setState(() {
      _loading = true;
      _connectionError = false;
      _errorMessage = '';
    });

    try {
      /*
       * IMPORTANT:
       * Replace this URL with your PC's LAN IP when testing
       * on a physical Galaxy device.
       *
       * Example:
       * http://192.168.1.7/hyundai_care_plus_api/service_status.php
       */
      final uri = Uri.parse(
        'http://192.168.1.7/hyundai_care_plus_api/service_status.php'
        '?customer_id=${widget.customerId}',
      );

      final response = await http
          .get(uri)
          .timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode != 200) {
        throw Exception(
          'Server returned ${response.statusCode}',
        );
      }

      final decoded = jsonDecode(response.body);

      final List<dynamic> rawList;

      if (decoded is List) {
        rawList = decoded;
      } else if (decoded is Map<String, dynamic>) {
        final data = decoded['data'];

        if (data is List) {
          rawList = data;
        } else if (decoded['services'] is List) {
          rawList = decoded['services'];
        } else {
          rawList = [];
        }
      } else {
        rawList = [];
      }

      final parsed = rawList
          .whereType<Map>()
          .map(
            (item) => ServiceStatusItem.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();

      if (!mounted) return;

      setState(() {
        _services = parsed;
        _loading = false;
        _connectionError = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _connectionError = true;
        _errorMessage =
            'Unable to connect to the service server.';
      });
    }
  }

  // ============================================================
  // FILTER
  // ============================================================

  List<ServiceStatusItem> get _filteredServices {
    if (_selectedTab == 0) {
      return _services
          .where(
            (service) =>
                service.isPending,
          )
          .toList();
    }

    return _services
        .where(
          (service) =>
              !service.isPending,
        )
        .toList();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const CareBackground(
            child: SizedBox.expand(),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        12,
        18,
        12,
      ),
      child: Row(
        children: [
          _iconButton(
            Icons.arrow_back_ios_new_rounded,
            () => Navigator.pop(context),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Service Status',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Track your vehicle service',
                  style: TextStyle(
                    color: Color(0x99FFFFFF),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          _iconButton(
            Icons.refresh_rounded,
            _loadServices,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildContent() {
    if (_loading) {
      return _buildLoading();
    }

    if (_connectionError) {
      return _buildConnectionError();
    }

    return RefreshIndicator(
      color: cyan,
      backgroundColor: card,
      onRefresh: _loadServices,
      child: CustomScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              18,
              10,
              18,
              30,
            ),
            sliver: SliverList(
              delegate:
                  SliverChildListDelegate(
                [
                  _buildSummary(),
                  const SizedBox(height: 18),
                  _buildTabs(),
                  const SizedBox(height: 16),
                  if (_filteredServices.isEmpty)
                    _buildEmptyState()
                  else
                    ...List.generate(
                      _filteredServices.length,
                      (index) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 14,
                          ),
                          child: _animated(
                            index,
                            _buildServiceCard(
                              _filteredServices[index],
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 10),
                  _buildBookButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUMMARY
  // ============================================================

  Widget _buildSummary() {
    final pendingCount = _services
        .where(
          (item) => item.isPending,
        )
        .length;

    final completedCount = _services
        .where(
          (item) => !item.isPending,
        )
        .length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF102C50),
            Color(0xFF211743),
          ],
        ),
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0x1870E8FF),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _summaryItem(
              Icons.pending_actions_rounded,
              'Pending',
              pendingCount.toString(),
              yellow,
            ),
          ),
          Container(
            width: 1,
            height: 42,
            color: Colors.white12,
          ),
          Expanded(
            child: _summaryItem(
              Icons.check_circle_rounded,
              'Completed',
              completedCount.toString(),
              green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 25,
        ),
        const SizedBox(height: 7),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(
            color: Color(0x99FFFFFF),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TABS
  // ============================================================

  Widget _buildTabs() {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.045,
        ),
        borderRadius:
            BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.06,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _tab(
              'Pending',
              0,
              Icons.pending_actions_rounded,
            ),
          ),
          Expanded(
            child: _tab(
              'Completed',
              1,
              Icons.check_circle_outline_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(
    String title,
    int index,
    IconData icon,
  ) {
    final selected =
        _selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: selected
              ? cyan.withValues(alpha: 0.11)
              : Colors.transparent,
          borderRadius:
              BorderRadius.circular(11),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected
                  ? cyan
                  : Colors.white54,
            ),
            const SizedBox(width: 7),
            Text(
              title,
              style: TextStyle(
                color: selected
                    ? cyan
                    : Colors.white54,
                fontSize: 13,
                fontWeight: selected
                    ? FontWeight.bold
                    : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SERVICE CARD
  // ============================================================

  Widget _buildServiceCard(
    ServiceStatusItem service,
  ) {
    final statusColor =
        service.isPending ? yellow : green;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.045,
        ),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withValues(
            alpha: 0.18,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: cyan.withValues(
                    alpha: 0.08,
                  ),
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.build_circle_rounded,
                  color: cyan,
                  size: 28,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.serviceType,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      service.vehicleName,
                      style: const TextStyle(
                        color: Color(0xB3FFFFFF),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              _statusBadge(
                service.status,
                statusColor,
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(
            color: Color(0x12FFFFFF),
            height: 1,
          ),
          const SizedBox(height: 16),
          _detailRow(
            Icons.calendar_today_rounded,
            'Service Date',
            service.date,
          ),
          const SizedBox(height: 12),
          _detailRow(
            Icons.access_time_rounded,
            'Preferred Time',
            service.time,
          ),
          const SizedBox(height: 12),
          _detailRow(
            Icons.location_on_rounded,
            'Service Centre',
            service.serviceCenter,
          ),
          if (service.mechanic.isNotEmpty) ...[
            const SizedBox(height: 12),
            _detailRow(
              Icons.engineering_rounded,
              'Advisor / Mechanic',
              service.mechanic,
            ),
          ],
          if (service.bookingId.isNotEmpty) ...[
            const SizedBox(height: 12),
            _detailRow(
              Icons.confirmation_number_rounded,
              'Booking ID',
              service.bookingId,
            ),
          ],
          if (service.isPending) ...[
            const SizedBox(height: 18),
            _buildTimeline(service),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showCancelDialog(service);
                },
                icon: const Icon(
                  Icons.close_rounded,
                  size: 18,
                ),
                label: const Text(
                  'Cancel Booking',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style:
                    OutlinedButton.styleFrom(
                  foregroundColor: red,
                  side: BorderSide(
                    color: red.withValues(
                      alpha: 0.45,
                    ),
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(13),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // TIMELINE
  // ============================================================

  Widget _buildTimeline(
    ServiceStatusItem service,
  ) {
    final stages = [
      'Booking Confirmed',
      'Vehicle Received',
      'Service In Progress',
      'Quality Check',
      'Ready for Delivery',
      'Completed',
    ];

    int activeIndex =
        service.timelineIndex;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Service Progress',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        ...List.generate(
          stages.length,
          (index) {
            final completed =
                index < activeIndex;

            final current =
                index == activeIndex;

            final color = completed || current
                ? cyan
                : Colors.white24;

            return Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 28,
                  child: Column(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: color.withValues(
                            alpha:
                                completed ||
                                        current
                                    ? 0.13
                                    : 0.04,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: color,
                          ),
                        ),
                        child: Icon(
                          completed
                              ? Icons.check_rounded
                              : current
                                  ? Icons
                                      .radio_button_checked_rounded
                                  : Icons
                                      .radio_button_unchecked_rounded,
                          color: color,
                          size: 14,
                        ),
                      ),
                      if (index <
                          stages.length - 1)
                        Container(
                          width: 1,
                          height: 27,
                          color:
                              completed
                                  ? cyan
                                      .withValues(
                                      alpha:
                                          0.45,
                                    )
                                  : Colors
                                      .white12,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(
                      top: 3,
                      bottom: 10,
                    ),
                    child: Text(
                      stages[index],
                      style: TextStyle(
                        color: completed ||
                                current
                            ? Colors.white
                            : Colors.white38,
                        fontSize: 12,
                        fontWeight: current
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // STATUS
  // ============================================================

  Widget _statusBadge(
    String status,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.10,
        ),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(
            alpha: 0.55,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DETAIL ROW
  // ============================================================

  Widget _detailRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: cyan,
          size: 19,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0x80FFFFFF),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value.isEmpty
                    ? 'Not available'
                    : value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _buildLoading() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 38,
              height: 38,
              child:
                  CircularProgressIndicator(
                strokeWidth: 3,
                color: cyan,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Loading service status',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Please wait while we retrieve your service information.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0x80FFFFFF),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CONNECTION ERROR
  // ============================================================

  Widget _buildConnectionError() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: red.withValues(
                  alpha: 0.10,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: red,
                size: 35,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Unable to connect',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage.isEmpty
                  ? 'We could not retrieve your service status.'
                  : _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0x99FFFFFF),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: 170,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _loadServices,
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 19,
                ),
                label: const Text(
                  'Try Again',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor: blue,
                  foregroundColor: Colors.white,
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
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmptyState() {
    final pending =
        _selectedTab == 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 42,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.035,
        ),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.06,
          ),
        ),
      ),
      child: Column(
        children: [
          Icon(
            pending
                ? Icons.event_available_rounded
                : Icons.history_rounded,
            color: cyan,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            pending
                ? 'No pending services'
                : 'No completed services',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            pending
                ? 'You currently have no active service bookings.'
                : 'Your completed services will appear here.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0x80FFFFFF),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOOK BUTTON
  // ============================================================

  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.add_circle_outline_rounded,
          size: 20,
        ),
        label: const Text(
          'Book New Service',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CANCEL
  // ============================================================

  void _showCancelDialog(
    ServiceStatusItem service,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: card,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),
          title: const Text(
            'Cancel Booking?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to cancel ${service.serviceType}?',
            style: const TextStyle(
              color: Color(0xB3FFFFFF),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Keep Booking',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white60,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                setState(() {
                  _services.removeWhere(
                    (item) =>
                        item.id == service.id,
                  );
                });

                _showMessage(
                  'Booking cancelled.',
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor: red,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // ICON BUTTON
  // ============================================================

  Widget _iconButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(14),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.06,
            ),
            borderRadius:
                BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.08,
              ),
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 19,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ANIMATION
  // ============================================================

  Widget _animated(
    int index,
    Widget child,
  ) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay =
            (index * 0.06).clamp(0.0, 0.45);

        final value = (
          (_animationController.value -
                  delay) /
              (1 - delay)
        ).clamp(0.0, 1.0);

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              15 * (1 - value),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior:
              SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
        ),
      );
  }
}

// ================================================================
// MODEL
// ================================================================

class ServiceStatusItem {
  final String id;
  final String serviceType;
  final String vehicleName;
  final String status;
  final String date;
  final String time;
  final String serviceCenter;
  final String mechanic;
  final String bookingId;
  final int timelineIndex;

  const ServiceStatusItem({
    required this.id,
    required this.serviceType,
    required this.vehicleName,
    required this.status,
    required this.date,
    required this.time,
    required this.serviceCenter,
    required this.mechanic,
    required this.bookingId,
    required this.timelineIndex,
  });

  bool get isPending {
    final value = status.toLowerCase();

    return value.contains('pending') ||
        value.contains('progress') ||
        value.contains('confirmed') ||
        value.contains('received') ||
        value.contains('scheduled');
  }

  factory ServiceStatusItem.fromJson(
    Map<String, dynamic> json,
  ) {
    String read(
      List<String> keys, {
      String fallback = '',
    }) {
      for (final key in keys) {
        final value = json[key];

        if (value != null &&
            value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }

      return fallback;
    }

    int readInt(
      List<String> keys, {
      int fallback = 0,
    }) {
      for (final key in keys) {
        final value = json[key];

        if (value is int) {
          return value;
        }

        final parsed =
            int.tryParse(value?.toString() ?? '');

        if (parsed != null) {
          return parsed;
        }
      }

      return fallback;
    }

    return ServiceStatusItem(
      id: read(
        ['id', 'service_id', 'booking_id'],
        fallback:
            DateTime.now()
                .microsecondsSinceEpoch
                .toString(),
      ),
      serviceType: read(
        [
          'service_type',
          'serviceType',
          'type',
          'service_name',
        ],
        fallback: 'General Service',
      ),
      vehicleName: read(
        [
          'vehicle_name',
          'vehicleName',
          'vehicle',
          'car_name',
        ],
        fallback: 'Hyundai Vehicle',
      ),
      status: read(
        ['status', 'service_status'],
        fallback: 'Pending',
      ),
      date: read(
        [
          'date',
          'service_date',
          'booking_date',
        ],
        fallback: 'Not scheduled',
      ),
      time: read(
        [
          'time',
          'service_time',
          'preferred_time',
        ],
        fallback: 'Not specified',
      ),
      serviceCenter: read(
        [
          'service_center',
          'serviceCenter',
          'center',
          'location',
        ],
        fallback: 'Hyundai Service Centre',
      ),
      mechanic: read(
        [
          'mechanic',
          'advisor',
          'mechanic_name',
        ],
      ),
      bookingId: read(
        [
          'booking_id',
          'bookingId',
          'reference',
        ],
      ),
      timelineIndex: readInt(
        [
          'timeline_index',
          'timelineIndex',
          'progress',
        ],
        fallback: 0,
      ),
    );
  }
}