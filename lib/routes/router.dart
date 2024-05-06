import 'package:go_router/go_router.dart';
import 'package:moonbase/screens/CalendarScreen.dart';
import 'package:moonbase/screens/InitializationScreen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: InitializationScreen.path,
      name: InitializationScreen.name,
      builder: (context, state) => const InitializationScreen(),
    ),
    GoRoute(
      path: "${CalendarScreen.name}/:dateTimeString",
      name: CalendarScreen.name,
      builder: (context, state) => CalendarScreen(
          dateTimeString: state.pathParameters['dateTimeString'] as String),
    )
  ],
);
