import 'package:equatable/equatable.dart';

abstract class SplashScreenEvent extends Equatable {
  const SplashScreenEvent();

  @override
  List<Object?> get props => [];
}

class StartSplash extends SplashScreenEvent {}
class GoToOnboard extends SplashScreenEvent {}
class GoToCurrentLocationScreen extends SplashScreenEvent {}

