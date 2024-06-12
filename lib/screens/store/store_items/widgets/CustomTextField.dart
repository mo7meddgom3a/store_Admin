import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../cubit/add_store_item_cubit.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.cubit,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    required this.controller,
    this.inputFormatters,
  });

  final String labelText;
  final AddStoreItemCubit cubit;

  TextEditingController? controller;
  TextInputType? keyboardType;

  List<TextInputFormatter>? inputFormatters = [];

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'this field is required';
        }
        return null;
      },
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: labelText,
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
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,

    );
  }
}