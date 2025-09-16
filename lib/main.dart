import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/routes/app_routes/app_pages.dart';
import 'modules/location/bloc/current_location_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'modules/splash/bloc/splash_screen_bloc.dart';
import 'modules/splash/view/splash_screen.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

Future<void> requestPermissions() async {
  await Permission.phone.request();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SplashScreenBloc()),
          BlocProvider(create: (_) => CurrentLocationBloc())

        ],
        child:  MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home:  SplashScreen(),
          routes: AppPages.routes,
        ));
  }
}