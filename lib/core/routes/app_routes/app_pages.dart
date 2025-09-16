import 'package:flutter/material.dart';
import '../../../modules/location/view/current_location.dart';
import '../../../modules/onboarding/view/onboard_screen.dart';
import 'app_routes.dart';

class AppPages {
  static Map<String, WidgetBuilder> routes = {
    AppRoutes.onBoard: (context) => const OnboardScreen(),
    AppRoutes.currentLocation: (context) => const CurrentLocation()
  };
}
