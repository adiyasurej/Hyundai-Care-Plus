import 'package:flutter/material.dart';

import '../screens/about_legal_screen.dart';
import '../screens/add_vehicle_screen.dart';
import '../screens/emergency_assistance_screen.dart';
import '../screens/help_support_screen.dart';
import '../screens/insurance_documents_screen.dart';
import '../screens/maintenance_reminders_screen.dart';
import '../screens/maintenance_schedule_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/payment_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/rewards_screen.dart';
import '../screens/roadside_assistance_screen.dart';
import '../screens/service_booking_screen.dart';
import '../screens/service_centres_screen.dart';
import '../screens/service_history_screen.dart';
import '../screens/service_status_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/vehicle_health_screen.dart';
import '../screens/vehicle_management_screen.dart';
import '../screens/vehicle_tracking_screen.dart';
import '../screens/vehicles_screen.dart';
import '../screens/warranty_screen.dart';

class CareRoutes {
  static const String about = '/about';
  static const String addVehicle = '/add-vehicle';
  static const String emergency = '/emergency';
  static const String help = '/help';
  static const String documents = '/documents';
  static const String maintenanceReminders =
      '/maintenance-reminders';
  static const String maintenanceSchedule =
      '/maintenance-schedule';
  static const String notifications = '/notifications';
  static const String payments = '/payments';
  static const String profile = '/profile';
  static const String rewards = '/rewards';
  static const String roadside = '/roadside';
  static const String serviceBooking = '/service-booking';
  static const String serviceCentres = '/service-centres';
  static const String serviceHistory = '/service-history';
  static const String serviceStatus = '/service-status';
  static const String settings = '/settings';
  static const String vehicleHealth = '/vehicle-health';
  static const String vehicleManagement =
      '/vehicle-management';
  static const String vehicleTracking = '/vehicle-tracking';
  static const String vehicles = '/vehicles';
  static const String warranty = '/warranty';

  static Route<dynamic> generateRoute(
    RouteSettings routeSettings,
  ) {
    final int customerId =
        _customerId(routeSettings.arguments);

    switch (routeSettings.name) {
      case about:
        return _page(const AboutLegalScreen());

      case addVehicle:
        return _page(
          AddVehicleScreen(
            customerId: customerId,
          ),
        );

      case emergency:
        return _page(
          EmergencyAssistanceScreen(
            customerId: customerId,
          ),
        );

      case help:
        return _page(const HelpSupportScreen());

      case documents:
        return _page(
          const InsuranceDocumentsScreen(),
        );

      case maintenanceReminders:
        return _page(
          const MaintenanceRemindersScreen(),
        );

      case maintenanceSchedule:
        return _page(
          const MaintenanceScheduleScreen(),
        );

      case notifications:
        return _page(
          const NotificationScreen(),
        );

      case payments:
        return _page(
          PaymentScreen(
            customerId: customerId,
          ),
        );

      case profile:
        return _page(
          ProfileScreen(
            customerId: customerId,
          ),
        );

      case rewards:
        return _page(
          RewardsScreen(
            customerId: customerId,
          ),
        );

      case roadside:
        return _page(
          const RoadsideAssistanceScreen(),
        );

      case serviceBooking:
        return _page(
          const ServiceBookingScreen(),
        );

      case serviceCentres:
        return _page(
          const ServiceCentresScreen(),
        );

      case serviceHistory:
        return _page(
          ServiceHistoryScreen(
            customerId: customerId,
          ),
        );

      case serviceStatus:
        return _page(
          ServiceStatusScreen(
            customerId: customerId,
          ),
        );

      case settings:
        return _page(
          const SettingsScreen(),
        );

      case vehicleHealth:
        return _page(
          const VehicleHealthScreen(),
        );

      case vehicleManagement:
        return _page(
          const VehicleManagementScreen(),
        );

      case vehicleTracking:
        return _page(
          const VehicleTrackingScreen(),
        );

      case vehicles:
        return _page(
          VehiclesScreen(
            customerId: customerId,
          ),
        );

      case warranty:
        return _page(
          const WarrantyScreen(),
        );

      default:
        return _error(
          'The requested page could not be found.',
        );
    }
  }

  static int _customerId(Object? arguments) {
    if (arguments is int && arguments > 0) {
      return arguments;
    }

    if (arguments is Map) {
      final value = arguments['customerId'];

      if (value is int && value > 0) {
        return value;
      }

      if (value is String) {
        final parsed = int.tryParse(value);

        if (parsed != null && parsed > 0) {
          return parsed;
        }
      }
    }

    // Safe fallback for screens that require an ID.
    // The actual logged-in customer ID should be passed
    // through route arguments when available.
    return 0;
  }

  static MaterialPageRoute<dynamic> _page(
    Widget screen,
  ) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => screen,
    );
  }

  static MaterialPageRoute<dynamic> _error(
    String message,
  ) {
    return _page(
      RouteErrorScreen(
        message: message,
      ),
    );
  }
}

class RouteErrorScreen extends StatelessWidget {
  final String message;

  const RouteErrorScreen({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      appBar: AppBar(
        title: const Text(
          'Hyundai Care+',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF07152C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFFF647C),
                size: 58,
              ),
              const SizedBox(height: 18),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF147DFF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'GO BACK',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}