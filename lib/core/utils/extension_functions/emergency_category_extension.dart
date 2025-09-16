import '../enums/emergency_categories.dart';

extension EmergencyCategoryExtension on EmergencyCategories {
  String get googleType {
    switch (this) {
      case EmergencyCategories.Hospitals:
        return "hospital";
      case EmergencyCategories.Pharmacies:
        return "pharmacy";
      case EmergencyCategories.Police_Stations:
        return "police";
      case EmergencyCategories.Fire_Stations:
        return "fire_station";
      case EmergencyCategories.Gas_Stations:
        return "gas_station";
      case EmergencyCategories.Clinics:
        return "doctor"; // or "clinic" if supported
    }
  }

  String get displayCategories {
    return name.replaceAll("_", " ");
  }
}
