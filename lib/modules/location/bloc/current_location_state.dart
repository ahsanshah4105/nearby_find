part of 'current_location_bloc.dart';

class CurrentLocationState extends Equatable {
  final double lat;
  final double lon;
  final String? locationName;
  final List<Map<String, dynamic>>? nearbyPlaces;
  final String sos;


  const CurrentLocationState({this.lat = 0.0, this.lon = 0.0, this.locationName, this.nearbyPlaces = const [],this.sos  = '',});

  CurrentLocationState copyWith({
    double? lat,
    double? lon,
    String? locationName,
    List<Map<String, dynamic>>? nearbyPlaces,
    String? sos
  }) {
    return CurrentLocationState(
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      locationName: locationName ?? this.locationName,
      nearbyPlaces: nearbyPlaces ?? this.nearbyPlaces,
      sos: sos ?? this.sos,
    );
  }

  @override
  List<Object?> get props => [lat, lon, locationName, nearbyPlaces, sos];
}
