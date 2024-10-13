// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import '../../domain/entity/activity.dart';
import '../../domain/entity/product.dart';
import '../../presentation/pages/activity/activity_detail_page.dart';
import '../../presentation/pages/activity/activity_page.dart';
import '../../presentation/pages/activity/activity_save_confirm_page.dart';
import '../../presentation/pages/activity/activity_save_page.dart';
import '../../presentation/pages/activity/all_activities_page.dart';
import '../../presentation/pages/favorite_page.dart';
import '../../presentation/pages/login_page.dart';
import '../../presentation/pages/profile/profile_detail_page.dart';
import '../../presentation/pages/register/register_page.dart';
import '../../presentation/pages/splash_page.dart';
import '../../presentation/pages/main_page.dart';
import '../../presentation/pages/on_boarding/on_boarding_page.dart';
import '../../presentation/pages/product/product_page.dart';
import '../../presentation/pages/transaction/transaction_status_page.dart';
import '../../presentation/pages/transaction/transaction_detail_page.dart';
import '../../presentation/pages/vendor_page.dart';

class To {
  To._();

  static const INIT = '/';
  static const ON_BOARDING = '/on-boarding';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const MAIN = '/main';
  static const ACTIVITY = '/activities';
  static const ACTIVITY_DETAIL = '/activity-detail';
  static const ALL_ACTIVITIES = '/all-activities';
  static const ACTIVITY_SAVE = '/activity-save';
  static const ACTIVITY_SAVE_CONFIRM = '/activity-save-confirm';
  static const PROFIL_DETAIL = '/profile-detail';
  static const PRODUCT = '/product';
  static const VENDOR = '/vendor';
  static const FAVORITE = '/favorite';
  static const TRANSACTION_STATUS = '/transaction-status';
  static const TRANSACTION_DETAIL = '/transaction-detail';
}

enum NavigateStyle { NORMAL, SLIDE }

class Navigate {
  Navigate._();

  static const initialPage = To.INIT;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case To.INIT:
        return _createRoute(const SplashPage());
      case To.ON_BOARDING:
        return _createRoute(const OnBoardingPage());
      case To.LOGIN:
        return _createRoute(const LoginPage());
      case To.REGISTER:
        return _createRoute(const RegisterPage());
      case To.MAIN:
        return _createRoute(const MainPage());
      case To.ACTIVITY:
        return _createRoute(
          const ActivityPage(),
          style: NavigateStyle.SLIDE,
        );
      case To.ACTIVITY_DETAIL:
        final activity = settings.arguments as Activity;
        return _createRoute(ActivityDetailPage(activity));
      case To.ACTIVITY_SAVE:
        return _createRoute(const ActivitySavePage());
      case To.ALL_ACTIVITIES:
        return _createRoute(const AllActivitiesPage());
      case To.ACTIVITY_SAVE_CONFIRM:
        return _createRoute(const ActivitySaveConfirmPage());
      case To.PROFIL_DETAIL:
        return _createRoute(const ProfileDetailPage());
      case To.PRODUCT:
        final data = settings.arguments as Map<String, int>;
        return _createRoute(ProductPage(
          idProduct: data['product_id'] as int,
          idVendor: data['vendor_id'] as int,
        ));
      case To.VENDOR:
        final vendorId = settings.arguments as int;
        return _createRoute(VendorPage(vendorId: vendorId));
      case To.TRANSACTION_STATUS:
        return _createRoute(const TransactionStatusPage());
      case To.FAVORITE:
        return _createRoute(const FavoritePage());
      case To.TRANSACTION_DETAIL:
        final product = settings.arguments as Product;
        return _createRoute(TransactionDetailPage(product: product));
      default:
        return _createRoute(const Scaffold(
          body: Center(
            child: Text(
              'INVALID ROUTE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
    }
  }

  static Route<dynamic> _createRoute(
    Widget page, {
    NavigateStyle style = NavigateStyle.NORMAL,
  }) {
    switch (style) {
      case NavigateStyle.NORMAL:
        return MaterialPageRoute(builder: (context) => page);
      case NavigateStyle.SLIDE:
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => page,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (c, a1, a2, child) {
            var begin = const Offset(0.0, 1.0); // slide dari bawah
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(position: a1.drive(tween), child: child);
          },
        );
    }
  }
}
