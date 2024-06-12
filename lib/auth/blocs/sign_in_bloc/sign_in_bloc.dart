import 'dart:js';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../packages/user_repository/lib/user_repository.dart';

import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
	final UserRepository _userRepository;

	SignInBloc({
		required UserRepository userRepository,
	}) : _userRepository = userRepository,
				super(SignInInitial()) {
		on<SignInRequired>((event, emit) async {
			emit(SignInProcess());
			try {
				await _userRepository.signIn(event.email, event.password);

				// Retrieve user data from Firestore
				User? user = FirebaseAuth.instance.currentUser;
				if (user != null) {
					// Check if the user has the role of an admin
					DocumentSnapshot userDataSnapshot =
					await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
					Map<String, dynamic> userData =
					userDataSnapshot.data() as Map<String, dynamic>;

					if (userData.containsKey('role') && userData['role'] == 'admin') {
						emit(SignInSuccess());
					} else if (!userData.containsKey('role') && userData['role'] == 'user') {
						context.callMethod('alert', ['You do not have permission to log in.']);
						emit(const SignInFailure(message: 'You do not have permission to log in.'));
						throw Exception('You do not have permission to log in.');
					}
				} else {
					throw Exception('User is null');
				}
			} on FirebaseAuthException catch (e) {
				emit(SignInFailure(message: e.code));
			} catch (e) {
				emit(const SignInFailure(message: 'An unknown error occurred. Please try again.	'));
			}
		});

		on<SignOutRequired>((event, emit) async {
			await _userRepository.logOut();
		});
	}
}
