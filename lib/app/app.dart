import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../injection.dart';
import 'core/routes/navigate.dart';
import '../flavor/flavor_config.dart';
import 'core/setup/theme/w_theme.dart';
import 'core/setup/localization/localization.dart';
import 'presentation/providers/activity_provider.dart';
import 'presentation/providers/auth/load_provider.dart';
import 'presentation/providers/auth/login_provider.dart';
import 'presentation/providers/auth/logout_provider.dart';
import 'presentation/providers/shop_provider.dart';
import 'presentation/providers/tracking_provider.dart';
import 'presentation/providers/transaction_provider.dart';
import 'presentation/providers/user_provider.dart';

Future<Widget> initializeApp(FlavorConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  return App(config);
}

// global navigator key
final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App(this.config, {super.key});

  final FlavorConfig config;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locator<LoadProvider>()),
        ChangeNotifierProvider(create: (_) => locator<LoginProvider>()),
        ChangeNotifierProvider(create: (_) => locator<UserProvider>()),
        ChangeNotifierProvider(create: (_) => locator<LogoutProvider>()),
        ChangeNotifierProvider(create: (_) => locator<ShopProvider>()),
        ChangeNotifierProvider(create: (_) => locator<TransactionProvider>()),
        ChangeNotifierProvider(create: (_) => locator<TrackingProvider>()),
        ChangeNotifierProvider(create: (_) => locator<ActivityProvider>()),
      ],
      child: ChangeNotifierProvider(
        create: (_) => locator<LoadProvider>(),
        child: MaterialApp(
          title: 'Walk For Wealth',
          theme: WTheme.theme,
          themeMode: WTheme.themeMode,
          navigatorKey: navigatorKey,
          locale: Localization.locale,
          debugShowCheckedModeBanner: false,
          initialRoute: Navigate.initialPage,
          onGenerateRoute: Navigate.onGenerateRoute,
          localizationsDelegates: Localization.delegates,
          supportedLocales: Localization.supportedLocales,
        ),
      ),
    );
  }
}
