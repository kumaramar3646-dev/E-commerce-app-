
import 'package:ecommerce_app/ui/cart/cart_bloc.dart';
import 'package:ecommerce_app/ui/dashboard/nav_pages/home_page/bloc/product_bloc.dart';
import 'package:ecommerce_app/ui/dashboard/nav_pages/home_page/order_bloc/order_bloc.dart';
import 'package:ecommerce_app/ui/onboarding/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/helper/api_helper.dart';
import 'domain/constant/app_routes.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBloc(apiHelper: ApiHelper())),
        BlocProvider(create: (context) => ProductBloc(apiHelper: ApiHelper())),
        BlocProvider(create: (context) => CartBloc(apiHelper: ApiHelper())),
        BlocProvider(create: (context) => OrderBloc(apiHelper: ApiHelper())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: AppRoutes.route_splash,
      routes: AppRoutes.mRoutes,
    );
  }
}