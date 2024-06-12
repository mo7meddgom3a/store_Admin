import 'package:anwer_shop_admin/screens/dashboard/components/header.dart';
import 'package:anwer_shop_admin/screens/store/categoris/view/widgets/store_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants.dart';
import '../../../../responsive.dart';
import '../cubit/add_categories_cubit.dart';
import '../cubit/categories_cubit.dart';
import 'widgets/add_category_widget.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AddCategoriesItemCubit()),
        BlocProvider(create: (context) => CategoriesCubit()),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            primary: false,
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(
                  title: "الفئات",
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
                          AddCategoryItems(),
                          SizedBox(height: defaultPadding),
                          StoreCategoryItems(),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      SizedBox(width: defaultPadding),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
