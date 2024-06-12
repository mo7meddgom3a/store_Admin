
import 'package:anwer_shop_admin/auth/auth/sign_in_screen.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../blocs/authentication_bloc/authentication_bloc.dart';
import '../blocs/sign_in_bloc/sign_in_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
	late TabController tabController;

	@override
  void initState() {
    tabController = TabController(
			initialIndex: 0,
			length: 2, 
			vsync: this
		);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
			backgroundColor: secondaryColor,
			body: SingleChildScrollView(
				child: BlurryContainer(
					borderRadius: BorderRadius.circular(40),
					blur: 10,
					color: secondaryColor.withOpacity(0.5),
					elevation: 0,
				  child:  Column(
				  		mainAxisAlignment: MainAxisAlignment.center,
				  	  children: [
								SizedBox(height: MediaQuery.of(context).size.height / 10,),
				  	    Column(
				  	    										mainAxisAlignment: MainAxisAlignment.center,
				  	    	children: [
				  	    											BlocProvider<SignInBloc>(
				  	    												create: (context) => SignInBloc(
				  	    														userRepository: context.read<AuthenticationBloc>().userRepository
				  	    												),
				  	    												child: const SignInScreen(),
				  	    											),
				  	    	],
				  	    ),
				  	  ],
				  	),
				  ),
				),

		);
  }
}