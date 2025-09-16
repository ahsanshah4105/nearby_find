import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/routes/app_routes/app_routes.dart';
import '../bloc/splash_screen_bloc.dart';
import '../bloc/splash_screen_event.dart';
import '../bloc/splash_screen_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = Tween<double>(begin: -100, end: 0).animate(_controller);

    _controller.forward();

    // Start the splash timer in Bloc
    context.read<SplashScreenBloc>().add(StartSplash());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashScreenBloc, SplashScreenState>(
      listener: (context, state) {
        if (state.navigateToNext) {
          Navigator.pushReplacementNamed(context, AppRoutes.currentLocation);
        }
      },
      child: Scaffold(
        body: Center(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animation.value),
                child: SvgPicture.asset(
                  'assets/app_logo/img.svg', // or PNG
                  width: 120,
                  height: 120,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
