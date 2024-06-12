
import 'package:anwer_shop_admin/auth/auth/welcome_screen.dart';
import 'package:anwer_shop_admin/auth/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:anwer_shop_admin/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:anwer_shop_admin/constants.dart';
import 'package:anwer_shop_admin/controllers/MenuAppController.dart';
import 'package:anwer_shop_admin/cubit/standard_layout/standard_layout_cubit.dart';
import 'package:anwer_shop_admin/firebase_options.dart';
import 'package:anwer_shop_admin/packages/user_repository/lib/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';


import 'screens/main/main_screen.dart';
import 'screens/store/categoris/cubit/categories_cubit.dart';
import 'screens/store/store_items/cubit/store_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(
            userRepository: FirebaseUserRepo(),
          ),
        ),
        BlocProvider(
            create: (context) =>
                SignInBloc(userRepository: FirebaseUserRepo())),
        BlocProvider(create: (context) => StandardLayoutCubit()),

        BlocProvider(create: (context) => StoreCubit()),
        BlocProvider(create: (context) => CategoriesCubit()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuAppController(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop Admin Panel',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: bgColor,
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
                .apply(bodyColor: Colors.white),
            canvasColor: secondaryColor,
          ),
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state.status == AuthenticationStatus.authenticated) {
                return BlocProvider(
                  create: (context) => SignInBloc(
                    userRepository:
                        context.read<AuthenticationBloc>().userRepository,
                  ),
                  child: MainScreen(),
                );
              } else {
                return WelcomeScreen(); // or any other widget for unauthenticated state
              }
            },
          ),
        ),
      ),
    );
  }
}
