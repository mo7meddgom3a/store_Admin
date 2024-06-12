import 'package:anwer_shop_admin/screens/store/store_items/cubit/add_store_item_cubit.dart';
import 'package:anwer_shop_admin/screens/store/store_items/cubit/store_cubit.dart';
import 'package:anwer_shop_admin/screens/store/store_items/widgets/custom_check_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/Managers/colors_manager.dart';
import '../widgets/CustomTextField.dart';
import '../widgets/categories_form.dart';

class AddItemsWidget extends StatelessWidget {
  AddItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddStoreItemCubit>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<AddStoreItemCubit, AddStoreItemState>(
        builder: (context, state) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        cubit: cubit,
                        labelText: 'اسم المنتج',
                        controller: cubit.nameController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        cubit: cubit,
                        labelText: 'السعر',
                        keyboardType: TextInputType.number,
                        controller: cubit.priceController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        cubit: cubit,
                        labelText: 'الوصف',
                        controller: cubit.descriptionController,
                      ),
                      const SizedBox(height: 20),
                      CategoriesForm(
                        cubit: StoreCubit(),
                        onChanged: (value) {
                          context.read<AddStoreItemCubit>().categoryValue = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        cubit: cubit,
                        labelText: 'الكمية',
                        keyboardType: TextInputType.number,
                        controller: cubit.productCount,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomCheckBox(
                            title: 'موصى به',
                            onChanged: (value) {
                              context
                                  .read<AddStoreItemCubit>()
                                  .updateToRecommended(documentId: value ?? false);
                            },
                          ),
                          CustomCheckBox(
                            title: 'شائع',
                            onChanged: (value) {
                              context
                                  .read<AddStoreItemCubit>()
                                  .updateToPopular(documentId: value ?? false);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: ColorManager.PrimaryColor,
                        ),
                        onPressed: () {
                          context.read<AddStoreItemCubit>().uploadImages();
                        },
                        child: const Text(
                          'رفع الصورة',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (state.images != null && state.images!.isNotEmpty)
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: state.images!.map((image) {
                            return Image.memory(
                              image,
                              width: 100,
                              height: 100,
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox.shrink();
                              },
                            );
                          }).toList(),
                        ),
                      if (state.submission == Submission.loading)
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.lightGreenAccent,
                        ),
                        onPressed: () {
                          if (cubit.formKey.currentState!.validate()) {
                            cubit.submitForm(context);
                          }
                        },
                        child: const Text(
                          'إضافة المنتج',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
