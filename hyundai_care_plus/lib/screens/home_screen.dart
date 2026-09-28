import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/care_background.dart';

import 'about_legal_screen.dart';
import 'emergency_assistance_screen.dart';
import 'help_support_screen.dart';
import 'insurance_documents_screen.dart';
import 'maintenance_reminders_screen.dart';
import 'maintenance_schedule_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';
import 'rewards_screen.dart';
import 'service_booking_screen.dart';
import 'service_centres_screen.dart';
import 'service_history_screen.dart';
import 'service_status_screen.dart';
import 'settings_screen.dart';
import 'vehicle_health_screen.dart';
import 'vehicle_management_screen.dart';
import 'vehicle_tracking_screen.dart';
import 'vehicles_screen.dart';
import 'warranty_screen.dart';

class HomeScreen extends StatefulWidget {
  final int customerId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String customerMembership;
  final String customerStatus;

  const HomeScreen({
    super.key,
    required this.customerId,
    this.customerName = '',
    this.customerPhone = '',
    this.customerEmail = '',
    this.customerMembership = 'Regular',
    this.customerStatus = 'Active',
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const Color navy = Color(0xFF071326);
  static const Color navy2 = Color(0xFF0D1D38);
  static const Color blue = Color(0xFF287BFF);
  static const Color cyan = Color(0xFF70E8FF);
  static const Color purple = Color(0xFF8B6CFF);
  static const Color green = Color(0xFF62E6A7);
  static const Color yellow = Color(0xFFFFC857);
  static const Color red = Color(0xFFFF647C);

  static const String vehiclesApi =
      'http://192.168.1.7/hyundai_care_plus_api/vehicles.php';

  List<Map<String, dynamic>> _homeVehicles = [];
  bool _homeVehiclesLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHomeVehicles();
  }

  Future<void> _loadHomeVehicles() async {
    if (widget.customerId <= 0) {
      if (!mounted) return;
      setState(() {
        _homeVehicles = [];
        _homeVehiclesLoading = false;
      });
      return;
    }

    try {
      final uri = Uri.parse(vehiclesApi).replace(
        queryParameters: {
          'customer_id': widget.customerId.toString(),
        },
      );

      debugPrint(
        'HOME VEHICLES CUSTOMER ID: ${widget.customerId}',
      );
      debugPrint(
        'HOME VEHICLES URL: $uri',
      );

      final response = await http
          .get(
            uri,
            headers: const {
              'Accept': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 15),
          );

      debugPrint(
        'HOME VEHICLES STATUS: ${response.statusCode}',
      );
      debugPrint(
        'HOME VEHICLES RESPONSE: ${response.body}',
      );

      if (!mounted) return;

      if (response.statusCode != 200) {
        setState(() {
          _homeVehicles = [];
          _homeVehiclesLoading = false;
        });
        return;
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map) {
        setState(() {
          _homeVehicles = [];
          _homeVehiclesLoading = false;
        });
        return;
      }

      final data = Map<String, dynamic>.from(decoded);

      if (data['success'] != true) {
        setState(() {
          _homeVehicles = [];
          _homeVehiclesLoading = false;
        });
        return;
      }

      final serverCustomerId =
          int.tryParse(
            data['customer_id']?.toString() ?? '',
          );

      if (serverCustomerId != null &&
          serverCustomerId != widget.customerId) {
        debugPrint(
          'HOME VEHICLE CUSTOMER MISMATCH: '
          'requested=${widget.customerId}, '
          'received=$serverCustomerId',
        );

        setState(() {
          _homeVehicles = [];
          _homeVehiclesLoading = false;
        });
        return;
      }

      final rawVehicles = data['vehicles'];
      final loaded = <Map<String, dynamic>>[];

      if (rawVehicles is List) {
        for (final item in rawVehicles) {
          if (item is! Map) continue;

          final vehicle =
              Map<String, dynamic>.from(item);

          final vehicleCustomerId =
              int.tryParse(
            vehicle['customer_id']?.toString() ?? '',
          );

          if (vehicleCustomerId != null &&
              vehicleCustomerId != widget.customerId) {
            continue;
          }

          final vehicleId =
              int.tryParse(
            vehicle['vehicle_id']?.toString() ?? '',
          );

          final model =
              vehicle['model']?.toString().trim() ?? '';

          final registration =
              vehicle['registration_number']
                      ?.toString()
                      .trim() ??
                  '';

          if (vehicleId == null ||
              model.isEmpty ||
              registration.isEmpty) {
            continue;
          }

          loaded.add(vehicle);
        }
      }

      setState(() {
        _homeVehicles = loaded;
        _homeVehiclesLoading = false;
      });
    } catch (e) {
      debugPrint(
        'HOME VEHICLES ERROR: $e',
      );

      if (!mounted) return;

      setState(() {
        _homeVehicles = [];
        _homeVehiclesLoading = false;
      });
    }
  }

  String _homeVehicleValue(
    Map<String, dynamic> vehicle,
    String key,
  ) {
    final value = vehicle[key]?.toString().trim() ?? '';
    return value == 'null' ? '' : value;
  }

  String get displayName {
    final value = widget.customerName.trim();
    return value.isEmpty ? 'Customer' : value;
  }

  String get membership {
    final value = widget.customerMembership.trim();
    return value.isEmpty ? 'Regular' : value;
  }

  String get accountStatus {
    final value = widget.customerStatus.trim();
    return value.isEmpty ? 'Active' : value;
  }

  String get initials {
    final value = displayName.trim();

    if (value.isEmpty) {
      return 'C';
    }

    final parts = value.split(RegExp(r'\s+'));

    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }

    return parts.first[0].toUpperCase();
  }

  void _open(Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => screen,
      ),
    );
  }

  void openVehicles() {
    _open(
      VehiclesScreen(
        customerId: widget.customerId,
      ),
    );
  }

  void openServiceStatus() {
    _open(
      ServiceStatusScreen(
        customerId: widget.customerId,
      ),
    );
  }

  void openServiceHistory() {
    _open(
      ServiceHistoryScreen(
        customerId: widget.customerId,
      ),
    );
  }

  void openServiceBooking() {
    _open(
      ServiceBookingScreen(
        customerId: widget.customerId,
      ),
    );
  }

  void openServiceCentres() {
    _open(
      const ServiceCentresScreen(),
    );
  }

  void openWarranty() {
    _open(
      const WarrantyScreen(),
    );
  }

  void openNotifications() {
    _open(
      const NotificationScreen(),
    );
  }

  void openEmergency() {
    _open(
      EmergencyAssistanceScreen(
        customerId: widget.customerId,
      ),
    );
  }

  void openProfile() {
    _open(
      ProfileScreen(
        customerId: widget.customerId,
        customerName: widget.customerName,
        customerPhone: widget.customerPhone,
        customerEmail: widget.customerEmail,
      ),
    );
  }

  void openRewards() {
    _open(
      RewardsScreen(
        customerId: widget.customerId,
      ),
    );
  }

  void openMoreMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return _MoreMenu(
          onProfile: openProfile,
          onRewards: openRewards,
          onOpen: _open,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          const Positioned.fill(
            child: CareBackground(
              child: SizedBox.expand(),
            ),
          ),
          SafeArea(
            child: _buildHomeBody(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHomeBody() {
    return RefreshIndicator(
      color: cyan,
      backgroundColor: navy2,
      onRefresh: () async {
        await Future.delayed(
          const Duration(milliseconds: 350),
        );

        if (mounted) {
          setState(() {});
        }
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              18,
              6,
              18,
              30,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildWelcome(),
                  const SizedBox(height: 18),
                  _buildAccountCard(),
                  const SizedBox(height: 18),
                  _buildVehicleCard(),
                  const SizedBox(height: 22),
                  _buildSectionTitle(
                    'Quick Access',
                    'Everything you need in one place',
                  ),
                  const SizedBox(height: 13),
                  _buildQuickAccessGrid(),
                  const SizedBox(height: 22),
                  _buildRewardsCard(),
                  const SizedBox(height: 18),
                  _buildServiceBanner(),
                  const SizedBox(height: 22),
                  _buildCareFeatures(),
                  const SizedBox(height: 18),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        14,
        10,
        14,
        8,
      ),
      child: Row(
        children: [
          Builder(
            builder: (context) {
              return _roundButton(
                icon: Icons.menu_rounded,
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hyundai Care+',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Your Hyundai. Our Care. Always.',
                  style: TextStyle(
                    color: Color(0x99FFFFFF),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          _roundButton(
            icon: Icons.notifications_none_rounded,
            showDot: true,
            onTap: openNotifications,
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: openProfile,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    cyan,
                    purple,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: cyan.withValues(alpha: 0.20),
                    blurRadius: 14,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, $displayName 👋',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 29,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'Drive safe. We are with you every mile.',
          style: TextStyle(
            color: Color(0xB3FFFFFF),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF123866),
            Color(0xFF282052),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: cyan.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.10),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.14),
              ),
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  membership,
                  style: const TextStyle(
                    color: cyan,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Account: $accountStatus',
                  style: const TextStyle(
                    color: Color(0xCCFFFFFF),
                    fontSize: 13,
                  ),
                ),
                if (widget.customerPhone.trim().isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    widget.customerPhone,
                    style: const TextStyle(
                      color: Color(0x80FFFFFF),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: openProfile,
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white70,
              size: 17,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard() {
    final hasVehicle = _homeVehicles.isNotEmpty;

    String model = '';
    String registration = '';
    String year = '';
    String color = '';
    String status = '';

    if (hasVehicle) {
      final vehicle = _homeVehicles.first;

      model = _homeVehicleValue(
        vehicle,
        'model',
      );

      registration = _homeVehicleValue(
        vehicle,
        'registration_number',
      ).toUpperCase();

      year = _homeVehicleValue(
        vehicle,
        'year',
      );

      color = _homeVehicleValue(
        vehicle,
        'color',
      );

      status = _homeVehicleValue(
        vehicle,
        'status',
      );

      if (status.isEmpty) {
        status = 'Active';
      }
    }

    return InkWell(
      onTap: openVehicles,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.055),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'My Vehicles',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  _homeVehiclesLoading
                      ? 'Loading...'
                      : 'View All',
                  style: const TextStyle(
                    color: cyan,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: cyan,
                  size: 13,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0E2748),
                    Color(0xFF111C38),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: _homeVehiclesLoading
                  ? const SizedBox(
                      height: 66,
                      child: Center(
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: cyan,
                          ),
                        ),
                      ),
                    )
                  : hasVehicle
                      ? Row(
                          children: [
                            Container(
                              width: 66,
                              height: 66,
                              decoration: BoxDecoration(
                                color:
                                    blue.withValues(alpha: 0.13),
                                borderRadius:
                                    BorderRadius.circular(17),
                              ),
                              child: const Icon(
                                Icons.directions_car_rounded,
                                color: cyan,
                                size: 36,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    model,
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    registration,
                                    style: const TextStyle(
                                      color:
                                          Color(0xFF70E8FF),
                                      fontSize: 13,
                                      fontWeight:
                                          FontWeight.w600,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: green,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 5),
                                      Flexible(
                                        child: Text(
                                          [
                                            status,
                                            if (year.isNotEmpty)
                                              year,
                                            if (color.isNotEmpty)
                                              color,
                                          ].join(' • '),
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: green,
                                            fontSize: 11,
                                            fontWeight:
                                                FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white54,
                              size: 17,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Container(
                              width: 66,
                              height: 66,
                              decoration: BoxDecoration(
                                color:
                                    blue.withValues(alpha: 0.13),
                                borderRadius:
                                    BorderRadius.circular(17),
                              ),
                              child: const Icon(
                                Icons.directions_car_outlined,
                                color: cyan,
                                size: 36,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'No vehicle found',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Add a Hyundai vehicle to your account',
                                    style: TextStyle(
                                      color:
                                          Color(0x99FFFFFF),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white54,
                              size: 17,
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0x80FFFFFF),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccessGrid() {
    final items = [
      _QuickItem(
        'Book Service',
        Icons.calendar_month_rounded,
        blue,
        openServiceBooking,
      ),
      _QuickItem(
        'Service Status',
        Icons.pending_actions_rounded,
        yellow,
        openServiceStatus,
      ),
      _QuickItem(
        'Service History',
        Icons.history_rounded,
        cyan,
        openServiceHistory,
      ),
      _QuickItem(
        'Warranty',
        Icons.verified_user_rounded,
        green,
        openWarranty,
      ),
      _QuickItem(
        'Emergency',
        Icons.emergency_rounded,
        red,
        openEmergency,
      ),
      _QuickItem(
        'Notifications',
        Icons.notifications_active_rounded,
        purple,
        openNotifications,
      ),
      _QuickItem(
        'Rewards',
        Icons.card_giftcard_rounded,
        yellow,
        openRewards,
      ),
      _QuickItem(
        'Profile',
        Icons.person_rounded,
        cyan,
        openProfile,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.48,
      ),
      itemBuilder: (context, index) {
        return _QuickAccessCard(
          item: items[index],
        );
      },
    );
  }

  Widget _buildRewardsCard() {
    return InkWell(
      onTap: openRewards,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF33265F),
              Color(0xFF172A4C),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: purple.withValues(alpha: 0.30),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: yellow.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                color: yellow,
                size: 29,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Care+ Rewards',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Earn points and unlock exclusive benefits.',
                    style: TextStyle(
                      color: Color(0xAFFFFFFF),
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: yellow,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceBanner() {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF123E70),
            Color(0xFF14254A),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: cyan.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: cyan.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: cyan,
              size: 29,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '24/7 Care',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Need help? Hyundai Care+ is here for you.',
                  style: TextStyle(
                    color: Color(0x99FFFFFF),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _open(
                const HelpSupportScreen(),
              );
            },
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: cyan,
              size: 17,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareFeatures() {
    final features = [
      _FeatureItem(
        Icons.location_on_rounded,
        'Service Centres',
        'Find nearby centres',
        openServiceCentres,
      ),
      _FeatureItem(
        Icons.build_circle_rounded,
        'Maintenance',
        'Stay on schedule',
        () {
          _open(
            const MaintenanceScheduleScreen(),
          );
        },
      ),
      _FeatureItem(
        Icons.notifications_active_rounded,
        'Reminders',
        'Never miss a service',
        () {
          _open(
            const MaintenanceRemindersScreen(),
          );
        },
      ),
      _FeatureItem(
        Icons.description_rounded,
        'Documents',
        'Keep them organised',
        () {
          _open(
            const InsuranceDocumentsScreen(),
          );
        },
      ),
      _FeatureItem(
        Icons.car_repair_rounded,
        'Vehicle Health',
        'Check your vehicle',
        () {
          _open(
            const VehicleHealthScreen(),
          );
        },
      ),
      _FeatureItem(
        Icons.route_rounded,
        'Live Tracking',
        'Track service progress',
        () {
          _open(
            const VehicleTrackingScreen(),
          );
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'More Care',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 13),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.035),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.07),
            ),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.55,
            ),
            itemBuilder: (context, index) {
              final item = features[index];

              return InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        Colors.white.withValues(alpha: 0.035),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color:
                              cyan.withValues(alpha: 0.08),
                          borderRadius:
                              BorderRadius.circular(11),
                        ),
                        child: const Icon(
                          Icons.circle,
                          color: cyan,
                          size: 19,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.subtitle,
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0x70FFFFFF),
                                fontSize: 9.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Text(
          'Hyundai Care+',
          style: TextStyle(
            color: cyan,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Smarter. Safer. Always With You.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0x70FFFFFF),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _footerPill('Reliable', green),
            const SizedBox(width: 7),
            _footerPill('Secure', cyan),
            const SizedBox(width: 7),
            _footerPill('Smart', purple),
            const SizedBox(width: 7),
            _footerPill('24/7 Care', yellow),
          ],
        ),
      ],
    );
  }

  Widget _footerPill(
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.20),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required VoidCallback onTap,
    bool showDot = false,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color:
                    Colors.white.withValues(alpha: 0.06),
                borderRadius:
                    BorderRadius.circular(14),
                border: Border.all(
                  color:
                      Colors.white.withValues(alpha: 0.09),
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 21,
              ),
            ),
          ),
        ),
        if (showDot)
          Positioned(
            top: 7,
            right: 7,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: navy,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF102C50),
                    Color(0xFF282052),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          cyan,
                          purple,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          membership,
                          style: const TextStyle(
                            color: cyan,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 10),
                children: [
                  _drawerItem(
                    Icons.home_rounded,
                    'Home',
                    () => Navigator.pop(context),
                  ),
                  _drawerItem(
                    Icons.directions_car_rounded,
                    'My Vehicles',
                    () {
                      Navigator.pop(context);
                      openVehicles();
                    },
                  ),
                  _drawerItem(
                    Icons.calendar_month_rounded,
                    'Service Booking',
                    () {
                      Navigator.pop(context);
                      openServiceBooking();
                    },
                  ),
                  _drawerItem(
                    Icons.pending_actions_rounded,
                    'Service Status',
                    () {
                      Navigator.pop(context);
                      openServiceStatus();
                    },
                  ),
                  _drawerItem(
                    Icons.history_rounded,
                    'Service History',
                    () {
                      Navigator.pop(context);
                      openServiceHistory();
                    },
                  ),
                  _drawerItem(
                    Icons.verified_user_rounded,
                    'Warranty',
                    () {
                      Navigator.pop(context);
                      openWarranty();
                    },
                  ),
                  _drawerItem(
                    Icons.card_giftcard_rounded,
                    'Rewards',
                    () {
                      Navigator.pop(context);
                      openRewards();
                    },
                  ),
                  _drawerItem(
                    Icons.notifications_rounded,
                    'Notifications',
                    () {
                      Navigator.pop(context);
                      openNotifications();
                    },
                  ),
                  _drawerItem(
                    Icons.emergency_rounded,
                    'Emergency Assistance',
                    () {
                      Navigator.pop(context);
                      openEmergency();
                    },
                    color: red,
                  ),
                  _drawerItem(
                    Icons.person_rounded,
                    'Profile',
                    () {
                      Navigator.pop(context);
                      openProfile();
                    },
                  ),
                  const Divider(
                    color: Colors.white12,
                    height: 24,
                  ),
                  _drawerItem(
                    Icons.settings_rounded,
                    'Settings',
                    () {
                      Navigator.pop(context);
                      _open(
                        const SettingsScreen(),
                      );
                    },
                  ),
                  _drawerItem(
                    Icons.help_outline_rounded,
                    'Help & Support',
                    () {
                      Navigator.pop(context);
                      _open(
                        const HelpSupportScreen(),
                      );
                    },
                  ),
                  _drawerItem(
                    Icons.info_outline_rounded,
                    'About & Legal',
                    () {
                      Navigator.pop(context);
                      _open(
                        const AboutLegalScreen(),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Hyundai Care+ • v1.0',
                style: TextStyle(
                  color: Color(0x55FFFFFF),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color color = Colors.white,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 2,
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Colors.white30,
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xF5071326),
        border: Border(
          top: BorderSide(
            color:
                Colors.white.withValues(alpha: 0.08),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 7,
          ),
          child: Row(
            children: [
              Expanded(
                child: _bottomItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                  index: 0,
                ),
              ),
              Expanded(
                child: _bottomItem(
                  icon: Icons.directions_car_outlined,
                  activeIcon:
                      Icons.directions_car_rounded,
                  label: 'Vehicles',
                  index: 1,
                ),
              ),
              Expanded(
                child: _bottomItem(
                  icon: Icons.build_outlined,
                  activeIcon: Icons.build_rounded,
                  label: 'Services',
                  index: 2,
                ),
              ),
              Expanded(
                child: _bottomItem(
                  icon: Icons.more_horiz_rounded,
                  activeIcon:
                      Icons.more_horiz_rounded,
                  label: 'More',
                  index: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final selected = _currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });

        if (index == 0) {
          return;
        }

        if (index == 1) {
          openVehicles();
          return;
        }

        if (index == 2) {
          openServiceBooking();
          return;
        }

        if (index == 3) {
          openMoreMenu();
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 180),
        padding:
            const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? cyan.withValues(alpha: 0.09)
              : Colors.transparent,
          borderRadius:
              BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? activeIcon : icon,
              color: selected ? cyan : Colors.white54,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color:
                    selected ? cyan : Colors.white54,
                fontSize: 11,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickItem(
    this.title,
    this.icon,
    this.color,
    this.onTap,
  );
}

class _QuickAccessCard extends StatelessWidget {
  final _QuickItem item;

  const _QuickAccessCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(19),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color:
              Colors.white.withValues(alpha: 0.045),
          borderRadius:
              BorderRadius.circular(19),
          border: Border.all(
            color:
                item.color.withValues(alpha: 0.16),
          ),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color:
                    item.color.withValues(alpha: 0.10),
                borderRadius:
                    BorderRadius.circular(15),
              ),
              child: Icon(
                item.icon,
                color: item.color,
                size: 25,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreMenu extends StatelessWidget {
  final VoidCallback onProfile;
  final VoidCallback onRewards;
  final void Function(Widget screen) onOpen;

  static const Color blue = Color(0xFF287BFF);
  static const Color cyan = Color(0xFF70E8FF);
  static const Color purple = Color(0xFF8B6CFF);
  static const Color green = Color(0xFF62E6A7);
  static const Color yellow = Color(0xFFFFC857);

  const _MoreMenu({
    required this.onProfile,
    required this.onRewards,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF071326),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            20,
          ),
          child: Column(
            children: [
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'More Care+',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Everything else you need',
                style: TextStyle(
                  color: Color(0x80FFFFFF),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              _moreItem(
                context,
                Icons.card_giftcard_rounded,
                'Rewards',
                'Points and exclusive benefits',
                yellow,
                onRewards,
              ),
              _moreItem(
                context,
                Icons.person_rounded,
                'Profile',
                'Your Care+ account',
                cyan,
                onProfile,
              ),
              _moreItem(
                context,
                Icons.location_on_rounded,
                'Service Centres',
                'Find a Hyundai service centre',
                cyan,
                () {
                  onOpen(
                    const ServiceCentresScreen(),
                  );
                },
              ),
              _moreItem(
                context,
                Icons.car_repair_rounded,
                'Vehicle Health',
                'Check your vehicle condition',
                green,
                () {
                  onOpen(
                    const VehicleHealthScreen(),
                  );
                },
              ),
              _moreItem(
                context,
                Icons.route_rounded,
                'Vehicle Tracking',
                'Track your vehicle service',
                purple,
                () {
                  onOpen(
                    const VehicleTrackingScreen(),
                  );
                },
              ),
              _moreItem(
                context,
                Icons.directions_car_rounded,
                'Vehicle Management',
                'Manage your vehicle information',
                blue,
                () {
                  onOpen(
                    const VehicleManagementScreen(),
                  );
                },
              ),
              _moreItem(
                context,
                Icons.description_rounded,
                'Insurance Documents',
                'Access your vehicle documents',
                yellow,
                () {
                  onOpen(
                    const InsuranceDocumentsScreen(),
                  );
                },
              ),
              _moreItem(
                context,
                Icons.settings_rounded,
                'Settings',
                'App preferences and controls',
                Colors.white70,
                () {
                  onOpen(
                    const SettingsScreen(),
                  );
                },
              ),
              _moreItem(
                context,
                Icons.help_outline_rounded,
                'Help & Support',
                'Get assistance',
                cyan,
                () {
                  onOpen(
                    const HelpSupportScreen(),
                  );
                },
              ),
              _moreItem(
                context,
                Icons.info_outline_rounded,
                'About & Legal',
                'About Hyundai Care+',
                Colors.white70,
                () {
                  onOpen(
                    const AboutLegalScreen(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _moreItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 9),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
        borderRadius:
            BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color:
                Colors.white.withValues(alpha: 0.045),
            borderRadius:
                BorderRadius.circular(17),
            border: Border.all(
              color:
                  Colors.white.withValues(alpha: 0.07),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color:
                      color.withValues(alpha: 0.10),
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0x70FFFFFF),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white30,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FeatureItem(
    this.icon,
    this.title,
    this.subtitle,
    this.onTap,
  );
}