import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/care_background.dart';

class AddVehicleScreen extends StatefulWidget {
  final int customerId;

  const AddVehicleScreen({
    super.key,
    required this.customerId,
  });

  @override
  State<AddVehicleScreen> createState() =>
      _AddVehicleScreenState();
}

class _AddVehicleScreenState
    extends State<AddVehicleScreen>
    with TickerProviderStateMixin {
  // ============================================================
  // API
  // ============================================================

  static const String addVehicleUrl =
      'http://192.168.1.7/hyundai_care_plus_api/add_vehicle.php';

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController registrationController =
      TextEditingController();

  final TextEditingController modelController =
      TextEditingController();

  final TextEditingController yearController =
      TextEditingController();

  final TextEditingController colorController =
      TextEditingController();

  // ============================================================
  // STATE
  // ============================================================

  bool isLoading = false;

  String selectedFuelType = 'Petrol';

  int currentStep = 0;

  // ============================================================
  // ANIMATIONS
  // ============================================================

  late AnimationController entranceController;
  late AnimationController auroraController;
  late AnimationController carController;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    entranceController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 850,
      ),
    )..forward();

    auroraController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 16,
      ),
    )..repeat();

    carController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 3,
      ),
    )..repeat(
        reverse: true,
      );
  }

  // ============================================================
  // ADD VEHICLE
  // ============================================================

  Future<void> addVehicle() async {
    FocusScope.of(context).unfocus();

    final registration =
        registrationController.text
            .trim()
            .toUpperCase();

    final model =
        modelController.text.trim();

    final year =
        yearController.text.trim();

    final color =
        colorController.text.trim();

    // ==========================================================
    // CUSTOMER VALIDATION
    // ==========================================================

    if (widget.customerId <= 0) {
      showMessage(
        'Customer information is unavailable.',
      );
      return;
    }

    // ==========================================================
    // REGISTRATION VALIDATION
    // ==========================================================

    if (registration.isEmpty) {
      showMessage(
        'Please enter the registration number.',
      );
      return;
    }

    if (registration.length < 5) {
      showMessage(
        'Please enter a valid registration number.',
      );
      return;
    }

    // ==========================================================
    // MODEL VALIDATION
    // ==========================================================

    if (model.isEmpty) {
      showMessage(
        'Please enter the vehicle model.',
      );
      return;
    }

    // ==========================================================
    // YEAR VALIDATION
    // ==========================================================

    int? parsedYear;

    if (year.isNotEmpty) {
      parsedYear = int.tryParse(year);

      if (parsedYear == null) {
        showMessage(
          'Please enter a valid vehicle year.',
        );
        return;
      }

      if (parsedYear < 1900 ||
          parsedYear > DateTime.now().year + 1) {
        showMessage(
          'Please enter a valid vehicle year.',
        );
        return;
      }
    }

    // ==========================================================
    // LOADING
    // ==========================================================

    setState(() {
      isLoading = true;
    });

    try {
      debugPrint(
        '================================',
      );

      debugPrint(
        'ADDING VEHICLE',
      );

      debugPrint(
        'CUSTOMER ID: ${widget.customerId}',
      );

      debugPrint(
        'REGISTRATION: $registration',
      );

      debugPrint(
        'MODEL: $model',
      );

      debugPrint(
        'YEAR: $parsedYear',
      );

      debugPrint(
        'COLOR: $color',
      );

      debugPrint(
        'FUEL TYPE: $selectedFuelType',
      );

      debugPrint(
        '================================',
      );

      // ========================================================
      // IMPORTANT
      //
      // The existing backend contract accepts:
      // customer_id
      // registration_number
      // model
      // year
      // color
      //
      // We preserve that contract.
      // ========================================================

      final response = await http.post(
        Uri.parse(addVehicleUrl),
        headers: const {
          'Content-Type':
              'application/json',
          'Accept':
              'application/json',
        },
        body: jsonEncode({
          'customer_id':
              widget.customerId,
          'registration_number':
              registration,
          'model':
              model,
          'year':
              parsedYear,
          'color':
              color,
        }),
      );

      debugPrint(
        'ADD VEHICLE STATUS: '
        '${response.statusCode}',
      );

      debugPrint(
        'ADD VEHICLE RESPONSE: '
        '${response.body}',
      );

      if (!mounted) return;

      // ========================================================
      // HTTP ERROR
      // ========================================================

      if (response.statusCode != 200) {
        showMessage(
          'Server error: ${response.statusCode}',
        );
        return;
      }

      // ========================================================
      // EMPTY RESPONSE
      // ========================================================

      if (response.body.trim().isEmpty) {
        showMessage(
          'Server returned an empty response.',
        );
        return;
      }

      // ========================================================
      // JSON
      // ========================================================

      dynamic decoded;

      try {
        decoded = jsonDecode(
          response.body,
        );
      } catch (e) {
        debugPrint(
          'ADD VEHICLE JSON ERROR: $e',
        );

        showMessage(
          'Invalid response from server.',
        );
        return;
      }

      if (decoded is! Map) {
        showMessage(
          'Unexpected server response.',
        );
        return;
      }

      final Map<String, dynamic> data =
          Map<String, dynamic>.from(
        decoded,
      );

      // ========================================================
      // SUCCESS
      // ========================================================

      if (data['success'] == true) {
        await showSuccessDialog(
          data['vehicle_id'],
        );

        if (!mounted) return;

        Navigator.pop(
          context,
          true,
        );

        return;
      }

      // ========================================================
      // FAILURE
      // ========================================================

      final message =
          data['message']?.toString() ??
              'Unable to add vehicle.';

      showMessage(
        message,
      );
    } catch (e) {
      debugPrint(
        'ADD VEHICLE ERROR: $e',
      );

      if (!mounted) return;

      showMessage(
        'Unable to connect to the server.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // SUCCESS DIALOG
  // ============================================================

  Future<void> showSuccessDialog(
    dynamic vehicleId,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              const Color(
            0xFF101C35,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              24,
            ),
          ),
          icon: Container(
            width:
                68,
            height:
                68,
            decoration:
                const BoxDecoration(
              shape:
                  BoxShape.circle,
              gradient:
                  LinearGradient(
                colors: [
                  Color(
                    0xFF704CFF,
                  ),
                  Color(
                    0xFF00DFFF,
                  ),
                ],
              ),
            ),
            child:
                const Icon(
              Icons
                  .check_rounded,
              color:
                  Colors.white,
              size:
                  38,
            ),
          ),
          title:
              const Text(
            'Vehicle Added',
            textAlign:
                TextAlign.center,
            style:
                TextStyle(
              color:
                  Colors.white,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          content:
              const Text(
            'Your Hyundai has been successfully connected to your Care+ account.',
            textAlign:
                TextAlign.center,
            style:
                TextStyle(
              color:
                  Colors.white70,
              height:
                  1.4,
            ),
          ),
          actions: [
            SizedBox(
              width:
                  double.infinity,
              child:
                  ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    dialogContext,
                  );
                },
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xFF147DFF,
                  ),
                  foregroundColor:
                      Colors.white,
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
                  'Continue',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void showMessage(
    String message,
  ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior:
              SnackBarBehavior.floating,
          margin:
              const EdgeInsets.all(
            16,
          ),
          duration:
              const Duration(
            seconds: 3,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
          content:
              Text(
            message,
          ),
        ),
      );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    registrationController.dispose();
    modelController.dispose();
    yearController.dispose();
    colorController.dispose();

    entranceController.dispose();
    auroraController.dispose();
    carController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(
        0xFF020817,
      ),
      body:
          Stack(
        fit:
            StackFit.expand,
        children: [
          // ======================================================
          // ANIMATED BACKGROUND
          // ======================================================

          AnimatedBuilder(
            animation:
                auroraController,
            builder:
                (
              context,
              child,
            ) {
              return CustomPaint(
                painter:
                    _AddVehicleAuroraPainter(
                  progress:
                      auroraController.value,
                ),
              );
            },
          ),

          CareBackground(
            child:
                SafeArea(
              child:
                  _buildBody(),
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
    return CustomScrollView(
      physics:
          const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child:
              _buildHeader(),
        ),

        SliverPadding(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            35,
          ),
          sliver:
              SliverList(
            delegate:
                SliverChildListDelegate(
              [
                _animated(
                  0,
                  _buildProgressSteps(),
                ),

                const SizedBox(
                  height:
                      18,
                ),

                _animated(
                  1,
                  _buildVehiclePreview(),
                ),

                const SizedBox(
                  height:
                      18,
                ),

                _animated(
                  2,
                  _buildFormCard(),
                ),

                const SizedBox(
                  height:
                      18,
                ),

                _animated(
                  3,
                  _buildCareTip(),
                ),

                const SizedBox(
                  height:
                      22,
                ),

                _animated(
                  4,
                  _buildSaveButton(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        18,
        12,
        18,
        20,
      ),
      child:
          Row(
        children: [
          _circleButton(
            icon:
                Icons
                    .arrow_back_ios_new_rounded,
            onTap:
                isLoading
                    ? null
                    : () {
                        Navigator.pop(
                          context,
                        );
                      },
          ),

          const SizedBox(
            width:
                14,
          ),

          const Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Vehicle',
                  style:
                      TextStyle(
                    color:
                        Colors.white,
                    fontSize:
                        25,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height:
                      4,
                ),
                Text(
                  'Connect your Hyundai to Care+',
                  style:
                      TextStyle(
                    color:
                        Colors.white54,
                    fontSize:
                        10,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width:
                44,
            height:
                44,
            decoration:
                BoxDecoration(
              shape:
                  BoxShape.circle,
              color:
                  const Color(
                0xFF70E8FF,
              ).withValues(
                alpha:
                    0.08,
              ),
              border:
                  Border.all(
                color:
                    const Color(
                  0xFF70E8FF,
                ).withValues(
                  alpha:
                      0.18,
                ),
              ),
            ),
            child:
                const Icon(
              Icons
                  .directions_car_rounded,
              color:
                  Color(
                0xFF70E8FF,
              ),
              size:
                  21,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROGRESS STEPS
  // ============================================================

  Widget _buildProgressSteps() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            16,
        vertical:
            15,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white.withValues(
          alpha:
              0.055,
        ),
        borderRadius:
            BorderRadius.circular(
          20,
        ),
        border:
            Border.all(
          color:
              Colors.white.withValues(
            alpha:
                0.09,
          ),
        ),
      ),
      child:
          Row(
        children: [
          _step(
            number:
                '01',
            title:
                'Details',
            active:
                currentStep >=
                    0,
          ),
          _stepLine(),
          _step(
            number:
                '02',
            title:
                'Verify',
            active:
                currentStep >=
                    1,
          ),
          _stepLine(),
          _step(
            number:
                '03',
            title:
                'Connect',
            active:
                currentStep >=
                    2,
          ),
        ],
      ),
    );
  }

  Widget _step({
    required String number,
    required String title,
    required bool active,
  }) {
    return Expanded(
      child:
          Column(
        children: [
          Container(
            width:
                32,
            height:
                32,
            decoration:
                BoxDecoration(
              shape:
                  BoxShape.circle,
              gradient:
                  active
                      ? const LinearGradient(
                          colors: [
                            Color(
                              0xFF704CFF,
                            ),
                            Color(
                              0xFF00DFFF,
                            ),
                          ],
                        )
                      : null,
              color:
                  active
                      ? null
                      : Colors.white.withValues(
                          alpha:
                              0.06,
                        ),
            ),
            child:
                Center(
              child:
                  Text(
                number,
                style:
                    TextStyle(
                  color:
                      active
                          ? Colors.white
                          : Colors.white38,
                  fontSize:
                      9,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height:
                6,
          ),
          Text(
            title,
            style:
                TextStyle(
              color:
                  active
                      ? Colors.white
                      : Colors.white38,
              fontSize:
                  8,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepLine() {
    return Container(
      width:
          25,
      height:
          1,
      margin:
          const EdgeInsets.only(
        bottom:
            19,
      ),
      color:
          const Color(
        0xFF70E8FF,
      ).withValues(
        alpha:
            0.20,
      ),
    );
  }

  // ============================================================
  // VEHICLE PREVIEW
  // ============================================================

  Widget _buildVehiclePreview() {
    return AnimatedBuilder(
      animation:
          carController,
      builder:
          (
        context,
        child,
      ) {
        final y =
            math.sin(
                  carController.value *
                      math.pi,
                ) *
                4;

        return Transform.translate(
          offset:
              Offset(
            0,
            -y,
          ),
          child:
              Container(
            padding:
                const EdgeInsets.all(
              20,
            ),
            decoration:
                BoxDecoration(
              gradient:
                  const LinearGradient(
                begin:
                    Alignment.topLeft,
                end:
                    Alignment.bottomRight,
                colors: [
                  Color(
                    0xFF102B51,
                  ),
                  Color(
                    0xFF21184D,
                  ),
                  Color(
                    0xFF063D4A,
                  ),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(
                25,
              ),
              border:
                  Border.all(
                color:
                    Colors.white.withValues(
                  alpha:
                      0.12,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color(
                    0xFF00DFFF,
                  ).withValues(
                    alpha:
                        0.08,
                  ),
                  blurRadius:
                      30,
                ),
              ],
            ),
            child:
                Row(
              children: [
                Container(
                  width:
                      82,
                  height:
                      70,
                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white.withValues(
                      alpha:
                          0.06,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),
                  child:
                      const Icon(
                    Icons
                        .directions_car_filled_rounded,
                    color:
                        Colors.white,
                    size:
                        46,
                  ),
                ),

                const SizedBox(
                  width:
                      15,
                ),

                const Expanded(
                  child:
                      Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'YOUR NEXT RIDE',
                        style:
                            TextStyle(
                          color:
                              Colors.white38,
                          fontSize:
                              8,
                          letterSpacing:
                              1.5,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height:
                            5,
                      ),
                      Text(
                        'Hyundai Care+',
                        style:
                            TextStyle(
                          color:
                              Colors.white,
                          fontSize:
                              19,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height:
                            4,
                      ),
                      Text(
                        'Enter your details below to get started.',
                        style:
                            TextStyle(
                          color:
                              Colors.white54,
                          fontSize:
                              9,
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
    );
  }

  // ============================================================
  // FORM CARD
  // ============================================================

  Widget _buildFormCard() {
    return Container(
      padding:
          const EdgeInsets.all(
        20,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white.withValues(
          alpha:
              0.065,
        ),
        borderRadius:
            BorderRadius.circular(
          25,
        ),
        border:
            Border.all(
          color:
              Colors.white.withValues(
            alpha:
                0.11,
          ),
        ),
      ),
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Vehicle Information',
            style:
                TextStyle(
              color:
                  Colors.white,
              fontSize:
                  18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height:
                5,
          ),

          const Text(
            'Add the details exactly as they appear on your vehicle documents.',
            style:
                TextStyle(
              color:
                  Color(0x73FFFFFF),
              fontSize:
                  9,
              height:
                  1.4,
            ),
          ),

          const SizedBox(
            height:
                20,
          ),

          _field(
            controller:
                registrationController,
            label:
                'Registration Number',
            hint:
                'TN 07 AB 1234',
            icon:
                Icons
                    .confirmation_number_outlined,
            textCapitalization:
                TextCapitalization.characters,
            onChanged:
                (_) {
              setState(() {
                currentStep =
                    0;
              });
            },
          ),

          const SizedBox(
            height:
                15,
          ),

          _field(
            controller:
                modelController,
            label:
                'Vehicle Model',
            hint:
                'e.g. i20, Creta, Verna',
            icon:
                Icons
                    .directions_car_outlined,
            onChanged:
                (_) {
              if (registrationController
                      .text
                      .trim()
                      .isNotEmpty) {
                setState(() {
                  currentStep =
                      1;
                });
              }
            },
          ),

          const SizedBox(
            height:
                15,
          ),

          Row(
            children: [
              Expanded(
                child:
                    _field(
                  controller:
                      yearController,
                  label:
                      'Model Year',
                  hint:
                      '2025',
                  icon:
                      Icons
                          .calendar_today_outlined,
                  keyboardType:
                      TextInputType.number,
                ),
              ),

              const SizedBox(
                width:
                    12,
              ),

              Expanded(
                child:
                    _field(
                  controller:
                      colorController,
                  label:
                      'Colour',
                  hint:
                      'Polar White',
                  icon:
                      Icons
                          .palette_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(
            height:
                15,
          ),

          _fuelDropdown(),
        ],
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization =
        TextCapitalization.words,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller:
          controller,
      enabled:
          !isLoading,
      keyboardType:
          keyboardType,
      textCapitalization:
          textCapitalization,
      onChanged:
          onChanged,
      style:
          const TextStyle(
        color:
            Colors.white,
        fontSize:
            12,
      ),
      cursorColor:
          const Color(
        0xFF70E8FF,
      ),
      decoration:
          InputDecoration(
        labelText:
            label,
        hintText:
            hint,
        prefixIcon:
            Icon(
          icon,
          color:
              Colors.white54,
          size:
              19,
        ),
        labelStyle:
            const TextStyle(
          color:
              Color(0xA6FFFFFF),
          fontSize:
              11,
        ),
        hintStyle:
            const TextStyle(
          color:
              Colors.white30,
          fontSize:
              11,
        ),
        filled:
            true,
        fillColor:
            Colors.black.withValues(
          alpha:
              0.12,
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            15,
          ),
          borderSide:
              BorderSide(
            color:
                Colors.white.withValues(
              alpha:
                  0.10,
            ),
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            15,
          ),
          borderSide:
              const BorderSide(
            color:
                Color(
              0xFF70E8FF,
            ),
            width:
                1.4,
          ),
        ),
        disabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            15,
          ),
          borderSide:
              BorderSide(
            color:
                Colors.white.withValues(
              alpha:
                  0.05,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FUEL DROPDOWN
  // ============================================================

  Widget _fuelDropdown() {
    return DropdownButtonFormField<String>(
      initialValue:
          selectedFuelType,
      dropdownColor:
          const Color(
        0xFF101C35,
      ),
      style:
          const TextStyle(
        color:
            Colors.white,
        fontSize:
            12,
      ),
      decoration:
          InputDecoration(
        labelText:
            'Fuel Type',
        prefixIcon:
            const Icon(
          Icons
              .local_gas_station_outlined,
          color:
              Colors.white54,
          size:
              19,
        ),
        labelStyle:
            const TextStyle(
          color:
              Color(0xA6FFFFFF),
          fontSize:
              11,
        ),
        filled:
            true,
        fillColor:
            Colors.black.withValues(
          alpha:
              0.12,
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            15,
          ),
          borderSide:
              BorderSide(
            color:
                Colors.white.withValues(
              alpha:
                  0.10,
            ),
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            15,
          ),
          borderSide:
              const BorderSide(
            color:
                Color(
              0xFF70E8FF,
            ),
          ),
        ),
      ),
      items: const [
        DropdownMenuItem(
          value:
              'Petrol',
          child:
              Text(
            'Petrol',
          ),
        ),
        DropdownMenuItem(
          value:
              'Diesel',
          child:
              Text(
            'Diesel',
          ),
        ),
        DropdownMenuItem(
          value:
              'CNG',
          child:
              Text(
            'CNG',
          ),
        ),
        DropdownMenuItem(
          value:
              'Electric',
          child:
              Text(
            'Electric',
          ),
        ),
        DropdownMenuItem(
          value:
              'Hybrid',
          child:
              Text(
            'Hybrid',
          ),
        ),
      ],
      onChanged:
          isLoading
              ? null
              : (
                  value,
                ) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    selectedFuelType =
                        value;
                    currentStep =
                        2;
                  });
                },
    );
  }

  // ============================================================
  // CARE TIP
  // ============================================================

  Widget _buildCareTip() {
    return Container(
      padding:
          const EdgeInsets.all(
        17,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFF70E8FF,
        ).withValues(
          alpha:
              0.055,
        ),
        borderRadius:
            BorderRadius.circular(
          19,
        ),
        border:
            Border.all(
          color:
              const Color(
            0xFF70E8FF,
          ).withValues(
            alpha:
                0.12,
          ),
        ),
      ),
      child:
          Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width:
                38,
            height:
                38,
            decoration:
                BoxDecoration(
              shape:
                  BoxShape.circle,
              color:
                  const Color(
                0xFF70E8FF,
              ).withValues(
                alpha:
                    0.09,
              ),
            ),
            child:
                const Icon(
              Icons
                  .verified_user_outlined,
              color:
                  Color(
                0xFF70E8FF,
              ),
              size:
                  19,
            ),
          ),

          const SizedBox(
            width:
                11,
          ),

          const Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Care+ Security',
                  style:
                      TextStyle(
                    color:
                        Colors.white,
                    fontSize:
                        11,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height:
                      4,
                ),
                Text(
                  'Your vehicle is linked to your personal Care+ account using your authenticated customer ID.',
                  style:
                      TextStyle(
                    color:
                        Colors.white54,
                    fontSize:
                        9,
                    height:
                        1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SAVE BUTTON
  // ============================================================

  Widget _buildSaveButton() {
    return SizedBox(
      width:
          double.infinity,
      height:
          56,
      child:
          DecoratedBox(
        decoration:
            BoxDecoration(
          gradient:
              const LinearGradient(
            colors: [
              Color(
                0xFF704CFF,
              ),
              Color(
                0xFF00CFFF,
              ),
            ],
          ),
          borderRadius:
              BorderRadius.circular(
            17,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  const Color(
                0xFF00CFFF,
              ).withValues(
                alpha:
                    0.20,
              ),
              blurRadius:
                  24,
              offset:
                  const Offset(
                0,
                7,
              ),
            ),
          ],
        ),
        child:
            ElevatedButton(
          onPressed:
              isLoading
                  ? null
                  : addVehicle,
          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                Colors.transparent,
            disabledBackgroundColor:
                Colors.transparent,
            shadowColor:
                Colors.transparent,
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                17,
              ),
            ),
          ),
          child:
              isLoading
                  ? const SizedBox(
                      width:
                          24,
                      height:
                          24,
                      child:
                          CircularProgressIndicator(
                        color:
                            Colors.white,
                        strokeWidth:
                            2.5,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons
                              .add_circle_outline_rounded,
                          color:
                              Colors.white,
                          size:
                              21,
                        ),
                        SizedBox(
                          width:
                              9,
                        ),
                        Text(
                          'CONNECT VEHICLE',
                          style:
                              TextStyle(
                            color:
                                Colors.white,
                            fontSize:
                                12,
                            fontWeight:
                                FontWeight.bold,
                            letterSpacing:
                                1,
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  // ============================================================
  // CIRCLE BUTTON
  // ============================================================

  Widget _circleButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return Material(
      color:
          Colors.transparent,
      child:
          InkWell(
        onTap:
            onTap,
        borderRadius:
            BorderRadius.circular(
          14,
        ),
        child:
            Container(
          width:
              44,
          height:
              44,
          decoration:
              BoxDecoration(
            color:
                Colors.white.withValues(
              alpha:
                  0.07,
            ),
            borderRadius:
                BorderRadius.circular(
              14,
            ),
            border:
                Border.all(
              color:
                  Colors.white.withValues(
                alpha:
                    0.10,
              ),
            ),
          ),
          child:
              Icon(
            icon,
            color:
                Colors.white,
            size:
                19,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ENTRANCE ANIMATION
  // ============================================================

  Widget _animated(
    int index,
    Widget child,
  ) {
    return AnimatedBuilder(
      animation:
          entranceController,
      builder:
          (
        context,
        child,
      ) {
        final delay =
            index *
                0.08;

        final value =
            ((entranceController
                            .value -
                        delay) /
                    (1 -
                        delay))
                .clamp(
              0.0,
              1.0,
            );

        return Opacity(
          opacity:
              value,
          child:
              Transform.translate(
            offset:
                Offset(
              0,
              22 *
                  (1 - value),
            ),
            child:
                child,
          ),
        );
      },
      child:
          child,
    );
  }
}

// =================================================================
// AURORA PAINTER
// =================================================================

class _AddVehicleAuroraPainter
    extends CustomPainter {
  final double progress;

  _AddVehicleAuroraPainter({
    required this.progress,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint =
        Paint();

    final width =
        size.width;

    final height =
        size.height;

    final t =
        progress *
            math.pi *
            2;

    // ------------------------------------------------------------
    // CYAN NEBULA
    // ------------------------------------------------------------

    final cyanCenter =
        Offset(
      width *
          (0.22 +
              math.sin(t) *
                  0.10),
      height *
          (0.25 +
              math.cos(t) *
                  0.05),
    );

    paint.shader =
        RadialGradient(
      colors: [
        const Color(
          0xFF00E5FF,
        ).withValues(
          alpha:
              0.09,
        ),
        Colors.transparent,
      ],
    ).createShader(
      Rect.fromCircle(
        center:
            cyanCenter,
        radius:
            width *
                0.65,
      ),
    );

    canvas.drawRect(
      Offset.zero &
          size,
      paint,
    );

    // ------------------------------------------------------------
    // PURPLE NEBULA
    // ------------------------------------------------------------

    final purpleCenter =
        Offset(
      width *
          (0.82 +
              math.cos(t) *
                  0.10),
      height *
          (0.55 +
              math.sin(t) *
                  0.08),
    );

    paint.shader =
        RadialGradient(
      colors: [
        const Color(
          0xFF8C5CFF,
        ).withValues(
          alpha:
              0.075,
        ),
        Colors.transparent,
      ],
    ).createShader(
      Rect.fromCircle(
        center:
            purpleCenter,
        radius:
            width *
                0.60,
      ),
    );

    canvas.drawRect(
      Offset.zero &
          size,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _AddVehicleAuroraPainter oldDelegate,
  ) {
    return oldDelegate.progress !=
        progress;
  }
}