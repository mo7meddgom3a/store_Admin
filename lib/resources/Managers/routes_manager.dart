// ignore_for_file: prefer_const_constructors

import 'package:anwer_shop_admin/controllers/MenuAppController.dart';
import 'package:anwer_shop_admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Routes {
  static const String splashRoute = '/';
  static const String homeRoute = '/home';
  static const String storeRoute = '/store';
  static const String ordersRoute = '/orders';

  static const String  categoriesRoute = '/categories';

}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeRoute:
        {
          return MaterialPageRoute(
            builder: (_) => SafeArea(
              child: MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => MenuAppController(),
                  ),
                ],
                child: MainScreen(),
              ),
            ),
          );
        }
      case Routes.storeRoute:
        {
          return MaterialPageRoute(
            builder: (_) => SafeArea(
              child: MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => MenuAppController(),
                  ),
                ],
                child: MainScreen(),
              ),
            ),
          );
        }
      case Routes.ordersRoute:
        {
          return MaterialPageRoute(
            builder: (_) => SafeArea(
              child: MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => MenuAppController(),
                  ),
                ],
                child: MainScreen(),
              ),
            ),
          );
        }
      case Routes.categoriesRoute:
        {
          return MaterialPageRoute(
            builder: (_) => SafeArea(
              child: MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => MenuAppController(),
                  ),
                ],
                child: MainScreen(),
              ),
            ),
          );
        }

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text("NOT FOUND"),
        ),
        body: Text("NOT FOUND"),
      ),
    );
  }
}
