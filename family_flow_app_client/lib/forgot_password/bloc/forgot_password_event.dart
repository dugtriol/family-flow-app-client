part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class ForgotPasswordEmailSubmitted extends ForgotPasswordEvent {
  final String email;

  const ForgotPasswordEmailSubmitted(this.email);

  @override
  List<Object> get props => [email];
}

class ForgotPasswordPasswordSubmitted extends ForgotPasswordEvent {
  final String email;
  final String password;

  const ForgotPasswordPasswordSubmitted(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
