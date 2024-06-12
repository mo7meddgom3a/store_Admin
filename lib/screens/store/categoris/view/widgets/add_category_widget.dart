import 'dart:typed_data';

import 'package:anwer_shop_admin/resources/Managers/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/add_categories_cubit.dart';

class AddCategoryItems extends StatelessWidget {
  const AddCategoryItems({Key? key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddCategoriesItemCubit>();
    return BlocBuilder<AddCategoriesItemCubit, AddCategoriesItemState>(
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
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'هذا الحقل مطلوب';
                        }
                        return null;
                      },
                      controller: cubit.CategoryController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'الفئة',
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
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
                        context.read<AddCategoriesItemCubit>().uploadImage();
                      },
                      child: const Text(
                        'تحميل الصورة',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (state.image != null && state.image != Uint8List(0))
                      Image.memory(
                        state.image!,
                        width: 100,
                        height: 100,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox.shrink();
                        },
                      ),
                    if (state.submission == Submission.loading)
                      Center(child: CircularProgressIndicator()),
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
                        'إضافة الفئة',
                        style: TextStyle(
                          color: Colors.black,
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
    );
  }
}
