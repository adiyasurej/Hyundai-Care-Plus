import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/care_background.dart';

class ServiceBookingScreen extends StatefulWidget {
  final int? customerId;

  const ServiceBookingScreen({
    super.key,
    this.customerId,
  });

  @override
  State<ServiceBookingScreen> createState() =>
      _ServiceBookingScreenState();
}

class _ServiceBookingScreenState
    extends State<ServiceBookingScreen>
    with TickerProviderStateMixin {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color navy = Color(0xFF020817);
  static const Color navy2 = Color(0xFF07152C);
  static const Color navy3 = Color(0xFF0C1D38);

  static const Color cyan = Color(0xFF70E8FF);
  static const Color blue = Color(0xFF2787FF);
  static const Color purple = Color(0xFF9B6CFF);
  static const Color green = Color(0xFF6EF5B0);

  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white40 = Color(0x66FFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white08 = Color(0x14FFFFFF);

  // ============================================================
  // API
  // ============================================================

  static const String vehicleApi =
      'http://192.168.1.7/hyundai_care_plus_api/vehicles.php';

  static const String bookingApi =
      'http://192.168.1.7/hyundai_care_plus_api/booking.php';

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController notesController =
      TextEditingController();

  // ============================================================
  // ANIMATION
  // ============================================================

  late final AnimationController _pulseController;

  // ============================================================
  // DATA
  // ============================================================

  List<Map<String, dynamic>> vehicles = [];

  final List<_ServiceOption> serviceOptions = const [
    _ServiceOption(
      title: 'General Service',
      subtitle: 'Routine maintenance',
      icon: Icons.build_circle_outlined,
      color: cyan,
    ),
    _ServiceOption(
      title: 'Brake Inspection',
      subtitle: 'Brake system check',
      icon: Icons.speed_rounded,
      color: Color(0xFFFFC857),
    ),
    _ServiceOption(
      title: 'Engine Repair',
      subtitle: 'Engine inspection & repair',
      icon: Icons.settings_suggest_rounded,
      color: Color(0xFFB28CFF),
    ),
    _ServiceOption(
      title: 'AC Service',
      subtitle: 'Cooling system service',
      icon: Icons.ac_unit_rounded,
      color: Color(0xFF6EB6FF),
    ),
    _ServiceOption(
      title: 'Wheel Alignment',
      subtitle: 'Wheel & tyre inspection',
      icon: Icons.tire_repair_rounded,
      color: Color(0xFF6EF5B0),
    ),
  ];

  final List<String> timeSlots = const [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];

  final List<_ServiceCenter> serviceCenters = const [
    _ServiceCenter(
      id: 1,
      name: 'Adyar Hyundai Service Center',
      location: 'Adyar, Chennai',
      distance: '2.4 km',
      rating: '4.8',
    ),
    _ServiceCenter(
      id: 2,
      name: 'Hyundai Care+ Chennai Central',
      location: 'Chennai Central',
      distance: '5.8 km',
      rating: '4.7',
    ),
    _ServiceCenter(
      id: 3,
      name: 'Hyundai Care+ Anna Nagar',
      location: 'Anna Nagar, Chennai',
      distance: '7.1 km',
      rating: '4.7',
    ),
    _ServiceCenter(
      id: 4,
      name: 'Hyundai Care+ Guindy',
      location: 'Guindy, Chennai',
      distance: '8.2 km',
      rating: '4.6',
    ),
  ];

  // ============================================================
  // SELECTIONS
  // ============================================================

  int currentStep = 0;

  int? selectedVehicleId;

  String? selectedService;

  DateTime? selectedDate;

  String? selectedTime;

  int? selectedCenterId;

  bool isLoadingVehicles = true;

  bool isBooking = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1500,
      ),
    )..repeat(reverse: true);

    loadVehicles();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    notesController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOAD REAL VEHICLES
  // ============================================================

  Future<void> loadVehicles() async {
    final int customerId =
        widget.customerId ?? 1;

    setStateSafe(() {
      isLoadingVehicles = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          '$vehicleApi?customer_id=$customerId',
        ),
      );

      if (!mounted) {
        return;
      }

      if (response.statusCode != 200) {
        setState(() {
          isLoadingVehicles = false;
        });

        showMessage(
          'Unable to load your vehicles.',
        );

        return;
      }

      final dynamic decoded =
          jsonDecode(response.body);

      if (decoded is! Map) {
        setState(() {
          isLoadingVehicles = false;
        });

        showMessage(
          'Unexpected vehicle data received.',
        );

        return;
      }

      if (decoded['success'] != true) {
        setState(() {
          isLoadingVehicles = false;
        });

        showMessage(
          decoded['message']?.toString() ??
              'Unable to load your vehicles.',
        );

        return;
      }

      final List<Map<String, dynamic>>
          loadedVehicles = [];

      final dynamic rawVehicles =
          decoded['vehicles'];

      if (rawVehicles is List) {
        for (final item in rawVehicles) {
          if (item is Map) {
            loadedVehicles.add(
              Map<String, dynamic>.from(item),
            );
          }
        }
      }

      int? firstVehicleId;

      for (final vehicle in loadedVehicles) {
        final id = int.tryParse(
          vehicle['vehicle_id']
                  ?.toString() ??
              vehicle['id']?.toString() ??
              '',
        );

        if (id != null) {
          firstVehicleId = id;
          break;
        }
      }

      setState(() {
        vehicles = loadedVehicles;
        selectedVehicleId =
            firstVehicleId;
        isLoadingVehicles = false;
      });
    } catch (e) {
      debugPrint(
        'SERVICE BOOKING VEHICLE ERROR: $e',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        isLoadingVehicles = false;
      });

      showMessage(
        'Unable to connect to the server.',
      );
    }
  }

  // ============================================================
  // SAFE SET STATE
  // ============================================================

  void setStateSafe(
    VoidCallback callback,
  ) {
    if (!mounted) {
      return;
    }

    setState(callback);
  }

  // ============================================================
  // VEHICLE HELPERS
  // ============================================================

  String vehicleModel(
    Map<String, dynamic> vehicle,
  ) {
    return _firstValue(
      vehicle,
      [
        'model',
        'vehicle_model',
        'name',
      ],
      'Hyundai Vehicle',
    );
  }

  String vehicleRegistration(
    Map<String, dynamic> vehicle,
  ) {
    return _firstValue(
      vehicle,
      [
        'registration_number',
        'registration',
        'vehicle_number',
        'vehicle_registration',
      ],
      'Registration unavailable',
    );
  }

  String vehicleYear(
    Map<String, dynamic> vehicle,
  ) {
    return _firstValue(
      vehicle,
      [
        'year',
        'manufacturing_year',
        'model_year',
      ],
      'Year unavailable',
    );
  }

  String vehicleColor(
    Map<String, dynamic> vehicle,
  ) {
    return _firstValue(
      vehicle,
      [
        'color',
        'colour',
      ],
      'Color unavailable',
    );
  }

  int? vehicleId(
    Map<String, dynamic> vehicle,
  ) {
    return int.tryParse(
      vehicle['vehicle_id']?.toString() ??
          vehicle['id']?.toString() ??
          '',
    );
  }

  String _firstValue(
    Map<String, dynamic> data,
    List<String> keys,
    String fallback,
  ) {
    for (final key in keys) {
      final value = data[key];

      if (value != null &&
          value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }

    return fallback;
  }

  Map<String, dynamic>? get selectedVehicle {
    for (final vehicle in vehicles) {
      if (vehicleId(vehicle) ==
          selectedVehicleId) {
        return vehicle;
      }
    }

    return null;
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void nextStep() {
    if (!_validateStep()) {
      return;
    }

    if (currentStep < 3) {
      setState(() {
        currentStep++;
      });

      return;
    }

    bookService();
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });

      return;
    }

    Navigator.of(context).pop();
  }

  bool _validateStep() {
    switch (currentStep) {
      case 0:
        if (selectedVehicleId == null) {
          showMessage(
            'Please select your vehicle.',
          );
          return false;
        }

        return true;

      case 1:
        if (selectedService == null) {
          showMessage(
            'Please select a service.',
          );
          return false;
        }

        return true;

      case 2:
        if (selectedDate == null) {
          showMessage(
            'Please select a service date.',
          );
          return false;
        }

        if (selectedTime == null) {
          showMessage(
            'Please select a time slot.',
          );
          return false;
        }

        return true;

      case 3:
        if (selectedCenterId == null) {
          showMessage(
            'Please select a service centre.',
          );
          return false;
        }

        return true;

      default:
        return false;
    }
  }

  // ============================================================
  // DATE
  // ============================================================

  Future<void> chooseDate() async {
    final now = DateTime.now();

    final firstDate = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final lastDate = firstDate.add(
      const Duration(days: 90),
    );

    final picked =
        await showDatePicker(
      context: context,
      initialDate:
          selectedDate ?? firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (
        context,
        child,
      ) {
        return Theme(
          data:
              Theme.of(context).copyWith(
            colorScheme:
                const ColorScheme.dark(
              primary: cyan,
              surface: navy2,
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (picked == null ||
        !mounted) {
      return;
    }

    setState(() {
      selectedDate = picked;
    });
  }

  // ============================================================
  // BOOK SERVICE
  // ============================================================

  Future<void> bookService() async {
    if (isBooking) {
      return;
    }

    if (!_validateStep()) {
      return;
    }

    final int customerId =
        widget.customerId ?? 1;

    final vehicle = selectedVehicle;

    if (vehicle == null) {
      showMessage(
        'Selected vehicle could not be found.',
      );
      return;
    }

    final int? vehicleIdValue =
        vehicleId(vehicle);

    if (vehicleIdValue == null) {
      showMessage(
        'Invalid vehicle information.',
      );
      return;
    }

    final center = serviceCenters
        .where(
          (item) =>
              item.id == selectedCenterId,
        )
        .firstOrNull;

    if (center == null) {
      showMessage(
        'Please select a valid service centre.',
      );
      return;
    }

    setState(() {
      isBooking = true;
    });

    final date =
        '${selectedDate!.year}-'
        '${selectedDate!.month.toString().padLeft(2, '0')}-'
        '${selectedDate!.day.toString().padLeft(2, '0')}';

    final preferredTime =
        selectedTime ?? '10:00 AM';

    try {
      final response = await http.post(
        Uri.parse(bookingApi),
        headers: const {
          'Content-Type':
              'application/json',
          'Accept':
              'application/json',
        },
        body: jsonEncode({
          'customer_id': customerId,
          'vehicle_id': vehicleIdValue,
          'service_center_id':
              selectedCenterId,
          'service_type': selectedService,
          'booking_date': date,
          'preferred_time':
              preferredTime,
          'notes':
              notesController.text.trim(),
          'mechanic_id':
              _mechanicForService(
            selectedService!,
          ),
        }),
      );

      if (!mounted) {
        return;
      }

      dynamic data;

      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = null;
      }

      if (response.statusCode == 200 &&
          data is Map &&
          data['success'] == true) {
        final appointmentId =
            data['appointment_id'] ??
                data['booking_id'] ??
                'Pending';

        showSuccessDialog(
          appointmentId.toString(),
          vehicle,
          center,
        );
      } else {
        String message =
            'Unable to book your service.';

        if (data is Map &&
            data['message'] != null) {
          message =
              data['message'].toString();
        }

        showMessage(message);
      }
    } catch (e) {
      debugPrint(
        'SERVICE BOOKING ERROR: $e',
      );

      if (!mounted) {
        return;
      }

      showMessage(
        'Unable to connect to the booking server.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isBooking = false;
        });
      }
    }
  }

  int _mechanicForService(
    String service,
  ) {
    switch (service) {
      case 'Brake Inspection':
        return 2;

      case 'Engine Repair':
        return 3;

      case 'AC Service':
        return 5;

      case 'Wheel Alignment':
        return 9;

      case 'General Service':
      default:
        return 1;
    }
  }

  // ============================================================
  // SUCCESS
  // ============================================================

  void showSuccessDialog(
    String appointmentId,
    Map<String, dynamic> vehicle,
    _ServiceCenter center,
  ) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (
        dialogContext,
      ) {
        return Dialog(
          backgroundColor: navy2,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(25),
          ),
          child: Padding(
            padding:
                const EdgeInsets.all(23),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration:
                      BoxDecoration(
                    shape:
                        BoxShape.circle,
                    color:
                        green.withValues(
                      alpha: 0.10,
                    ),
                    border:
                        Border.all(
                      color:
                          green.withValues(
                        alpha: 0.20,
                      ),
                    ),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: green,
                    size: 36,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Booking Confirmed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'Your Hyundai service appointment has been received successfully.',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color: white40,
                    fontSize: 8,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 17),

                _successRow(
                  'Vehicle',
                  '${vehicleModel(vehicle)} • ${vehicleRegistration(vehicle)}',
                ),

                _successRow(
                  'Service',
                  selectedService ??
                      'Service',
                ),

                _successRow(
                  'Date',
                  _formatDate(
                    selectedDate,
                  ),
                ),

                _successRow(
                  'Time',
                  selectedTime ??
                      '--',
                ),

                _successRow(
                  'Centre',
                  center.name,
                ),

                _successRow(
                  'Booking ID',
                  appointmentId,
                ),

                const SizedBox(height: 17),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child:
                      ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        dialogContext,
                      ).pop();

                      Navigator.of(
                        context,
                      ).pop();
                    },
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          cyan,
                      foregroundColor:
                          navy,
                      elevation: 0,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          13,
                        ),
                      ),
                    ),
                    child:
                        const Text(
                      'DONE',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight:
                            FontWeight.bold,
                        letterSpacing: 1,
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

  Widget _successRow(
    String label,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 8,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 65,
            child: Text(
              label,
              style:
                  const TextStyle(
                color: white40,
                fontSize: 6.5,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style:
                  const TextStyle(
                color: white70,
                fontSize: 7,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

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
          behavior:
              SnackBarBehavior.floating,
          backgroundColor: navy3,
          margin:
              const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(13),
          ),
          content: Text(
            message,
            style:
                const TextStyle(
              color: Colors.white,
              fontSize: 8,
            ),
          ),
        ),
      );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: navy,
      body: Stack(
        children: [
          const Positioned.fill(
            child: CareBackground(
              child: SizedBox.expand(),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),

                Expanded(
                  child:
                      isLoadingVehicles
                          ? _buildLoading()
                          : _buildBody(),
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
      padding:
          const EdgeInsets.fromLTRB(
        14,
        10,
        14,
        8,
      ),
      child: Row(
        children: [
          _headerButton(
            Icons.arrow_back_ios_new_rounded,
            previousStep,
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Service Booking',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Schedule your Hyundai service with ease',
                  style: TextStyle(
                    color: white40,
                    fontSize: 7,
                  ),
                ),
              ],
            ),
          ),

          _headerButton(
            Icons.calendar_month_rounded,
            () {
              if (currentStep == 2) {
                chooseDate();
              } else {
                showMessage(
                  'Choose your service date in the Schedule step.',
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _headerButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(15),
        child: Container(
          width: 50,
          height: 50,
          decoration:
              BoxDecoration(
            color:
                Colors.white.withValues(
              alpha: 0.055,
            ),
            borderRadius:
                BorderRadius.circular(15),
            border: Border.all(
              color:
                  Colors.white.withValues(
                alpha: 0.09,
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
  // LOADING
  // ============================================================

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation:
                _pulseController,
            builder: (
              context,
              child,
            ) {
              return Transform.scale(
                scale:
                    1.0 +
                    (_pulseController
                            .value *
                        0.08),
                child:
                    const SizedBox(
                  width: 48,
                  height: 48,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                        AlwaysStoppedAnimation<
                            Color>(
                      cyan,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          const Text(
            'LOADING YOUR VEHICLES',
            style: TextStyle(
              color: cyan,
              fontSize: 7,
              fontWeight:
                  FontWeight.bold,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Getting your registered Hyundai vehicles...',
            style: TextStyle(
              color: white40,
              fontSize: 6.5,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody() {
    if (vehicles.isEmpty) {
      return _buildNoVehicles();
    }

    return Column(
      children: [
        _buildProgress(),

        Expanded(
          child:
              SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(),
            padding:
                const EdgeInsets.fromLTRB(
              17,
              10,
              17,
              20,
            ),
            child: AnimatedSwitcher(
              duration:
                  const Duration(
                milliseconds: 260,
              ),
              child:
                  _buildCurrentStep(),
            ),
          ),
        ),

        _buildBottomBar(),
      ],
    );
  }

  // ============================================================
  // NO VEHICLES
  // ============================================================

  Widget _buildNoVehicles() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(28),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,
                color:
                    cyan.withValues(
                  alpha: 0.07,
                ),
              ),
              child:
                  const Icon(
                Icons
                    .directions_car_outlined,
                color: cyan,
                size: 39,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'No Vehicle Found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Add your Hyundai vehicle before booking a service.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color: white40,
                fontSize: 8,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed:
                  loadVehicles,
              icon: const Icon(
                Icons.refresh_rounded,
                size: 17,
              ),
              label:
                  const Text(
                'RETRY',
              ),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    cyan,
                foregroundColor:
                    navy,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROGRESS
  // ============================================================

  Widget _buildProgress() {
    const labels = [
      'Vehicle',
      'Service',
      'Schedule',
      'Centre',
    ];

    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        18,
        5,
        18,
        3,
      ),
      child: Row(
        children:
            List.generate(
          labels.length,
          (index) {
            final active =
                index == currentStep;
            final complete =
                index < currentStep;

            return Expanded(
              child: Row(
                children: [
                  Column(
                    children: [
                      AnimatedContainer(
                        duration:
                            const Duration(
                          milliseconds: 200,
                        ),
                        width: 35,
                        height: 35,
                        decoration:
                            BoxDecoration(
                          shape:
                              BoxShape.circle,
                          color: active ||
                                  complete
                              ? blue
                              : Colors.white
                                  .withValues(
                                  alpha: 0.05,
                                ),
                          border:
                              Border.all(
                            color:
                                active ||
                                        complete
                                    ? cyan
                                    : Colors.white
                                        .withValues(
                                        alpha:
                                            0.08,
                                      ),
                          ),
                          boxShadow:
                              active
                                  ? [
                                      BoxShadow(
                                        color:
                                            cyan.withValues(
                                          alpha:
                                              0.20,
                                        ),
                                        blurRadius:
                                            14,
                                      ),
                                    ]
                                  : null,
                        ),
                        child:
                            complete
                                ? const Icon(
                                    Icons
                                        .check_rounded,
                                    color:
                                        Colors.white,
                                    size: 18,
                                  )
                                : Text(
                                    '${index + 1}',
                                    style:
                                        TextStyle(
                                      color:
                                          active
                                              ? Colors.white
                                              : white40,
                                      fontSize:
                                          8,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        labels[index],
                        style:
                            TextStyle(
                          color:
                              active
                                  ? white70
                                  : white40,
                          fontSize: 5.5,
                          fontWeight:
                              active
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),

                  if (index <
                      labels.length - 1)
                    Expanded(
                      child:
                          Container(
                        height: 1,
                        margin:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 6,
                        ),
                        color:
                            index <
                                    currentStep
                                ? cyan.withValues(
                                    alpha:
                                        0.45,
                                  )
                                : Colors.white
                                    .withValues(
                                    alpha:
                                        0.07,
                                  ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // CURRENT STEP
  // ============================================================

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 0:
        return _buildVehicleStep();

      case 1:
        return _buildServiceStep();

      case 2:
        return _buildScheduleStep();

      case 3:
        return _buildCenterStep();

      default:
        return const SizedBox();
    }
  }

  // ============================================================
  // VEHICLE STEP
  // ============================================================

  Widget _buildVehicleStep() {
    return Column(
      key: const ValueKey(
        'vehicle',
      ),
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _stepHeading(
          Icons
              .directions_car_filled_rounded,
          'Choose your vehicle',
          'Select the Hyundai you want to service.',
        ),

        const SizedBox(height: 14),

        ...vehicles.map(
          (vehicle) =>
              Padding(
            padding:
                const EdgeInsets.only(
              bottom: 11,
            ),
            child:
                _vehicleCard(vehicle),
          ),
        ),
      ],
    );
  }

  Widget _vehicleCard(
    Map<String, dynamic> vehicle,
  ) {
    final id =
        vehicleId(vehicle);

    final selected =
        id != null &&
            id == selectedVehicleId;

    final model =
        vehicleModel(vehicle);

    final registration =
        vehicleRegistration(
      vehicle,
    );

    final year =
        vehicleYear(vehicle);

    final color =
        vehicleColor(vehicle);

    return GestureDetector(
      onTap: () {
        if (id == null) {
          return;
        }

        setState(() {
          selectedVehicleId = id;
        });
      },
      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 200,
        ),
        padding:
            const EdgeInsets.all(15),
        decoration:
            BoxDecoration(
          gradient:
              selected
                  ? const LinearGradient(
                      begin:
                          Alignment.topLeft,
                      end:
                          Alignment.bottomRight,
                      colors: [
                        Color(
                          0xFF102F53,
                        ),
                        Color(
                          0xFF17205A,
                        ),
                      ],
                    )
                  : null,
          color:
              selected
                  ? null
                  : Colors.white
                      .withValues(
                      alpha: 0.035,
                    ),
          borderRadius:
              BorderRadius.circular(
            19,
          ),
          border:
              Border.all(
            color:
                selected
                    ? cyan.withValues(
                        alpha: 0.38,
                      )
                    : Colors.white
                        .withValues(
                        alpha: 0.07,
                      ),
          ),
          boxShadow:
              selected
                  ? [
                      BoxShadow(
                        color:
                            cyan.withValues(
                          alpha: 0.07,
                        ),
                        blurRadius: 20,
                      ),
                    ]
                  : null,
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration:
                  BoxDecoration(
                color:
                    cyan.withValues(
                  alpha: 0.07,
                ),
                borderRadius:
                    BorderRadius.circular(
                  16,
                ),
              ),
              child:
                  const Icon(
                Icons
                    .directions_car_filled_rounded,
                color: cyan,
                size: 30,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    model,
                    maxLines: 1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontSize: 11,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    registration,
                    maxLines: 1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        const TextStyle(
                      color: cyan,
                      fontSize: 7,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '$year • $color',
                    maxLines: 1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        const TextStyle(
                      color: white40,
                      fontSize: 6.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            AnimatedContainer(
              duration:
                  const Duration(
                milliseconds: 180,
              ),
              width: 25,
              height: 25,
              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,
                color:
                    selected
                        ? cyan
                        : Colors.white
                            .withValues(
                            alpha: 0.05,
                          ),
                border:
                    Border.all(
                  color:
                      selected
                          ? cyan
                          : Colors.white
                              .withValues(
                              alpha:
                                  0.10,
                            ),
                ),
              ),
              child:
                  selected
                      ? const Icon(
                          Icons.check_rounded,
                          color: navy,
                          size: 15,
                        )
                      : null,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SERVICE STEP
  // ============================================================

  Widget _buildServiceStep() {
    return Column(
      key: const ValueKey(
        'service',
      ),
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _stepHeading(
          Icons.build_circle_rounded,
          'Choose your service',
          'Select the service your vehicle needs.',
        ),

        const SizedBox(height: 14),

        ...serviceOptions.map(
          (service) =>
              Padding(
            padding:
                const EdgeInsets.only(
              bottom: 10,
            ),
            child:
                _serviceOptionCard(
              service,
            ),
          ),
        ),
      ],
    );
  }

  Widget _serviceOptionCard(
    _ServiceOption service,
  ) {
    final selected =
        selectedService ==
            service.title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedService =
              service.title;
        });
      },
      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 190,
        ),
        padding:
            const EdgeInsets.all(14),
        decoration:
            BoxDecoration(
          color:
              selected
                  ? service.color
                      .withValues(
                      alpha: 0.075,
                    )
                  : Colors.white
                      .withValues(
                      alpha: 0.035,
                    ),
          borderRadius:
              BorderRadius.circular(
            17,
          ),
          border:
              Border.all(
            color:
                selected
                    ? service.color
                        .withValues(
                        alpha: 0.30,
                      )
                    : Colors.white
                        .withValues(
                        alpha: 0.065,
                      ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 49,
              height: 49,
              decoration:
                  BoxDecoration(
                color:
                    service.color
                        .withValues(
                  alpha: 0.07,
                ),
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),
              child:
                  Icon(
                service.icon,
                color:
                    service.color,
                size: 24,
              ),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontSize: 9.5,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.subtitle,
                    style:
                        const TextStyle(
                      color: white40,
                      fontSize: 6.5,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              selected
                  ? Icons
                      .check_circle_rounded
                  : Icons
                      .radio_button_unchecked_rounded,
              color:
                  selected
                      ? service.color
                      : white20,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SCHEDULE STEP
  // ============================================================

  Widget _buildScheduleStep() {
    return Column(
      key: const ValueKey(
        'schedule',
      ),
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _stepHeading(
          Icons.calendar_month_rounded,
          'Choose your schedule',
          'Pick a convenient date and time.',
        ),

        const SizedBox(height: 14),

        _fieldLabel(
          'PREFERRED DATE',
        ),

        const SizedBox(height: 7),

        _selectionField(
          icon:
              Icons.calendar_today_rounded,
          title:
              selectedDate == null
                  ? 'Select service date'
                  : _formatDate(
                      selectedDate,
                    ),
          subtitle:
              selectedDate == null
                  ? 'Choose a date within the next 90 days'
                  : 'Tap to change date',
          onTap: chooseDate,
        ),

        const SizedBox(height: 16),

        _fieldLabel(
          'PREFERRED TIME',
        ),

        const SizedBox(height: 7),

        GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 9,
            crossAxisSpacing: 9,
            childAspectRatio: 3.2,
          ),
          itemCount:
              timeSlots.length,
          itemBuilder:
              (context, index) {
            final time =
                timeSlots[index];

            final selected =
                selectedTime ==
                    time;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTime =
                      time;
                });
              },
              child:
                  AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 170,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      selected
                          ? cyan.withValues(
                              alpha: 0.10,
                            )
                          : Colors.white
                              .withValues(
                              alpha: 0.035,
                            ),
                  borderRadius:
                      BorderRadius.circular(
                    11,
                  ),
                  border:
                      Border.all(
                    color:
                        selected
                            ? cyan.withValues(
                                alpha: 0.28,
                              )
                            : Colors.white
                                .withValues(
                                alpha:
                                    0.06,
                              ),
                  ),
                ),
                child: Center(
                  child: Text(
                    time,
                    style:
                        TextStyle(
                      color:
                          selected
                              ? cyan
                              : white70,
                      fontSize: 7,
                      fontWeight:
                          selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        _fieldLabel(
          'NOTES (OPTIONAL)',
        ),

        const SizedBox(height: 7),

        Container(
          decoration:
              BoxDecoration(
            color: Colors.white
                .withValues(
              alpha: 0.035,
            ),
            borderRadius:
                BorderRadius.circular(
              15,
            ),
            border:
                Border.all(
              color:
                  Colors.white.withValues(
                alpha: 0.07,
              ),
            ),
          ),
          child:
              TextField(
            controller:
                notesController,
            maxLines: 3,
            style:
                const TextStyle(
              color: Colors.white,
              fontSize: 8,
            ),
            decoration:
                const InputDecoration(
              hintText:
                  'Enter any additional notes...',
              hintStyle:
                  TextStyle(
                color: white20,
                fontSize: 8,
              ),
              border:
                  InputBorder.none,
              contentPadding:
                  EdgeInsets.all(14),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CENTRE STEP
  // ============================================================

  Widget _buildCenterStep() {
    return Column(
      key: const ValueKey(
        'centre',
      ),
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _stepHeading(
          Icons.location_on_rounded,
          'Choose your service centre',
          'Select where you want your Hyundai serviced.',
        ),

        const SizedBox(height: 14),

        if (selectedVehicle !=
            null)
          _bookingSummary(),

        const SizedBox(height: 14),

        ...serviceCenters.map(
          (center) =>
              Padding(
            padding:
                const EdgeInsets.only(
              bottom: 10,
            ),
            child:
                _centerCard(center),
          ),
        ),
      ],
    );
  }

  Widget _bookingSummary() {
    final vehicle =
        selectedVehicle!;

    return Container(
      padding:
          const EdgeInsets.all(14),
      decoration:
          BoxDecoration(
        color:
            cyan.withValues(
          alpha: 0.045,
        ),
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        border:
            Border.all(
          color:
              cyan.withValues(
            alpha: 0.10,
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons
                .directions_car_rounded,
            color: cyan,
            size: 21,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  vehicleModel(
                    vehicle,
                  ),
                  style:
                      const TextStyle(
                    color:
                        Colors.white,
                    fontSize: 8.5,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  vehicleRegistration(
                    vehicle,
                  ),
                  style:
                      const TextStyle(
                    color: cyan,
                    fontSize: 6.5,
                  ),
                ),
              ],
            ),
          ),
          Text(
            selectedService ??
                'Service',
            style:
                const TextStyle(
              color: white40,
              fontSize: 6.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _centerCard(
    _ServiceCenter center,
  ) {
    final selected =
        selectedCenterId ==
            center.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCenterId =
              center.id;
        });
      },
      child:
          AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 190,
        ),
        padding:
            const EdgeInsets.all(14),
        decoration:
            BoxDecoration(
          color:
              selected
                  ? cyan.withValues(
                      alpha: 0.07,
                    )
                  : Colors.white
                      .withValues(
                      alpha: 0.035,
                    ),
          borderRadius:
              BorderRadius.circular(
            17,
          ),
          border:
              Border.all(
            color:
                selected
                    ? cyan.withValues(
                        alpha: 0.30,
                      )
                    : Colors.white
                        .withValues(
                        alpha: 0.065,
                      ),
          ),
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 47,
              height: 47,
              decoration:
                  BoxDecoration(
                color:
                    blue.withValues(
                  alpha: 0.08,
                ),
                borderRadius:
                    BorderRadius.circular(
                  13,
                ),
              ),
              child:
                  const Icon(
                Icons.location_on_rounded,
                color: cyan,
                size: 23,
              ),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    center.name,
                    maxLines: 2,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontSize: 8.5,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    center.location,
                    style:
                        const TextStyle(
                      color: white40,
                      fontSize: 6.5,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Row(
                    children: [
                      const Icon(
                        Icons
                            .star_rounded,
                        color:
                            Color(
                          0xFFFFC857,
                        ),
                        size: 11,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        center.rating,
                        style:
                            const TextStyle(
                          color:
                              white70,
                          fontSize: 6,
                        ),
                      ),
                      const SizedBox(
                        width: 9,
                      ),
                      const Icon(
                        Icons
                            .near_me_rounded,
                        color:
                            cyan,
                        size: 10,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        center.distance,
                        style:
                            const TextStyle(
                          color:
                              white40,
                          fontSize: 6,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Icon(
              selected
                  ? Icons
                      .check_circle_rounded
                  : Icons
                      .radio_button_unchecked_rounded,
              color:
                  selected
                      ? cyan
                      : white20,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // STEP HEADING
  // ============================================================

  Widget _stepHeading(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration:
              BoxDecoration(
            color:
                cyan.withValues(
              alpha: 0.07,
            ),
            borderRadius:
                BorderRadius.circular(
              12,
            ),
          ),
          child: Icon(
            icon,
            color: cyan,
            size: 20,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(
                  color:
                      Colors.white,
                  fontSize: 12,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style:
                    const TextStyle(
                  color: white40,
                  fontSize: 6.5,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // FIELD LABEL
  // ============================================================

  Widget _fieldLabel(
    String text,
  ) {
    return Text(
      text,
      style: const TextStyle(
        color: white40,
        fontSize: 5.8,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  // ============================================================
  // SELECTION FIELD
  // ============================================================

  Widget _selectionField({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.all(13),
        decoration:
            BoxDecoration(
          color: Colors.white
              .withValues(
            alpha: 0.035,
          ),
          borderRadius:
              BorderRadius.circular(
            15,
          ),
          border:
              Border.all(
            color:
                Colors.white.withValues(
              alpha: 0.07,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration:
                  BoxDecoration(
                color:
                    cyan.withValues(
                  alpha: 0.07,
                ),
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
              child:
                  Icon(
                icon,
                color: cyan,
                size: 18,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(
                      color:
                          white70,
                      fontSize: 8,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style:
                        const TextStyle(
                      color: white40,
                      fontSize: 6,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons
                  .arrow_forward_ios_rounded,
              color: white20,
              size: 11,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM BAR
  // ============================================================

  Widget _buildBottomBar() {
    final canContinue =
        _canContinue();

    return SafeArea(
      top: false,
      child: Container(
        padding:
            const EdgeInsets.fromLTRB(
          17,
          9,
          17,
          10,
        ),
        decoration:
            BoxDecoration(
          color:
              navy.withValues(
            alpha: 0.94,
          ),
          border:
              Border(
            top:
                BorderSide(
              color:
                  Colors.white.withValues(
                alpha: 0.07,
              ),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 48,
                child:
                    OutlinedButton(
                  onPressed:
                      previousStep,
                  style:
                      OutlinedButton.styleFrom(
                    foregroundColor:
                        white70,
                    side:
                        BorderSide(
                      color:
                          Colors.white.withValues(
                        alpha: 0.10,
                      ),
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
                      Text(
                    currentStep == 0
                        ? 'CANCEL'
                        : 'BACK',
                    style:
                        const TextStyle(
                      fontSize: 7,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              flex: 2,
              child: SizedBox(
                height: 48,
                child:
                    ElevatedButton(
                  onPressed:
                      canContinue &&
                              !isBooking
                          ? nextStep
                          : null,
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        cyan,
                    disabledBackgroundColor:
                        Colors.white
                            .withValues(
                      alpha: 0.06,
                    ),
                    foregroundColor:
                        navy,
                    disabledForegroundColor:
                        white20,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),
                  ),
                  child:
                      isBooking
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2,
                                valueColor:
                                    AlwaysStoppedAnimation<
                                        Color>(
                                  navy,
                                ),
                              ),
                            )
                          : Text(
                              currentStep ==
                                      3
                                  ? 'BOOK SERVICE'
                                  : 'CONTINUE',
                              style:
                                  const TextStyle(
                                fontSize:
                                    7,
                                fontWeight:
                                    FontWeight.bold,
                                letterSpacing:
                                    .4,
                              ),
                            ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canContinue() {
    switch (currentStep) {
      case 0:
        return selectedVehicleId !=
            null;

      case 1:
        return selectedService !=
            null;

      case 2:
        return selectedDate !=
                null &&
            selectedTime != null;

      case 3:
        return selectedCenterId !=
            null;

      default:
        return false;
    }
  }

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String _formatDate(
    DateTime? date,
  ) {
    if (date == null) {
      return '--';
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} '
        '${months[date.month - 1]} '
        '${date.year}';
  }
}

// ================================================================
// SERVICE OPTION
// ================================================================

class _ServiceOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _ServiceOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

// ================================================================
// SERVICE CENTRE
// ================================================================

class _ServiceCenter {
  final int id;
  final String name;
  final String location;
  final String distance;
  final String rating;

  const _ServiceCenter({
    required this.id,
    required this.name,
    required this.location,
    required this.distance,
    required this.rating,
  });
}

// ================================================================
// FIRST-OR-NULL EXTENSION
// ================================================================

extension<T> on Iterable<T> {
  T? get firstOrNull {
    if (isEmpty) {
      return null;
    }

    return first;
  }
}