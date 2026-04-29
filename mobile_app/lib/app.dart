// lib/app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'config/routes.dart';

// Global Providers
import 'src/modules/auth/providers/auth_provider.dart';
import 'src/providers/user_provider.dart';
import 'src/providers/location_provider.dart';
import 'src/providers/job_provider.dart';
import 'src/providers/locale_provider.dart';

// Feature Providers
import 'src/modules/ride/providers/ride_provider.dart';
import 'src/modules/booking/providers/booking_provider.dart';
import 'src/modules/nurses/providers/nurse_provider.dart';
import 'src/modules/mechanics/providers/roadside_provider.dart';
import 'src/modules/wallet/providers/wallet_provider.dart';
import 'src/modules/provider_panel/providers/provider_panel_provider.dart';

class SuperApp extends StatelessWidget {
  const SuperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Global state
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),

        // Feature state
        ChangeNotifierProvider(create: (_) => RideProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => NurseProvider()),
        ChangeNotifierProvider(create: (_) => RoadsideProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => ProviderPanelProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'SUPERAPP Pakistan',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark,
            locale: localeProvider.locale,
            supportedLocales: const [Locale('en'), Locale('ur')],
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
