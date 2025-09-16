part of 'current_location_bloc.dart';

abstract class CurrentLocationEvent extends Equatable{
  const CurrentLocationEvent();

  @override
  List<Object?> get props => [];
}

class GetCurrentLocation extends CurrentLocationEvent{}
class GetCurrentLocationName extends CurrentLocationEvent{}
class GetNearbyPlaces extends CurrentLocationEvent {
  final EmergencyCategories category;

  GetNearbyPlaces(this.category);

  @override
  List<Object> get props => [category];
}
class SendAlertMessage extends CurrentLocationEvent {
  final String phoneNumber;

  SendAlertMessage(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}
