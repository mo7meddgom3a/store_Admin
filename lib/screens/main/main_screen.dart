import 'package:anwer_shop_admin/controllers/MenuAppController.dart';
import 'package:anwer_shop_admin/cubit/standard_layout/standard_layout_cubit.dart';
import 'package:anwer_shop_admin/resources/Utils/responsive.dart';
import 'package:anwer_shop_admin/screens/store/categoris/view/categoris_screen.dart';
import 'package:anwer_shop_admin/screens/store/orders_screen/views/orders_screen.dart';
import 'package:anwer_shop_admin/screens/store/store_items/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      // Use endDrawer instead of drawer to make the menu appear from the right
      endDrawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: BlocBuilder<StandardLayoutCubit, StandardLayoutState>(
                  builder: (context, state) {
                    print("state is ${state.runtimeType}");
                    switch (state.runtimeType) {

                      case StoreLayout:
                        return StoreScreen();
                      case Orders:
                        return OrdersScreen();
                      case Categories:
                        return CategoriesScreen();
                    }
                    return StoreScreen();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
