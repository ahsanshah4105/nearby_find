import '../../../core/network/api_service.dart';
import '../../../core/utils/api_url.dart';
import '../../../core/utils/enums/emergency_categories.dart';

class LocationRepository {
  Future<List<Map<String, dynamic>>> fetchNearbyPlaces({
    required double lat,
    required double lon,
    required EmergencyCategories category,
  }) async {
    final url =
        "${ApiUrl.googleMapUrl}+ ${lat.toString()} + ',' +${lon.toString()}  + '&radius=' + 2000 + '&key=' + ${ApiUrl.googleMapApiKey}";
    final response = await ApiService.networkClient.post(url);

    final results = (response["results"] as List).cast<Map<String, dynamic>>();
    return results;
  }
}