import 'package:equatable/equatable.dart';

class SplashScreenState extends Equatable {
  final double size;
  final bool navigateToNext;

  const SplashScreenState({this.size = 0.0, this.navigateToNext = false});

  SplashScreenState copyWith({double? size, bool? navigateToNext}) {
    return SplashScreenState(
      size: size ?? this.size,
      navigateToNext: navigateToNext ?? this.navigateToNext,
    );
  }

  @override
  List<Object?> get props => [size, navigateToNext];
}
