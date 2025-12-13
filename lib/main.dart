import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'screens/intro/intro_screen.dart';
import 'screens/user_select/user_select_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set fullscreen mode and hide system UI
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Lock orientation to landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const PS5UIApp());
}

// GoRouter configuration
final GoRouter _router = GoRouter(
  initialLocation: IntroScreen.routePath,
  routes: [
    GoRoute(
      path: IntroScreen.routePath,
      name: IntroScreen.routeName,
      builder: (context, state) => const IntroScreen(),
    ),
    GoRoute(
      path: UserSelectScreen.routePath,
      name: UserSelectScreen.routeName,
      builder: (context, state) => const UserSelectScreen(),
    ),
    GoRoute(
      path: DashboardScreen.routePath,
      name: DashboardScreen.routeName,
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);

class PS5UIApp extends StatelessWidget {
  const PS5UIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      title: 'MMMC Portfolio PS5',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: _router.routeInformationProvider,
    );
  }
}
