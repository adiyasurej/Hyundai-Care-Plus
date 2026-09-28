import 'package:flutter/material.dart';

import '../screens/about_legal_screen.dart';
import '../screens/add_vehicle_screen.dart';
import '../screens/emergency_assistance_screen.dart';
import '../screens/help_support_screen.dart';
import '../screens/insurance_documents_screen.dart';
import '../screens/maintenance_reminders_screen.dart';
import '../screens/maintenance_schedule_screen.dart';
import '../screens/notification_screen.dart';
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

class CareNavigation {
  static void _open(
    BuildContext context,
    Widget screen,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => screen,
      ),
    );
  }

  static void serviceBooking(
    BuildContext context,
  ) {
    _open(
      context,
      const ServiceBookingScreen(),
    );
  }

  static void serviceStatus(
    BuildContext context,
    int customerId,
  ) {
    _open(
      context,
      ServiceStatusScreen(
        customerId: customerId,
      ),
    );
  }

  static void serviceHistory(
    BuildContext context,
    int customerId,
  ) {
    _open(
      context,
      ServiceHistoryScreen(
        customerId: customerId,
      ),
    );
  }

  static void warranty(
    BuildContext context,
  ) {
    _open(
      context,
      const WarrantyScreen(),
    );
  }

  static void emergency(
    BuildContext context,
    int customerId,
  ) {
    _open(
      context,
      EmergencyAssistanceScreen(
        customerId: customerId,
      ),
    );
  }

  static void roadside(
    BuildContext context,
  ) {
    _open(
      context,
      const RoadsideAssistanceScreen(),
    );
  }

  static void notifications(
    BuildContext context,
  ) {
    _open(
      context,
      const NotificationScreen(),
    );
  }

  static void vehicles(
    BuildContext context,
    int customerId,
  ) {
    _open(
      context,
      VehiclesScreen(
        customerId: customerId,
      ),
    );
  }

  static void addVehicle(
    BuildContext context,
    int customerId,
  ) {
    _open(
      context,
      AddVehicleScreen(
        customerId: customerId,
      ),
    );
  }

  static void vehicleManagement(
    BuildContext context,
  ) {
    _open(
      context,
      const VehicleManagementScreen(),
    );
  }

  static void vehicleHealth(
    BuildContext context,
  ) {
    _open(
      context,
      const VehicleHealthScreen(),
    );
  }

  static void vehicleTracking(
    BuildContext context,
  ) {
    _open(
      context,
      const VehicleTrackingScreen(),
    );
  }

  static void maintenanceReminders(
    BuildContext context,
  ) {
    _open(
      context,
      const MaintenanceRemindersScreen(),
    );
  }

  static void maintenanceSchedule(
    BuildContext context,
  ) {
    _open(
      context,
      const MaintenanceScheduleScreen(),
    );
  }

  static void rewards(
    BuildContext context,
    int customerId,
  ) {
    _open(
      context,
      RewardsScreen(
        customerId: customerId,
      ),
    );
  }

  static void serviceCentres(
    BuildContext context,
  ) {
    _open(
      context,
      const ServiceCentresScreen(),
    );
  }

  static void documents(
    BuildContext context,
  ) {
    _open(
      context,
      const InsuranceDocumentsScreen(),
    );
  }

  static void profile(
    BuildContext context,
    int customerId,
  ) {
    _open(
      context,
      ProfileScreen(
        customerId: customerId,
      ),
    );
  }

  static void settings(
    BuildContext context,
  ) {
    _open(
      context,
      const SettingsScreen(),
    );
  }

  static void help(
    BuildContext context,
  ) {
    _open(
      context,
      const HelpSupportScreen(),
    );
  }

  static void about(
    BuildContext context,
  ) {
    _open(
      context,
      const AboutLegalScreen(),
    );
  }
}