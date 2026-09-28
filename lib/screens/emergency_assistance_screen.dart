import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/care_background.dart';

class EmergencyAssistanceScreen extends StatefulWidget {
  final int? customerId;

  const EmergencyAssistanceScreen({
    super.key,
    this.customerId,
  });

  @override
  State<EmergencyAssistanceScreen> createState() =>
      _EmergencyAssistanceScreenState();
}

class _EmergencyAssistanceScreenState
    extends State<EmergencyAssistanceScreen> {
  static const String apiUrl =
      'http://192.168.1.7/hyundai_care_plus_api/emergency_assistance.php';

  static const String vehicleApi =
      'http://192.168.1.7/hyundai_care_plus_api/vehicles.php';

  final TextEditingController messageController =
      TextEditingController();

  List<Map<String, dynamic>> vehicles = [];

  int? selectedVehicleId;

  bool isLoading = true;
  bool isRequesting = false;

  @override
  void initState() {
    super.initState();
    loadVehicles();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> loadVehicles() async {
    final id = widget.customerId;

    if (id == null || id <= 0) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      showMessage(
        'Customer information is unavailable.',
      );

      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
          '$vehicleApi?customer_id=$id',
        ),
        headers: const {
          'Accept': 'application/json',
        },
      );

      if (!mounted) return;

      if (response.statusCode != 200) {
        setState(() {
          isLoading = false;
        });

        showMessage(
          'Server error: ${response.statusCode}',
        );

        return;
      }

      if (response.body.trim().isEmpty) {
        setState(() {
          isLoading = false;
        });

        showMessage(
          'Server returned an empty response.',
        );

        return;
      }

      final dynamic decoded = jsonDecode(
        response.body,
      );

      if (decoded is! Map<String, dynamic>) {
        setState(() {
          isLoading = false;
        });

        showMessage(
          'Unexpected server response.',
        );

        return;
      }

      if (decoded['success'] != true) {
        setState(() {
          isLoading = false;
        });

        showMessage(
          decoded['message']?.toString() ??
              'Unable to load vehicles.',
        );

        return;
      }

      final dynamic raw = decoded['vehicles'];

      final loaded = <Map<String, dynamic>>[];

      if (raw is List) {
        for (final item in raw) {
          if (item is Map) {
            loaded.add(
              Map<String, dynamic>.from(item),
            );
          }
        }
      }

      int? firstVehicleId;

      for (final vehicle in loaded) {
        final parsed = int.tryParse(
          vehicle['vehicle_id']?.toString() ?? '',
        );

        if (parsed != null) {
          firstVehicleId = parsed;
          break;
        }
      }

      setState(() {
        vehicles = loaded;
        selectedVehicleId = firstVehicleId;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(
        'EMERGENCY VEHICLE ERROR: $e',
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      showMessage(
        'Unable to connect to server.',
      );
    }
  }

  Future<void> requestAssistance() async {
    final customerId = widget.customerId;

    if (customerId == null || customerId <= 0) {
      showMessage(
        'Customer information is unavailable.',
      );
      return;
    }

    if (selectedVehicleId == null) {
      showMessage(
        'Please select your vehicle.',
      );
      return;
    }

    setState(() {
      isRequesting = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'customer_id': customerId,
          'vehicle_id': selectedVehicleId,
          'message': messageController.text.trim(),
        }),
      );

      if (!mounted) return;

      if (response.body.trim().isEmpty) {
        showMessage(
          'Server returned an empty response.',
        );
        return;
      }

      final dynamic decoded = jsonDecode(
        response.body,
      );

      if (decoded is Map &&
          response.statusCode == 200 &&
          decoded['success'] == true) {
        showSuccessDialog();
      } else {
        showMessage(
          decoded is Map
              ? decoded['message']?.toString() ??
                  'Unable to request assistance.'
              : 'Unable to request assistance.',
        );
      }
    } catch (e) {
      debugPrint(
        'EMERGENCY REQUEST ERROR: $e',
      );

      if (!mounted) return;

      showMessage(
        'Unable to connect to server.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isRequesting = false;
        });
      }
    }
  }

  void showSuccessDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          icon: const Icon(
            Icons.check_circle_rounded,
            color: Colors.green,
            size: 55,
          ),
          title: const Text(
            'Request Received',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF002C5F),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Your roadside assistance request has been received. Please stay with your vehicle and keep your phone available.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              height: 1.4,
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF002C5F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'DONE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text(message),
        ),
      );
  }

  String vehicleLabel(
    Map<String, dynamic> vehicle,
  ) {
    final model =
        vehicle['model']?.toString() ?? 'Hyundai';

    final registration =
        vehicle['registration_number']?.toString() ?? '';

    if (registration.trim().isEmpty) {
      return model;
    }

    return '$model - $registration';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: CareBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        physics:
                            const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          8,
                          20,
                          30,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            _header(),

                            const SizedBox(height: 25),

                            _sectionTitle(
                              'Select Vehicle',
                            ),

                            const SizedBox(height: 10),

                            _buildVehicleSelector(),

                            const SizedBox(height: 23),

                            _sectionTitle(
                              'Describe the Problem',
                            ),

                            const SizedBox(height: 10),

                            _buildMessageField(),

                            const SizedBox(height: 15),

                            _buildSafetyNotice(),

                            const SizedBox(height: 22),

                            _buildRequestButton(),

                            const SizedBox(height: 25),

                            const Center(
                              child: Text(
                                'Hyundai Care+ • Emergency Roadside Assistance',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ),
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

  Widget _buildAppBar() {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).maybePop();
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF002C5F)
                      .withValues(alpha: 0.08),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF002C5F),
                  size: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Text(
              'Emergency Assistance',
              style: TextStyle(
                color: Color(0xFF002C5F),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emergency_rounded,
              color: Colors.red,
              size: 21,
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFE9EC),
            Colors.white.withValues(alpha: 0.92),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emergency_rounded,
              color: Colors.red,
              size: 43,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Emergency Roadside Assistance',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xFF002C5F),
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Get help when you need it.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF002C5F),
      ),
    );
  }

  Widget _buildVehicleSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF002C5F)
              .withValues(alpha: 0.08),
        ),
      ),
      child: DropdownButtonFormField<int>(
        initialValue: selectedVehicleId,
        isExpanded: true,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.directions_car_outlined,
            color: Color(0xFF002C5F),
          ),
          hintText: 'Choose your vehicle',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 15,
          ),
        ),
        items: vehicles
            .map<DropdownMenuItem<int>?>(
          (vehicle) {
            final id = int.tryParse(
              vehicle['vehicle_id']?.toString() ?? '',
            );

            if (id == null) {
              return null;
            }

            return DropdownMenuItem<int>(
              value: id,
              child: Text(
                vehicleLabel(vehicle),
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        )
            .whereType<DropdownMenuItem<int>>()
            .toList(),
        onChanged: vehicles.isEmpty
            ? null
            : (value) {
                setState(() {
                  selectedVehicleId = value;
                });
              },
      ),
    );
  }

  Widget _buildMessageField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF002C5F)
              .withValues(alpha: 0.08),
        ),
      ),
      child: TextField(
        controller: messageController,
        maxLines: 5,
        decoration: const InputDecoration(
          hintText:
              'Example: Vehicle stopped suddenly',
          alignLabelWithHint: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildSafetyNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.10),
        ),
      ),
      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 22,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'For immediate danger or medical emergencies, contact local emergency services.',
              style: TextStyle(
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed:
            isRequesting ? null : requestAssistance,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          disabledBackgroundColor:
              Colors.red.withValues(alpha: 0.45),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        icon: isRequesting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(
                Icons.emergency_rounded,
              ),
        label: Text(
          isRequesting
              ? 'Requesting...'
              : 'Request Assistance',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}