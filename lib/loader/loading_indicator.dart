import 'package:anwer_shop_admin/constants.dart';
import 'package:flutter/material.dart';

import 'spining_lines_loader.dart';

Widget loadingIndicator({Color? color}){
  return Center(
    child: SpinningLinesLoader(
      color: color ?? primaryColor,
      duration: const Duration(milliseconds: 3000),
      itemCount: 3,
      size: 50,
      lineWidth: 2,
    ),
  );
}