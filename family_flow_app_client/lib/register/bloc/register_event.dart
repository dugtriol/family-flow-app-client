part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterNameChanged extends RegisterEvent {
  const RegisterNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class RegisterEmailChanged extends RegisterEvent {
  const RegisterEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class RegisterPasswordChanged extends RegisterEvent {
  const RegisterPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class RegisterSendCode extends RegisterEvent {}

class RegisterVerifyCode extends RegisterEvent {
  const RegisterVerifyCode(this.code);

  final String code;

  @override
  List<Object> get props => [code];
}

class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted({required this.context});

  final BuildContext context;

  @override
  List<Object?> get props => [context];
}

class RegisterRoleChanged extends RegisterEvent {
  const RegisterRoleChanged(this.isParent);

  final bool isParent;

  @override
  List<Object> get props => [isParent];
}
