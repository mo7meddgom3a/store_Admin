import 'package:equatable/equatable.dart';

// Define a sealed class for SignInEvent
sealed class SignInEvent extends Equatable {
	const SignInEvent();

	@override
	List<Object> get props => [];
}

// Event to trigger sign-in with email and password
class SignInRequired extends SignInEvent {
	final String email;
	final String password;

	const SignInRequired(this.email, this.password);

	@override
	List<Object> get props => [email, password];
}

// Event to trigger sign-out
class SignOutRequired extends SignInEvent {
	const SignOutRequired();

	@override
	List<Object> get props => [];
}
