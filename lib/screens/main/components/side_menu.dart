import 'package:anwer_shop_admin/cubit/standard_layout/standard_layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StandardLayoutCubit>();
    return Drawer(
      backgroundColor: bgColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset(
              "assets/images/logo.png",
              color: Colors.grey,
            ),
          ),
          DrawerListTile(
            title: "Store",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              cubit.changeLayout(1);
            },
          ),
          DrawerListTile(
            title: "Orders",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              cubit.changeLayout(2);
            },
          ),
          DrawerListTile(
            title: "Categories",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              cubit.changeLayout(3);
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
