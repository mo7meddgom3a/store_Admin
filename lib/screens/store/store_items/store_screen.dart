
import 'package:anwer_shop_admin/resources/Utils/responsive.dart';
import 'package:anwer_shop_admin/screens/dashboard/components/header.dart';
import 'package:anwer_shop_admin/screens/store/store_items/components/add_items_widget.dart';
import 'package:anwer_shop_admin/screens/store/store_items/components/store_items_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants.dart';
import 'cubit/add_store_item_cubit.dart';
import 'cubit/store_cubit.dart';

class StoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AddStoreItemCubit()),
        BlocProvider(create: (context) => StoreCubit()),
      ],
      child: SafeArea(
        child: SingleChildScrollView(
          primary: false,
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(
                title: "Store Items",
              ),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        if (Responsive.isMobile(context))
                          SizedBox(height: defaultPadding),
                        AddItemsWidget(),
                        SizedBox(height: defaultPadding),
                        StoreItemsWidget(),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    SizedBox(width: defaultPadding),
                  // On Mobile means if the screen is less than 850 we don't want to show it
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}