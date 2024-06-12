
import 'package:anwer_shop_admin/screens/store/categoris/cubit/categories_cubit.dart';
import 'package:anwer_shop_admin/screens/store/categoris/cubit/categories_state.dart';
import 'package:anwer_shop_admin/screens/store/store_items/cubit/store_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesForm extends StatelessWidget {
  final StoreCubit cubit;
  final Function(String?) onChanged;
  final String? value;
  const CategoriesForm({
    Key? key,
    required this.cubit,
    required this.onChanged,
    this.value,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            if (state is CategoriesNamesLoaded) {
              var categories = state.items;
              return DropdownButtonFormField<String>(
                value: null,
                onChanged: (newValue) {
                  onChanged(newValue ?? categories.first);
                },
                items: List<DropdownMenuItem<String>>.generate(
                  categories.length,
                      (index) => DropdownMenuItem(
                    value: categories[index],
                    child: Text(categories[index]),
                  ),
                ),
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}