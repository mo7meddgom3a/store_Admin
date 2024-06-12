import 'package:equatable/equatable.dart';

// Define a sealed class for SignInState
sealed class SignInState extends Equatable {
  const SignInState();
}

// Define the initial state
class SignInInitial extends SignInState {
  const SignInInitial();

  @override
  List<Object?> get props => [];
}

// State representing that the sign-in process is in progress
class SignInProcess extends SignInState {
  const SignInProcess();

  @override
  List<Object?> get props => [];
}

// State representing that the sign-in process was successful
class SignInSuccess extends SignInState {
  const SignInSuccess();

  @override
  List<Object?> get props => [];
}

// State representing that the sign-in process failed
class SignInFailure extends SignInState {
  final String message;

  const SignInFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
