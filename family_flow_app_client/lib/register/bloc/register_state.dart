part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.status = FormzSubmissionStatus.initial,
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
    this.isCodeSent = false,
    this.isCodeVerified = false,
    this.isRegistered = false, // Новый флаг
    this.isParent = true, // По умолчанию родитель
  });

  final FormzSubmissionStatus status;
  final Name name;
  final Email email;
  final Password password;
  final bool isValid;
  final bool isCodeSent;
  final bool isCodeVerified;
  final bool isRegistered; // Новый флаг
  final bool isParent; // По умолчанию родитель

  RegisterState copyWith({
    FormzSubmissionStatus? status,
    Name? name,
    Email? email,
    Password? password,
    bool? isValid,
    bool? isCodeSent,
    bool? isCodeVerified,
    bool? isRegistered, // Новый флаг
    bool? isParent, // По умолчанию родитель
  }) {
    return RegisterState(
      status: status ?? this.status,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      isCodeSent: isCodeSent ?? this.isCodeSent,
      isCodeVerified: isCodeVerified ?? this.isCodeVerified,
      isRegistered: isRegistered ?? this.isRegistered, // Новый флаг
      isParent: isParent ?? this.isParent, // По умолчанию родитель
    );
  }

  @override
  List<Object> get props => [
    status,
    name,
    email,
    password,
    isValid,
    isCodeSent,
    isCodeVerified,
    isRegistered,
    isParent,
  ];
}
