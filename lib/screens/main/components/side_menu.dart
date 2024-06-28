import 'package:anwer_shop_admin/auth/blocs/sign_in_bloc/sign_in_event.dart';
import 'package:anwer_shop_admin/cubit/standard_layout/standard_layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../auth/blocs/authentication_bloc/authentication_bloc.dart';
import '../../../auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import '../../../constants.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StandardLayoutCubit>();
    return Scaffold(
      backgroundColor: secondaryColor,
      body: ListView(
        children: [
          DrawerHeader(
            child: Image.asset(
              "assets/images/pets.png",
            ),
          ),
          SizedBox(height: 20),
          DrawerListTile(
            title: "المتجر",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              cubit.changeLayout(1);
            },
          ),
          SizedBox(height: 20),
          DrawerListTile(
            title: "الطلبات",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              cubit.changeLayout(2);
            },
          ),
          SizedBox(height: 20),
          DrawerListTile(
            title: "الفئات",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              cubit.changeLayout(3);
            },
          ),
          SizedBox(height: 40),
          Divider(
            color: Colors.white,
            thickness: 1,
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),

              ),
              onPressed: () {
                context.read<SignInBloc>().add(logout());
              },
              child: Text(
                "تسجيل الخروج",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
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
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
        height: 20,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
