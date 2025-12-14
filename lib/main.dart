import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'screens/intro/intro_screen.dart';
import 'screens/user_select/user_select_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'widgets/ambient_background_shell.dart';
import 'utils/url_strategy.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set fullscreen mode and hide system UI
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  setPathUrlStrategy();
  // Allow all orientations for responsive design
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const PS5UIApp());
}

// GoRouter configuration
final GoRouter _router = GoRouter(
  initialLocation: IntroScreen.routePath,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AmbientBackgroundShell(
          child: KeyedSubtree(
            key: ValueKey(state.uri.toString()),
            child: child,
          ),
        );
      },
      routes: [
        GoRoute(
          path: IntroScreen.routePath,
          name: IntroScreen.routeName,
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const IntroScreen(),
          ),
        ),
        GoRoute(
          path: UserSelectScreen.routePath,
          name: UserSelectScreen.routeName,
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const UserSelectScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: DashboardScreen.routePath,
      name: DashboardScreen.routeName,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 650),
        reverseTransitionDuration: const Duration(milliseconds: 650),
        child: const DashboardScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
            reverseCurve: Curves.easeInOutCubic,
          );

          return FadeTransition(
            opacity: curvedAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.02),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            ),
          );
        },
      ),
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
        fontFamily: 'SST',
        useMaterial3: true,
      ),
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: _router.routeInformationProvider,
    );
  }
}
