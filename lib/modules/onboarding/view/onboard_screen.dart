import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/utils/app_colors.dart';
import '../../location/bloc/current_location_bloc.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CurrentLocationBloc>().add(GetCurrentLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Current Location"),
        backgroundColor: AppColors.black,
      ),
    );
  }
}
