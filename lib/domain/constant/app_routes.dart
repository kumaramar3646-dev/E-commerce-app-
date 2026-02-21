import 'package:ecommerce_app/ui/dashboard/nav_pages/cart_page.dart';
import 'package:flutter/cupertino.dart';

import '../../ui/dashboard/dashboard_page.dart';
import '../../ui/onboarding/login_page.dart';
import '../../ui/onboarding/sign_up_page.dart';
import '../../ui/product_details/product_details_page.dart';
import '../../ui/splash/splash_page.dart';

class AppRoutes{
  static final String route_splash = "/";
  static final String route_login = "/login";
  static final String route_sign_up = "/sign_up";
  static final String route_dashboard = "/dashboard";
  static final String route_detail_page = "/detail_page";
  static final String route_cart_page = "/cart_page";

  static Map<String, WidgetBuilder> mRoutes = {
    route_splash: (context) => SplashPage(),
    route_login: (context) => LoginPage(),
    route_sign_up: (context) => SignUpPage(),
    route_dashboard: (context) => DashBoardPage(),
    route_detail_page: (context) => ProductDetailPage(),
    route_cart_page: (context) => CartPage(),
  };


}