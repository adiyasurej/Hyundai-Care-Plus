import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/care_background.dart';

class VehicleManagementScreen extends StatefulWidget {
  final int? customerId;

  const VehicleManagementScreen({
    super.key,
    this.customerId,
  });

  @override
  State<VehicleManagementScreen> createState() =>
      _VehicleManagementScreenState();
}

class _VehicleManagementScreenState
    extends State<VehicleManagementScreen>
    with TickerProviderStateMixin {
  late AnimationController auroraController;
  late AnimationController entranceController;
  late AnimationController pulseController;

  final List<Vehicle> vehicles = [
    Vehicle(
      id: '1',
      model: 'Hyundai Creta',
      variant: 'SX(O) 1.5 Turbo',
      registration: 'TN 00 XX 0000',
      year: '2024',
      fuel: 'Petrol',
      transmission: 'Automatic',
      color: 'Titan Grey',
      mileage: '12,450 km',
      insurance: 'Active',
      insuranceExpiry: '18 Dec 2026',
      serviceDue: '2,550 km',
      isPrimary: true,
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

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    auroraController.dispose();
    entranceController.dispose();
    pulseController.dispose();
    super.dispose();
  }

  // ============================================================
  // ADD VEHICLE
  // ============================================================

  void openAddVehicle() {
    final modelController = TextEditingController();
    final variantController = TextEditingController();
    final registrationController = TextEditingController();
    final yearController = TextEditingController();
    final mileageController = TextEditingController();

    String fuel = 'Petrol';
    String transmission = 'Automatic';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF07152C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                22,
                18,
                22,
                MediaQuery.of(context).viewInsets.bottom + 25,
              ),
              child: SingleChildScrollView(
                child: Column(
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

                    const Text(
                      'Add Your Hyundai',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Add another vehicle to your Care+ account.',
                      style: TextStyle(
                        color: Color(0x73FFFFFF),
                        fontSize: 9,
                      ),
                    ),

                    const SizedBox(height: 22),

                    _modalField(
                      controller: modelController,
                      label: 'Vehicle Model',
                      hint: 'e.g. Hyundai Creta',
                      icon:
                          Icons.directions_car_filled_rounded,
                    ),

                    const SizedBox(height: 12),

                    _modalField(
                      controller: variantController,
                      label: 'Variant',
                      hint: 'e.g. SX(O) 1.5 Turbo',
                      icon: Icons.auto_awesome_rounded,
                    ),

                    const SizedBox(height: 12),

                    _modalField(
                      controller: registrationController,
                      label: 'Registration Number',
                      hint: 'e.g. TN 00 XX 0000',
                      icon: Icons.confirmation_number_outlined,
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _modalField(
                            controller: yearController,
                            label: 'Year',
                            hint: '2024',
                            icon:
                                Icons.calendar_today_outlined,
                            keyboardType:
                                TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _modalField(
                            controller: mileageController,
                            label: 'Mileage',
                            hint: '12,450 km',
                            icon: Icons.speed_rounded,
                            keyboardType:
                                TextInputType.number,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    _dropdownField(
                      title: 'Fuel Type',
                      value: fuel,
                      values: const [
                        'Petrol',
                        'Diesel',
                        'Electric',
                        'CNG',
                        'Hybrid',
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setModalState(() {
                          fuel = value;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    _dropdownField(
                      title: 'Transmission',
                      value: transmission,
                      values: const [
                        'Automatic',
                        'Manual',
                        'AMT',
                        'DCT',
                        'CVT',
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setModalState(() {
                          transmission = value;
                        });
                      },
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          final model =
                              modelController.text.trim();

                          if (model.isEmpty) {
                            showMessage(
                              'Please enter the vehicle model.',
                            );
                            return;
                          }

                          if (registrationController
                              .text
                              .trim()
                              .isEmpty) {
                            showMessage(
                              'Please enter the registration number.',
                            );
                            return;
                          }

                          setState(() {
                            vehicles.add(
                              Vehicle(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                model: model,
                                variant:
                                    variantController.text
                                            .trim()
                                            .isEmpty
                                        ? 'Standard Variant'
                                        : variantController
                                            .text
                                            .trim(),
                                registration:
                                    registrationController
                                        .text
                                        .trim()
                                        .toUpperCase(),
                                year:
                                    yearController.text
                                            .trim()
                                            .isEmpty
                                        ? 'Not specified'
                                        : yearController
                                            .text
                                            .trim(),
                                fuel: fuel,
                                transmission: transmission,
                                color: 'Not specified',
                                mileage:
                                    mileageController.text
                                            .trim()
                                            .isEmpty
                                        ? 'Not specified'
                                        : mileageController
                                            .text
                                            .trim(),
                                insurance: 'Not verified',
                                insuranceExpiry:
                                    'Not available',
                                serviceDue:
                                    'Not available',
                                isPrimary: vehicles.isEmpty,
                              ),
                            );
                          });

                          Navigator.pop(context);

                          showMessage(
                            '$model added to your vehicles.',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF147DFF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'ADD VEHICLE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
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
      },
    );
  }

  // ============================================================
  // VEHICLE DETAILS
  // ============================================================

  void showVehicleDetails(
    Vehicle vehicle,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF07152C),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              22,
              18,
              22,
              28,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 22),

                  _largeCarIcon(),

                  const SizedBox(height: 15),

                  Text(
                    vehicle.model,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    vehicle.variant,
                    style: const TextStyle(
                      color: Color(0x73FFFFFF),
                      fontSize: 9,
                    ),
                  ),

                  const SizedBox(height: 8),

                  _registrationBadge(
                    vehicle.registration,
                  ),

                  const SizedBox(height: 22),

                  _detailTile(
                    Icons.calendar_today_outlined,
                    'Model Year',
                    vehicle.year,
                  ),

                  _detailTile(
                    Icons.speed_rounded,
                    'Current Mileage',
                    vehicle.mileage,
                  ),

                  _detailTile(
                    Icons.local_gas_station_outlined,
                    'Fuel',
                    vehicle.fuel,
                  ),

                  _detailTile(
                    Icons.settings_outlined,
                    'Transmission',
                    vehicle.transmission,
                  ),

                  _detailTile(
                    Icons.palette_outlined,
                    'Colour',
                    vehicle.color,
                  ),

                  _detailTile(
                    Icons.shield_outlined,
                    'Insurance',
                    vehicle.insurance,
                  ),

                  _detailTile(
                    Icons.event_available_outlined,
                    'Insurance Expiry',
                    vehicle.insuranceExpiry,
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            openEditVehicle(vehicle);
                          },
                          icon:
                              const Icon(
                            Icons.edit_rounded,
                            size: 17,
                          ),
                          label:
                              const Text(
                            'EDIT',
                          ),
                          style:
                              OutlinedButton.styleFrom(
                            foregroundColor:
                                const Color(0xFF70E8FF),
                            side:
                                BorderSide(
                              color:
                                  const Color(0xFF70E8FF)
                                      .withValues(
                                alpha: 0.25,
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
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            setPrimaryVehicle(
                              vehicle,
                            );
                          },
                          icon:
                              const Icon(
                            Icons.star_rounded,
                            size: 17,
                          ),
                          label:
                              const Text(
                            'PRIMARY',
                          ),
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
                                14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // EDIT VEHICLE
  // ============================================================

  void openEditVehicle(
    Vehicle vehicle,
  ) {
    final modelController =
        TextEditingController(
      text: vehicle.model,
    );

    final variantController =
        TextEditingController(
      text: vehicle.variant,
    );

    final registrationController =
        TextEditingController(
      text: vehicle.registration,
    );

    final mileageController =
        TextEditingController(
      text: vehicle.mileage,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF07152C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            22,
            18,
            22,
            MediaQuery.of(context).viewInsets.bottom +
                25,
          ),
          child: SingleChildScrollView(
            child: Column(
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

                const Text(
                  'Edit Vehicle',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                _modalField(
                  controller: modelController,
                  label: 'Vehicle Model',
                  hint: 'Hyundai Creta',
                  icon:
                      Icons.directions_car_filled_rounded,
                ),

                const SizedBox(height: 12),

                _modalField(
                  controller: variantController,
                  label: 'Variant',
                  hint: 'SX(O)',
                  icon: Icons.auto_awesome_rounded,
                ),

                const SizedBox(height: 12),

                _modalField(
                  controller:
                      registrationController,
                  label: 'Registration',
                  hint: 'TN 00 XX 0000',
                  icon:
                      Icons.confirmation_number_outlined,
                ),

                const SizedBox(height: 12),

                _modalField(
                  controller: mileageController,
                  label: 'Current Mileage',
                  hint: '12,450 km',
                  icon: Icons.speed_rounded,
                ),

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final index =
                          vehicles.indexWhere(
                        (item) =>
                            item.id ==
                            vehicle.id,
                      );

                      if (index == -1) {
                        return;
                      }

                      setState(() {
                        vehicles[index] =
                            vehicle.copyWith(
                          model:
                              modelController.text
                                      .trim()
                                      .isEmpty
                                  ? vehicle.model
                                  : modelController
                                      .text
                                      .trim(),
                          variant:
                              variantController.text
                                      .trim()
                                      .isEmpty
                                  ? vehicle.variant
                                  : variantController
                                      .text
                                      .trim(),
                          registration:
                              registrationController
                                  .text
                                  .trim()
                                  .toUpperCase(),
                          mileage:
                              mileageController
                                  .text
                                  .trim()
                                  .isEmpty
                              ? vehicle.mileage
                              : mileageController
                                  .text
                                  .trim(),
                        );
                      });

                      Navigator.pop(context);

                      showMessage(
                        'Vehicle details updated.',
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
                          15,
                        ),
                      ),
                    ),
                    child:
                        const Text(
                      'SAVE CHANGES',
                      style:
                          TextStyle(
                        fontSize:
                            10,
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

  // ============================================================
  // PRIMARY VEHICLE
  // ============================================================

  void setPrimaryVehicle(
    Vehicle vehicle,
  ) {
    setState(() {
      for (int i = 0;
          i < vehicles.length;
          i++) {
        vehicles[i] =
            vehicles[i].copyWith(
          isPrimary:
              vehicles[i].id ==
                  vehicle.id,
        );
      }
    });

    showMessage(
      '${vehicle.model} is now your primary vehicle.',
    );
  }

  // ============================================================
  // DELETE VEHICLE
  // ============================================================

  void deleteVehicle(
    Vehicle vehicle,
  ) {
    if (vehicles.length == 1) {
      showMessage(
        'You must keep at least one vehicle.',
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFF08172F),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(22),
          ),
          title:
              const Text(
            'Remove Vehicle?',
            style:
                TextStyle(
              color:
                  Colors.white,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          content:
              Text(
            'Remove ${vehicle.model} from your Care+ vehicle list?',
            style:
                const TextStyle(
              color:
                  Color(0x73FFFFFF),
              fontSize:
                  10,
            ),
          ),
          actions: [
            TextButton(
              onPressed:
                  () {
                Navigator.pop(context);
              },
              child:
                  const Text(
                'CANCEL',
              ),
            ),
            ElevatedButton(
              onPressed:
                  () {
                setState(() {
                  vehicles.removeWhere(
                    (item) =>
                        item.id ==
                        vehicle.id,
                  );

                  if (!vehicles.any(
                    (item) =>
                        item.isPrimary,
                  )) {
                    vehicles[0] =
                        vehicles[0]
                            .copyWith(
                      isPrimary:
                          true,
                    );
                  }
                });

                Navigator.pop(context);

                showMessage(
                  'Vehicle removed.',
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFFE84963,
                ),
              ),
              child:
                  const Text(
                'REMOVE',
              ),
            ),
          ],
        );
      },
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
      backgroundColor:
          const Color(0xFF020817),
      body:
          Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation:
                auroraController,
            builder:
                (context, child) {
              return CustomPaint(
                painter:
                    _VehicleAuroraPainter(
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
                  _buildPage(),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PAGE
  // ============================================================

  Widget _buildPage() {
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
                  _buildOverview(),
                ),

                const SizedBox(height: 18),

                _animated(
                  1,
                  _buildVehicleCount(),
                ),

                const SizedBox(height: 14),

                ...List.generate(
                  vehicles.length,
                  (index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 14,
                      ),
                      child:
                          _animated(
                        index + 2,
                        _vehicleCard(
                          vehicles[index],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 4),

                _animated(
                  vehicles.length + 2,
                  _addVehicleButton(),
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
                () {
                  Navigator.pop(
                    context,
                  );
                },
          ),

          const SizedBox(
            width: 14,
          ),

          const Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'My Vehicles',
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
                SizedBox(height: 4),
                Text(
                  'Manage your Hyundai Care+ vehicles',
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

          _circleButton(
            icon:
                Icons.add_rounded,
            onTap:
                openAddVehicle,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // OVERVIEW
  // ============================================================

  Widget _buildOverview() {
    final primary =
        vehicles.firstWhere(
      (vehicle) =>
          vehicle.isPrimary,
      orElse:
          () => vehicles.first,
    );

    return Container(
      padding:
          const EdgeInsets.all(20),
      decoration:
          BoxDecoration(
        gradient:
            const LinearGradient(
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
          colors: [
            Color(0xFF102D52),
            Color(0xFF25174D),
            Color(0xFF073B45),
          ],
        ),
        borderRadius:
            BorderRadius.circular(26),
        border:
            Border.all(
          color:
              Colors.white.withValues(
            alpha: 0.11,
          ),
        ),
      ),
      child:
          Row(
        children: [
          AnimatedBuilder(
            animation:
                pulseController,
            builder:
                (context, child) {
              final scale =
                  0.97 +
                      pulseController.value *
                          0.035;

              return Transform.scale(
                scale:
                    scale,
                child:
                    _largeCarIcon(),
              );
            },
          ),

          const SizedBox(
            width: 15,
          ),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Primary Vehicle',
                  style:
                      TextStyle(
                    color:
                        Colors.white38,
                    fontSize:
                        8,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  primary.model,
                  style:
                      const TextStyle(
                    color:
                        Colors.white,
                    fontSize:
                        17,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  primary.registration,
                  style:
                      const TextStyle(
                    color:
                        Color(0xFF70E8FF),
                    fontSize:
                        9,
                    fontWeight:
                        FontWeight.bold,
                    letterSpacing:
                        0.5,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons
                .verified_rounded,
            color:
                Color(0xFF7BFFB2),
            size:
                23,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COUNT
  // ============================================================

  Widget _buildVehicleCount() {
    return Row(
      children: [
        const Text(
          'Your Vehicles',
          style:
              TextStyle(
            color:
                Colors.white,
            fontSize:
                14,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(
          width: 7,
        ),

        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 7,
            vertical: 4,
          ),
          decoration:
              BoxDecoration(
            color:
                const Color(
              0xFF70E8FF,
            ).withValues(
              alpha: 0.07,
            ),
            borderRadius:
                BorderRadius.circular(8),
          ),
          child:
              Text(
            '${vehicles.length}',
            style:
                const TextStyle(
              color:
                  Color(0xFF70E8FF),
              fontSize:
                  8,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),

        const Spacer(),

        const Text(
          'TAP FOR DETAILS',
          style:
              TextStyle(
            color:
                Colors.white24,
            fontSize:
                7,
            fontWeight:
                FontWeight.bold,
            letterSpacing:
                0.5,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // VEHICLE CARD
  // ============================================================

  Widget _vehicleCard(
    Vehicle vehicle,
  ) {
    return GestureDetector(
      onTap: () {
        showVehicleDetails(
          vehicle,
        );
      },
      child:
          Container(
        padding:
            const EdgeInsets.all(17),
        decoration:
            BoxDecoration(
          color:
              Colors.white.withValues(
            alpha:
                vehicle.isPrimary
                    ? 0.065
                    : 0.045,
          ),
          borderRadius:
              BorderRadius.circular(23),
          border:
              Border.all(
            color:
                vehicle.isPrimary
                    ? const Color(
                        0xFF70E8FF,
                      ).withValues(
                        alpha:
                            0.18,
                      )
                    : Colors.white
                        .withValues(
                        alpha:
                            0.07,
                      ),
          ),
        ),
        child:
            Column(
          children: [
            Row(
              children: [
                _vehicleIcon(),

                const SizedBox(
                  width: 13,
                ),

                Expanded(
                  child:
                      Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child:
                                Text(
                              vehicle.model,
                              maxLines:
                                  1,
                              overflow:
                                  TextOverflow.ellipsis,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontSize:
                                    14,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          if (vehicle.isPrimary) ...[
                            const SizedBox(
                              width: 7,
                            ),
                            _primaryBadge(),
                          ],
                        ],
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        vehicle.variant,
                        style:
                            const TextStyle(
                          color:
                              Colors.white38,
                          fontSize:
                              8,
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        vehicle.registration,
                        style:
                            const TextStyle(
                          color:
                              Color(
                            0xFF70E8FF,
                          ),
                          fontSize:
                              8,
                          fontWeight:
                              FontWeight.bold,
                          letterSpacing:
                              0.6,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons
                      .arrow_forward_ios_rounded,
                  color:
                      Colors.white24,
                  size:
                      13,
                ),
              ],
            ),

            const SizedBox(
              height: 15,
            ),

            Container(
              height: 1,
              color:
                  Colors.white.withValues(
                alpha:
                    0.05,
              ),
            ),

            const SizedBox(
              height: 13,
            ),

            Row(
              children: [
                Expanded(
                  child:
                      _vehicleStat(
                    Icons
                        .speed_rounded,
                    vehicle.mileage,
                    'Mileage',
                  ),
                ),

                Expanded(
                  child:
                      _vehicleStat(
                    Icons
                        .local_gas_station_outlined,
                    vehicle.fuel,
                    'Fuel',
                  ),
                ),

                Expanded(
                  child:
                      _vehicleStat(
                    Icons
                        .settings_outlined,
                    vehicle.transmission,
                    'Gearbox',
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 13,
            ),

            Row(
              children: [
                Expanded(
                  child:
                      _careStatus(
                    vehicle,
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                _vehicleMenu(
                  vehicle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // VEHICLE ICON
  // ============================================================

  Widget _vehicleIcon() {
    return Container(
      width: 55,
      height: 55,
      decoration:
          BoxDecoration(
        borderRadius:
            BorderRadius.circular(17),
        gradient:
            const LinearGradient(
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
          colors: [
            Color(0xFF172F52),
            Color(0xFF18204D),
          ],
        ),
        border:
            Border.all(
          color:
              const Color(
            0xFF70E8FF,
          ).withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child:
          const Icon(
        Icons
            .directions_car_filled_rounded,
        color:
            Color(0xFF70E8FF),
        size:
            27,
      ),
    );
  }

  // ============================================================
  // LARGE ICON
  // ============================================================

  Widget _largeCarIcon() {
    return Container(
      width: 64,
      height: 64,
      decoration:
          BoxDecoration(
        shape:
            BoxShape.circle,
        color:
            const Color(
          0xFF70E8FF,
        ).withValues(
          alpha: 0.08,
        ),
        border:
            Border.all(
          color:
              const Color(
            0xFF70E8FF,
          ).withValues(
            alpha: 0.18,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                const Color(
              0xFF70E8FF,
            ).withValues(
              alpha: 0.06,
            ),
            blurRadius:
                25,
          ),
        ],
      ),
      child:
          const Icon(
        Icons
            .directions_car_filled_rounded,
        color:
            Color(0xFF70E8FF),
        size:
            31,
      ),
    );
  }

  // ============================================================
  // PRIMARY BADGE
  // ============================================================

  Widget _primaryBadge() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 3,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFFFFC857,
        ).withValues(
          alpha: 0.09,
        ),
        borderRadius:
            BorderRadius.circular(7),
      ),
      child:
          const Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            color:
                Color(0xFFFFC857),
            size:
                9,
          ),
          SizedBox(
            width: 3,
          ),
          Text(
            'PRIMARY',
            style:
                TextStyle(
              color:
                  Color(0xFFFFC857),
              fontSize:
                  5.5,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VEHICLE STAT
  // ============================================================

  Widget _vehicleStat(
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color:
              const Color(
            0xFF70E8FF,
          ),
          size:
              16,
        ),

        const SizedBox(
          height: 5,
        ),

        Text(
          value,
          maxLines:
              1,
          overflow:
              TextOverflow.ellipsis,
          style:
              const TextStyle(
            color:
                Colors.white70,
            fontSize:
                8,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 2,
        ),

        Text(
          label,
          style:
              const TextStyle(
            color:
                Colors.white30,
            fontSize:
                6.5,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CARE STATUS
  // ============================================================

  Widget _careStatus(
    Vehicle vehicle,
  ) {
    final active =
        vehicle.insurance ==
            'Active';

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration:
          BoxDecoration(
        color:
            (active
                    ? const Color(
                        0xFF7BFFB2,
                      )
                    : const Color(
                        0xFFFFC857,
                      ))
                .withValues(
          alpha:
              0.045,
        ),
        borderRadius:
            BorderRadius.circular(
          11,
        ),
      ),
      child:
          Row(
        children: [
          Icon(
            active
                ? Icons
                    .shield_rounded
                : Icons
                    .info_outline_rounded,
            color:
                active
                    ? const Color(
                        0xFF7BFFB2,
                      )
                    : const Color(
                        0xFFFFC857,
                      ),
            size:
                14,
          ),

          const SizedBox(
            width: 6,
          ),

          Expanded(
            child:
                Text(
              active
                  ? 'Insurance Active'
                  : 'Verify Insurance',
              maxLines:
                  1,
              overflow:
                  TextOverflow.ellipsis,
              style:
                  TextStyle(
                color:
                    active
                        ? const Color(
                            0xFF7BFFB2,
                          )
                        : const Color(
                            0xFFFFC857,
                          ),
                fontSize:
                    7,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VEHICLE MENU
  // ============================================================

  Widget _vehicleMenu(
    Vehicle vehicle,
  ) {
    return PopupMenuButton<String>(
      color:
          const Color(
        0xFF0A1B34,
      ),
      icon:
          const Icon(
        Icons.more_vert_rounded,
        color:
            Colors.white38,
        size:
            20,
      ),
      onSelected:
          (value) {
        if (value ==
            'details') {
          showVehicleDetails(
            vehicle,
          );
        } else if (value ==
            'primary') {
          setPrimaryVehicle(
            vehicle,
          );
        } else if (value ==
            'edit') {
          openEditVehicle(
            vehicle,
          );
        } else if (value ==
            'delete') {
          deleteVehicle(
            vehicle,
          );
        }
      },
      itemBuilder:
          (context) => [
        const PopupMenuItem(
          value:
              'details',
          child:
              Text(
            'View Details',
            style:
                TextStyle(
              color:
                  Colors.white,
              fontSize:
                  11,
            ),
          ),
        ),
        const PopupMenuItem(
          value:
              'primary',
          child:
              Text(
            'Make Primary',
            style:
                TextStyle(
              color:
                  Colors.white,
              fontSize:
                  11,
            ),
          ),
        ),
        const PopupMenuItem(
          value:
              'edit',
          child:
              Text(
            'Edit Vehicle',
            style:
                TextStyle(
              color:
                  Colors.white,
              fontSize:
                  11,
            ),
          ),
        ),
        const PopupMenuItem(
          value:
              'delete',
          child:
              Text(
            'Remove Vehicle',
            style:
                TextStyle(
              color:
                  Color(
                0xFFFF7185,
              ),
              fontSize:
                  11,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ADD BUTTON
  // ============================================================

  Widget _addVehicleButton() {
    return SizedBox(
      width:
          double.infinity,
      height:
          55,
      child:
          OutlinedButton.icon(
        onPressed:
            openAddVehicle,
        icon:
            const Icon(
          Icons.add_circle_outline_rounded,
          size:
              19,
        ),
        label:
            const Text(
          'ADD ANOTHER VEHICLE',
          style:
              TextStyle(
            fontSize:
                9,
            fontWeight:
                FontWeight.bold,
            letterSpacing:
                0.6,
          ),
        ),
        style:
            OutlinedButton.styleFrom(
          foregroundColor:
              const Color(
            0xFF70E8FF,
          ),
          backgroundColor:
              const Color(
            0xFF70E8FF,
          ).withValues(
            alpha:
                0.025,
          ),
          side:
              BorderSide(
            color:
                const Color(
              0xFF70E8FF,
            ).withValues(
              alpha:
                  0.20,
            ),
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              17,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DETAIL TILE
  // ============================================================

  Widget _detailTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 8,
      ),
      padding:
          const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 11,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white.withValues(
          alpha: 0.035,
        ),
        borderRadius:
            BorderRadius.circular(13),
      ),
      child:
          Row(
        children: [
          Icon(
            icon,
            color:
                const Color(
              0xFF70E8FF,
            ),
            size:
                17,
          ),

          const SizedBox(
            width: 10,
          ),

          Text(
            title,
            style:
                const TextStyle(
              color:
                  Colors.white38,
              fontSize:
                  8,
            ),
          ),

          const Spacer(),

          Flexible(
            child:
                Text(
              value,
              textAlign:
                  TextAlign.right,
              style:
                  const TextStyle(
                color:
                    Colors.white70,
                fontSize:
                    9,
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
  // REGISTRATION BADGE
  // ============================================================

  Widget _registrationBadge(
    String registration,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 6,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFF70E8FF,
        ).withValues(
          alpha: 0.06,
        ),
        borderRadius:
            BorderRadius.circular(9),
      ),
      child:
          Text(
        registration,
        style:
            const TextStyle(
          color:
              Color(0xFF70E8FF),
          fontSize:
              8,
          fontWeight:
              FontWeight.bold,
          letterSpacing:
              0.8,
        ),
      ),
    );
  }

  // ============================================================
  // MODAL FIELD
  // ============================================================

  Widget _modalField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller:
          controller,
      keyboardType:
          keyboardType,
      style:
          const TextStyle(
        color:
            Colors.white,
        fontSize:
            10,
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
        labelStyle:
            const TextStyle(
          color:
              Color(0x73FFFFFF),
          fontSize:
              9,
        ),
        hintStyle:
            const TextStyle(
          color:
              Colors.white24,
          fontSize:
              9,
        ),
        prefixIcon:
            Icon(
          icon,
          color:
              const Color(
            0xFF70E8FF,
          ),
          size:
              18,
        ),
        filled:
            true,
        fillColor:
            Colors.white.withValues(
          alpha:
              0.035,
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              BorderSide(
            color:
                Colors.white.withValues(
              alpha:
                  0.07,
            ),
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
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
    );
  }

  // ============================================================
  // DROPDOWN
  // ============================================================

  Widget _dropdownField({
    required String title,
    required String value,
    required List<String> values,
    required ValueChanged<String?>
        onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue:
          value,
      dropdownColor:
          const Color(
        0xFF0A1B34,
      ),
      style:
          const TextStyle(
        color:
            Colors.white,
        fontSize:
            10,
      ),
      decoration:
          InputDecoration(
        labelText:
            title,
        labelStyle:
            const TextStyle(
          color:
              Color(0x73FFFFFF),
          fontSize:
              9,
        ),
        filled:
            true,
        fillColor:
            Colors.white.withValues(
          alpha:
              0.035,
        ),
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              BorderSide(
            color:
                Colors.white.withValues(
              alpha:
                  0.07,
            ),
          ),
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          borderSide:
              BorderSide(
            color:
                Colors.white.withValues(
              alpha:
                  0.07,
            ),
          ),
        ),
      ),
      items:
          values.map(
        (item) {
          return DropdownMenuItem<String>(
            value:
                item,
            child:
                Text(
              item,
            ),
          );
        },
      ).toList(),
      onChanged:
          onChanged,
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
              const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
          content:
              Text(message),
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
            BorderRadius.circular(14),
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
                BorderRadius.circular(14),
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
                18,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ENTRANCE
  // ============================================================

  Widget _animated(
    int index,
    Widget child,
  ) {
    return AnimatedBuilder(
      animation:
          entranceController,
      builder:
          (context, child) {
        final delay =
            index * 0.045;

        final value =
            ((entranceController.value -
                        delay) /
                    (1 - delay))
                .clamp(0.0, 1.0);

        return Opacity(
          opacity:
              value,
          child:
              Transform.translate(
            offset:
                Offset(
              0,
              18 * (1 - value),
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
// VEHICLE MODEL
// =================================================================

class Vehicle {
  final String id;
  final String model;
  final String variant;
  final String registration;
  final String year;
  final String fuel;
  final String transmission;
  final String color;
  final String mileage;
  final String insurance;
  final String insuranceExpiry;
  final String serviceDue;
  final bool isPrimary;

  const Vehicle({
    required this.id,
    required this.model,
    required this.variant,
    required this.registration,
    required this.year,
    required this.fuel,
    required this.transmission,
    required this.color,
    required this.mileage,
    required this.insurance,
    required this.insuranceExpiry,
    required this.serviceDue,
    required this.isPrimary,
  });

  Vehicle copyWith({
    String? model,
    String? variant,
    String? registration,
    String? year,
    String? fuel,
    String? transmission,
    String? color,
    String? mileage,
    String? insurance,
    String? insuranceExpiry,
    String? serviceDue,
    bool? isPrimary,
  }) {
    return Vehicle(
      id: id,
      model: model ?? this.model,
      variant: variant ?? this.variant,
      registration:
          registration ?? this.registration,
      year: year ?? this.year,
      fuel: fuel ?? this.fuel,
      transmission:
          transmission ?? this.transmission,
      color: color ?? this.color,
      mileage:
          mileage ?? this.mileage,
      insurance:
          insurance ?? this.insurance,
      insuranceExpiry:
          insuranceExpiry ??
              this.insuranceExpiry,
      serviceDue:
          serviceDue ?? this.serviceDue,
      isPrimary:
          isPrimary ?? this.isPrimary,
    );
  }
}

// =================================================================
// AURORA PAINTER
// =================================================================

class _VehicleAuroraPainter
    extends CustomPainter {
  final double progress;

  _VehicleAuroraPainter({
    required this.progress,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint =
        Paint();

    final t =
        progress *
            math.pi *
            2;

    final cyanCenter =
        Offset(
      size.width *
          (0.18 +
              math.sin(t) *
                  0.12),
      size.height *
          (0.18 +
              math.cos(t) *
                  0.06),
    );

    paint.shader =
        RadialGradient(
      colors: [
        const Color(
          0xFF00E5FF,
        ).withValues(
          alpha:
              0.075,
        ),
        Colors.transparent,
      ],
    ).createShader(
      Rect.fromCircle(
        center:
            cyanCenter,
        radius:
            size.width *
                0.65,
      ),
    );

    canvas.drawRect(
      Offset.zero &
          size,
      paint,
    );

    final purpleCenter =
        Offset(
      size.width *
          (0.82 +
              math.cos(t) *
                  0.10),
      size.height *
          (0.52 +
              math.sin(t) *
                  0.07),
    );

    paint.shader =
        RadialGradient(
      colors: [
        const Color(
          0xFF8C5CFF,
        ).withValues(
          alpha:
              0.065,
        ),
        Colors.transparent,
      ],
    ).createShader(
      Rect.fromCircle(
        center:
            purpleCenter,
        radius:
            size.width *
                0.60,
      ),
    );

    canvas.drawRect(
      Offset.zero &
          size,
      paint,
    );

    final random =
        math.Random(42);

    final starPaint =
        Paint();

    for (int i = 0;
        i < 45;
        i++) {
      final x =
          random.nextDouble() *
              size.width;

      final y =
          random.nextDouble() *
              size.height;

      final opacity =
          0.15 +
              ((math.sin(
                            t + i,
                          ) +
                      1) /
                  2) *
                  0.4;

      starPaint.color =
          Colors.white.withValues(
        alpha:
            opacity,
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
    covariant _VehicleAuroraPainter oldDelegate,
  ) {
    return oldDelegate.progress !=
        progress;
  }
}