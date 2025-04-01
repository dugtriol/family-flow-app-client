import 'dart:async';
import 'package:auth_api/auth_api.dart';
import 'package:authentication_repository/src/jwt_token.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  AuthenticationRepository({AuthApiClient? authApiClient})
      : _authApiClient = authApiClient ?? AuthApiClient();

  final AuthApiClient _authApiClient;
  final _controller = StreamController<AuthenticationStatus>();

  String? _jwtToken;

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    final token = await getJwtToken();
    print("token: $token");
    if (token != null) {
      _jwtToken = token;
      yield AuthenticationStatus.authenticated;
    } else {
      yield AuthenticationStatus.unauthenticated;
    }
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final signInForm = SignInForm(email: email, password: password);
      print("login\n");
      final token = await _authApiClient.login(signInForm);
      print('token: $token');
      _jwtToken = token.jwt;
      print("save token\n");
      await saveJwtToken(_jwtToken!);
      print("save token done\n");
      print("AuthenticationStatus.authenticated\n");
      _controller.add(AuthenticationStatus.authenticated);
    } catch (_) {
      throw LoginFailure();
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final signUpForm = SignUpForm(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      final token = await _authApiClient.register(signUpForm);
      _jwtToken = token.jwt;

      await saveJwtToken(_jwtToken!);

      _controller.add(AuthenticationStatus.authenticated);
    } catch (_) {
      throw RegistrationFailure();
    }
  }

  void logOut() async {
    _jwtToken = null;
    await removeJwtToken();

    _controller.add(AuthenticationStatus.unauthenticated);
  }

  Future<void> sendVerificationCode(String email) async {
    try {
      await _authApiClient.sendCode(email);
    } catch (_) {
      throw Exception('Failed to send verification code');
    }
  }

  Future<bool> verifyCode(String email, String code) async {
    try {
      return await _authApiClient.compareCode(email, code);
    } catch (_) {
      throw Exception('Failed to verify code');
    }
  }

  void dispose() => _controller.close();
}
