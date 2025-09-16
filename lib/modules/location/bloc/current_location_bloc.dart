import 'package:another_telephony/telephony.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/utils/enums/emergency_categories.dart';
import '../repository/location_repository.dart';
part 'current_location_event.dart';
part 'current_location_state.dart';

class CurrentLocationBloc
    extends Bloc<CurrentLocationEvent, CurrentLocationState> {
  CurrentLocationBloc() : super(CurrentLocationState()) {
    on<GetCurrentLocation>(_getCurrentLocation);
    on<GetCurrentLocationName>(_getLocationName);
    on<GetNearbyPlaces>(_getNearbyPlaces);
    on<SendAlertMessage>(_sendSOSMessage);
  }
  final Telephony telephony = Telephony.instance;
  late final lat;
  late final lon;

  Future<void> _getCurrentLocation(
    GetCurrentLocation event,
    Emitter<CurrentLocationState> emit,
  ) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    emit(
      state.copyWith(
        lat: currentPosition.latitude,
        lon: currentPosition.longitude,
      ),
    );
    add(GetCurrentLocationName());
  }

  Future<void> _getLocationName(
    GetCurrentLocationName event,
    Emitter<CurrentLocationState> emit,
  ) async {
    try {
      lat = state.lat;
      lon = state.lon;

      if (lat == null || lon == null) return;

      final placemarks = await placemarkFromCoordinates(lat, lon);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = [
          place.street,
          place.subLocality,
          place.locality,
          place.country,
        ];

        final filteredParts = parts
            .where((e) => e != null && e.isNotEmpty && !e.contains('+'))
            .toList();

        emit(state.copyWith(locationName: filteredParts.join(', ')));
      }
    } catch (e) {
      print("Error getting location name: $e");
    }
  }

  Future<void> _getNearbyPlaces(
    GetNearbyPlaces event,
    Emitter<CurrentLocationState> emit,
  ) async {
    if (lat == null || lon == null) return;

    try {
      final results = await LocationRepository().fetchNearbyPlaces(
        lat: lat,
        lon: lon,
        category: event.category,
      );

      emit(state.copyWith(nearbyPlaces: results));
    } catch (e) {
      print("Error fetching nearby places: $e");
    }
  }

  Future<Map<String, String>> getLocationDetails() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    String address =
        "${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].country}";

    return {
      "lat": position.latitude.toString(),
      "lng": position.longitude.toString(),
      "address": address,
    };
  }

  Future<void> _sendSOSMessage(
    SendAlertMessage event,
    Emitter<CurrentLocationState> emit,
  ) async {
    final location = await getLocationDetails();
    final message =
        "SOS Alert!\nLocation: ${location["address"]}\nCoordinates: ${location["lat"]}, ${location["lng"]}\nhttps://maps.google.com/?q=${location["lat"]},${location["lng"]}";

    await sendSOSDirect(event.phoneNumber, message);
  }

  Future<void> sendSOSDirect(String phoneNumber, String message) async {
    final bool? permissionsGranted = await telephony.requestSmsPermissions;
    if (permissionsGranted ?? false) {
      telephony.sendSms(to: phoneNumber, message: message);
      debugPrint(
        "SMS sent successfully to $phoneNumber and message is $message",
      );
    } else {
      debugPrint("SMS permission not granted");
    }
  }
}
