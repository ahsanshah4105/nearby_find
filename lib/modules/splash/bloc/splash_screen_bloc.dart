import 'package:bloc/bloc.dart';
import 'splash_screen_event.dart';
import 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(const SplashScreenState()) {
    on<StartSplash>((event, emit) async {
      await Future.delayed(const Duration(seconds: 2));
      emit(const SplashScreenState(navigateToNext: true));
    });
  }
}
