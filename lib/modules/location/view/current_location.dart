import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nearby_finder_app/core/utils/extension_functions/emergency_category_extension.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/enums/emergency_categories.dart';
import '../bloc/current_location_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  final Completer<GoogleMapController> _controller = Completer();
  final Map<EmergencyCategories, TextEditingController> _controllers = {
    for (var field in EmergencyCategories.values)
      field: TextEditingController(),
  };
  @override
  void initState() {
    super.initState();
    context.read<CurrentLocationBloc>().add(GetCurrentLocation());
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 120),
            BlocBuilder<CurrentLocationBloc, CurrentLocationState>(
              builder: (context, state) {
                if (state.locationName == null || state.locationName!.isEmpty) {
                  return const Text(
                    'Make sure Your Internet is Connected',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  );
                } else {
                  return Text(
                    state.locationName!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
              },
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     showDialog(
            //         context: context,
            //         barrierDismissible: false,
            //         builder: (context) => Center(child: CircularProgressIndicator(),));
            //     context.read<CurrentLocationBloc>().add(
            //       SendAlertMessage(
            //         "+923181110017",
            //       ),
            //     );
            //     Navigation.of(context).pop();
            //     },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.red,
            //     shape: const CircleBorder(),
            //     padding: const EdgeInsets.all(20),
            //   ),
            //   child: Icon(
            //     Icons.sos_rounded,
            //     size: 32,
            //     color: AppColors.white,
            //   ),
            // ),
            ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false, // prevent dismissing while loading
                  builder: (context) => Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                    context.read<CurrentLocationBloc>().add(
                      SendAlertMessage(
                        "+923181110017",
                      ),
                    );
                Navigator.of(context).pop();
              },
              child: Icon(Icons.sos_outlined,color: AppColors.error,),
            ),
            SizedBox(height: 40),
            Container(
              height: 500,
              child: BlocBuilder<CurrentLocationBloc, CurrentLocationState>(
                builder: (context, state) {
                  if (state.lat == 0.0 && state.lon == 0.0) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final LatLng currentLatLng = LatLng(state.lat, state.lon);
                  final markers = <Marker>{
                    Marker(
                      markerId: const MarkerId('current_location'),
                      position: currentLatLng,
                      infoWindow: InfoWindow(
                        title: state.locationName ?? "Your Current Location",
                      ),
                    ),
                  };

                  for (var place in state.nearbyPlaces ?? []) {
                    final destLat = place["geometry"]["location"]["lat"];
                    final destLng = place["geometry"]["location"]["lng"];
                    final name = place["name"];

                    markers.add(
                      Marker(
                        markerId: MarkerId(name),
                        position: LatLng(destLat, destLng),
                        infoWindow: InfoWindow(title: name),
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                      ),
                    );
                  }
                  return SafeArea(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: currentLatLng,
                        zoom: 15,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      markers: markers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: MapType.normal,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 80,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: EmergencyCategories.values.map((field) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 150,
                        child: GestureDetector(
                          onTap: () {
                            context.read<CurrentLocationBloc>().add(GetNearbyPlaces(field));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              field.displayCategories,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        )

                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
