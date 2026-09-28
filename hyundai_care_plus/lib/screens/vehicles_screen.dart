import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/care_background.dart';
import 'add_vehicle_screen.dart';

class VehiclesScreen extends StatefulWidget {
  final int customerId;

  const VehiclesScreen({
    super.key,
    required this.customerId,
  });

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen>
    with SingleTickerProviderStateMixin {
  static const String vehiclesUrl =
      'http://192.168.1.7/hyundai_care_plus_api/vehicles.php';

  bool isLoading = true;
  bool isRefreshing = false;

  String? errorMessage;

  List<Map<String, dynamic>> vehicles = [];

  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    animationController.forward();

    loadVehicles();
  }

  Future<void> loadVehicles({
    bool refresh = false,
  }) async {
    if (widget.customerId <= 0) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        isRefreshing = false;
        errorMessage = 'Invalid customer information.';
      });

      return;
    }

    if (refresh) {
      setState(() {
        isRefreshing = true;
        errorMessage = null;
      });
    } else {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      final uri = Uri.parse(
        vehiclesUrl,
      ).replace(
        queryParameters: {
          'customer_id': widget.customerId.toString(),
        },
      );

      debugPrint(
        'LOADING VEHICLES FOR CUSTOMER: ${widget.customerId}',
      );

      debugPrint(
        'VEHICLES URL: $uri',
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
        'VEHICLES STATUS: ${response.statusCode}',
      );

      debugPrint(
        'VEHICLES RESPONSE: ${response.body}',
      );

      if (!mounted) return;

      if (response.statusCode != 200) {
        setState(() {
          errorMessage =
              'Vehicle service returned ${response.statusCode}.';
        });

        return;
      }

      final body = response.body.trim();

      if (body.isEmpty) {
        setState(() {
          errorMessage =
              'Vehicle service returned an empty response.';
        });

        return;
      }

      dynamic decoded;

      try {
        decoded = jsonDecode(body);
      } catch (e) {
        debugPrint(
          'VEHICLES JSON ERROR: $e',
        );

        setState(() {
          errorMessage =
              'Vehicle service returned invalid data.';
        });

        return;
      }

      if (decoded is! Map) {
        setState(() {
          errorMessage =
              'Unexpected vehicle service response.';
        });

        return;
      }

      final data = Map<String, dynamic>.from(
        decoded,
      );

      if (data['success'] != true) {
        setState(() {
          errorMessage =
              data['message']?.toString() ??
                  'Unable to load your vehicles.';
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
          'CUSTOMER ID MISMATCH: '
          'requested=${widget.customerId}, '
          'received=$serverCustomerId',
        );

        setState(() {
          vehicles = [];
          errorMessage =
              'Vehicle account verification failed.';
        });

        return;
      }

      final rawVehicles = data['vehicles'];

      final loadedVehicles =
          <Map<String, dynamic>>[];

      if (rawVehicles is List) {
        for (final item in rawVehicles) {
          if (item is Map) {
            final vehicle =
                Map<String, dynamic>.from(
              item,
            );

            final vehicleCustomerId =
                int.tryParse(
              vehicle['customer_id']
                      ?.toString() ??
                  '',
            );

            if (vehicleCustomerId != null &&
                vehicleCustomerId !=
                    widget.customerId) {
              debugPrint(
                'Ignoring vehicle belonging to another customer: '
                '${vehicle['vehicle_id']}',
              );

              continue;
            }

            final vehicleId =
                int.tryParse(
              vehicle['vehicle_id']
                      ?.toString() ??
                  '',
            );

            final model =
                vehicle['model']
                    ?.toString()
                    .trim();

            final registration =
                vehicle[
                        'registration_number']
                    ?.toString()
                    .trim();

            if (vehicleId == null ||
                model == null ||
                model.isEmpty ||
                registration == null ||
                registration.isEmpty) {
              debugPrint(
                'Ignoring incomplete vehicle record: $vehicle',
              );

              continue;
            }

            loadedVehicles.add(
              vehicle,
            );
          }
        }
      }

      setState(() {
        vehicles = loadedVehicles;
        errorMessage = null;
      });

      debugPrint(
        'VALID VEHICLES LOADED: ${vehicles.length}',
      );
    } catch (e) {
      debugPrint(
        'VEHICLES ERROR: $e',
      );

      if (!mounted) return;

      setState(() {
        errorMessage =
            'Unable to connect to the vehicle service.';
      });
    } finally {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        isRefreshing = false;
      });
    }
  }

  Future<void> refreshVehicles() async {
    await loadVehicles(
      refresh: true,
    );
  }

  Future<void> openAddVehicle() async {
    if (widget.customerId <= 0) {
      showMessage(
        'Customer information is unavailable.',
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddVehicleScreen(
          customerId: widget.customerId,
        ),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      await refreshVehicles();
    }
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

  String valueOf(
    Map<String, dynamic> vehicle,
    String key,
  ) {
    final value = vehicle[key];

    if (value == null) {
      return '';
    }

    final text = value.toString().trim();

    if (text.isEmpty || text == 'null') {
      return '';
    }

    return text;
  }

  String getModel(
    Map<String, dynamic> vehicle,
  ) {
    final model = valueOf(
      vehicle,
      'model',
    );

    return model.isEmpty ? 'Hyundai Vehicle' : model;
  }

  String getRegistration(
    Map<String, dynamic> vehicle,
  ) {
    return valueOf(
      vehicle,
      'registration_number',
    ).toUpperCase();
  }

  String getYear(
    Map<String, dynamic> vehicle,
  ) {
    return valueOf(
      vehicle,
      'year',
    );
  }

  String getColor(
    Map<String, dynamic> vehicle,
  ) {
    return valueOf(
      vehicle,
      'color',
    );
  }

  String getLastService(
    Map<String, dynamic> vehicle,
  ) {
    final value = valueOf(
      vehicle,
      'last_service',
    );

    return value.isEmpty
        ? 'No service recorded'
        : value;
  }

  String getStatus(
    Map<String, dynamic> vehicle,
  ) {
    final value = valueOf(
      vehicle,
      'status',
    );

    return value.isEmpty
        ? 'Active'
        : value;
  }

  IconData vehicleIcon(
    Map<String, dynamic> vehicle,
  ) {
    final model =
        getModel(vehicle).toLowerCase();

    if (model.contains('suv') ||
        model.contains('creta') ||
        model.contains('alcazar') ||
        model.contains('tucson') ||
        model.contains('venue') ||
        model.contains('exter')) {
      return Icons.directions_car_filled_rounded;
    }

    if (model.contains('van')) {
      return Icons.airport_shuttle_rounded;
    }

    return Icons.directions_car_filled_rounded;
  }

  void showVehicleSelected(
    Map<String, dynamic> vehicle,
  ) {
    final registration =
        getRegistration(vehicle);

    showMessage(
      '$registration selected.',
    );
  }

  void showVehicleDetails(
    Map<String, dynamic> vehicle,
  ) {
    final model = getModel(vehicle);
    final registration =
        getRegistration(vehicle);
    final year = getYear(vehicle);
    final color = getColor(vehicle);
    final status = getStatus(vehicle);
    final lastService =
        getLastService(vehicle);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor:
          const Color(0xFF07152A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              24,
              24,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFF70E8FF)
                                .withValues(
                          alpha: 0.10,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          17,
                        ),
                      ),
                      child: Icon(
                        vehicleIcon(vehicle),
                        color:
                            const Color(0xFF70E8FF),
                        size: 32,
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
                            style:
                                const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            registration,
                            style:
                                const TextStyle(
                              color:
                                  Color(0xFF70E8FF),
                              fontSize: 11,
                              fontWeight:
                                  FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _detailRow(
                  'Year',
                  year.isEmpty ? 'Not available' : year,
                ),
                _detailRow(
                  'Color',
                  color.isEmpty
                      ? 'Not available'
                      : color,
                ),
                _detailRow(
                  'Status',
                  status,
                ),
                _detailRow(
                  'Last Service',
                  lastService,
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      showVehicleSelected(
                        vehicle,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF1687FF),
                      foregroundColor:
                          Colors.white,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                    child:
                        const Text(
                      'SELECT VEHICLE',
                      style:
                          TextStyle(
                        fontWeight:
                            FontWeight.bold,
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
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 13,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF020817),
      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,
        foregroundColor:
            Colors.white,
        title: const Text(
          'My Hyundai',
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed:
                isRefreshing
                    ? null
                    : refreshVehicles,
            icon: isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                      color:
                          Colors.white70,
                    ),
                  )
                : const Icon(
                    Icons.refresh_rounded,
                  ),
          ),
        ],
      ),
      floatingActionButton:
          !isLoading &&
                  errorMessage == null
              ? FloatingActionButton.extended(
                  onPressed:
                      openAddVehicle,
                  backgroundColor:
                      const Color(0xFF684CFF),
                  foregroundColor:
                      Colors.white,
                  icon: const Icon(
                    Icons.add_rounded,
                  ),
                  label: const Text(
                    'Add Vehicle',
                  ),
                )
              : null,
      body: CareBackground(
        child: RefreshIndicator(
          color:
              const Color(0xFF70E8FF),
          onRefresh:
              refreshVehicles,
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return _buildLoading();
    }

    if (errorMessage != null) {
      return _buildError();
    }

    if (vehicles.isEmpty) {
      return _emptyVehicle();
    }

    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),
      padding:
          const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        100,
      ),
      children: [
        _header(),
        const SizedBox(height: 18),
        ...List.generate(
          vehicles.length,
          (index) {
            return Padding(
              padding:
                  const EdgeInsets.only(
                bottom: 14,
              ),
              child: _vehicleCard(
                vehicles[index],
                index,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'My Vehicles',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight:
                FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '${vehicles.length} vehicle${vehicles.length == 1 ? '' : 's'} connected to your account',
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _vehicleCard(
    Map<String, dynamic> vehicle,
    int index,
  ) {
    final model =
        getModel(vehicle);
    final registration =
        getRegistration(vehicle);
    final year =
        getYear(vehicle);
    final color =
        getColor(vehicle);
    final status =
        getStatus(vehicle);

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animationController,
        curve: Interval(
          (index * 0.08)
              .clamp(0.0, 0.7),
          1.0,
          curve: Curves.easeOut,
        ),
      ),
      child: Container(
        padding:
            const EdgeInsets.all(17),
        decoration: BoxDecoration(
          gradient:
              const LinearGradient(
            begin: Alignment.topLeft,
            end:
                Alignment.bottomRight,
            colors: [
              Color(0xFF102A4C),
              Color(0xFF15183E),
              Color(0xFF073A43),
            ],
          ),
          borderRadius:
              BorderRadius.circular(23),
          border: Border.all(
            color:
                Colors.white.withValues(
              alpha: 0.10,
            ),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white.withValues(
                      alpha: 0.07,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      19,
                    ),
                  ),
                  child: Icon(
                    vehicleIcon(vehicle),
                    color:
                        const Color(0xFF70E8FF),
                    size: 38,
                  ),
                ),
                const SizedBox(width: 15),
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
                        style:
                            const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 7),
                      _plate(registration),
                    ],
                  ),
                ),
                const Icon(
                  Icons.verified_rounded,
                  color:
                      Color(0xFF6EFFE1),
                  size: 25,
                ),
              ],
            ),
            const SizedBox(height: 17),
            Row(
              children: [
                if (year.isNotEmpty)
                  Expanded(
                    child: _infoChip(
                      Icons
                          .calendar_today_outlined,
                      year,
                    ),
                  ),
                if (year.isNotEmpty &&
                    color.isNotEmpty)
                  const SizedBox(width: 7),
                if (color.isNotEmpty)
                  Expanded(
                    child: _infoChip(
                      Icons.palette_outlined,
                      color,
                    ),
                  ),
              ],
            ),
            if (year.isNotEmpty ||
                color.isNotEmpty)
              const SizedBox(height: 14),
            Container(
              padding:
                  const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color:
                    Colors.black.withValues(
                  alpha: 0.13,
                ),
                borderRadius:
                    BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    color:
                        Color(0xFF70E8FF),
                    size: 20,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CARE+ PROTECTED',
                          style:
                              TextStyle(
                            color:
                                Color(0xFF70E8FF),
                            fontSize: 9,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Status: $status',
                          style:
                              const TextStyle(
                            color:
                                Colors.white54,
                            fontSize: 8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          getLastService(
                            vehicle,
                          ),
                          style:
                              const TextStyle(
                            color:
                                Colors.white54,
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _vehicleAction(
                    Icons.check_circle_outline,
                    'Select',
                    () {
                      showVehicleSelected(
                        vehicle,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: _vehicleAction(
                    Icons.info_outline_rounded,
                    'Details',
                    () {
                      showVehicleDetails(
                        vehicle,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: _vehicleAction(
                    Icons.build_outlined,
                    'Service',
                    () {
                      showMessage(
                        '$registration selected for service.',
                      );
                    },
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: _vehicleAction(
                    Icons.more_horiz_rounded,
                    'More',
                    () {
                      showVehicleDetails(
                        vehicle,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(
    IconData icon,
    String value,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(
          alpha: 0.045,
        ),
        borderRadius:
            BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color:
                const Color(0xFF70E8FF),
            size: 13,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style:
                  const TextStyle(
                color: Colors.white70,
                fontSize: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vehicleAction(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(11),
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color:
              Colors.white.withValues(
            alpha: 0.04,
          ),
          borderRadius:
              BorderRadius.circular(11),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white70,
              size: 16,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style:
                  const TextStyle(
                color: Colors.white54,
                fontSize: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _plate(
    String registration,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color:
            const Color(0xFFF1F3F4),
        borderRadius:
            BorderRadius.circular(5),
      ),
      child: Text(
        registration.isEmpty
            ? 'NO REGISTRATION'
            : registration,
        style:
            const TextStyle(
          color: Colors.black87,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildError() {
    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),
      padding:
          const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 120),
        const Icon(
          Icons.cloud_off_rounded,
          color: Color(0xFFFF7087),
          size: 58,
        ),
        const SizedBox(height: 15),
        const Text(
          'Unable to load your vehicles',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight:
                FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          errorMessage ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton.icon(
            onPressed:
                refreshVehicles,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
            label:
                const Text('TRY AGAIN'),
          ),
        ),
      ],
    );
  }

  Widget _emptyVehicle() {
    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),
      padding:
          const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 110),
        Container(
          padding:
              const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color:
                Colors.white.withValues(
              alpha: 0.055,
            ),
            borderRadius:
                BorderRadius.circular(22),
            border: Border.all(
              color:
                  Colors.white.withValues(
                alpha: 0.10,
              ),
            ),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.directions_car_outlined,
                color:
                    Color(0xFF70E8FF),
                size: 50,
              ),
              const SizedBox(height: 12),
              const Text(
                'No Hyundai connected yet',
                style:
                    TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'No vehicles were found for your customer account.',
                textAlign:
                    TextAlign.center,
                style:
                    TextStyle(
                  color: Colors.white54,
                  fontSize: 9,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed:
                    openAddVehicle,
                icon: const Icon(
                  Icons.add_rounded,
                ),
                label:
                    const Text(
                  'ADD VEHICLE',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),
      padding:
          const EdgeInsets.all(20),
      children: [
        _skeleton(32, 12),
        const SizedBox(height: 18),
        _skeleton(190, 23),
        const SizedBox(height: 15),
        _skeleton(190, 23),
      ],
    );
  }

  Widget _skeleton(
    double height,
    double radius,
  ) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(
          alpha: 0.055,
        ),
        borderRadius:
            BorderRadius.circular(radius),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}