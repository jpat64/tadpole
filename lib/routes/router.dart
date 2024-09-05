import 'package:go_router/go_router.dart';
import 'package:moonbase/screens/CalendarScreen.dart';
import 'package:moonbase/screens/EntryScreen.dart';
import 'package:moonbase/screens/InitializationScreen.dart';
import 'package:moonbase/screens/PasswordEntryScreen.dart';
import 'package:moonbase/screens/SettingsScreen.dart';
import 'package:moonbase/screens/WelcomeSequenceScreen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: InitializationScreen.path,
      name: InitializationScreen.name,
      builder: (context, state) => const InitializationScreen(),
    ),
    GoRoute(
        path: "${CalendarScreen.name}/:epochDate",
        name: CalendarScreen.name,
        builder: (context, state) => CalendarScreen(
            epochDate: int.parse(state.pathParameters['epochDate']!))),
    GoRoute(
      path: "${EntryScreen.name}/:epochDate",
      name: EntryScreen.name,
      builder: (context, state) =>
          EntryScreen(epochDate: int.parse(state.pathParameters['epochDate']!)),
    ),
    GoRoute(
      path: SettingsScreen.name,
      name: SettingsScreen.name,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: WelcomeSequenceScreen.name,
      name: WelcomeSequenceScreen.name,
      builder: (context, state) => const WelcomeSequenceScreen(),
    ),
    GoRoute(
      path: "${PasswordEntryScreen.name}/:unlock",
      name: PasswordEntryScreen.name,
      builder: (context, state) =>
          PasswordEntryScreen(unlock: state.pathParameters['unlock']!),
    ),
  ],
);
