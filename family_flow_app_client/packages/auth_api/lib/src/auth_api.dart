import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/models.dart';

class RegistrationFailure implements Exception {}

class LoginFailure implements Exception {}

class AuthApiClient {
  AuthApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'http://localhost:8080/api';
  final http.Client _httpClient;

  Future<Token> register(SignUpForm signUpForm) async {
    final registerRequest = Uri.parse('$_baseUrl/auth/register');
    final response = await _httpClient.post(
      registerRequest,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(signUpForm.toJson()),
    );

    if (response.statusCode != 200) {
      throw RegistrationFailure();
    }

    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    return Token.fromJson(responseBody);
  }

  Future<Token> login(SignInForm signInForm) async {
    final loginRequest = Uri.parse('$_baseUrl/auth/login');
    final response = await _httpClient.post(
      loginRequest,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(signInForm.toJson()),
    );

    print("response code: ");
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw LoginFailure();
    }

    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    print("responseBody: ");
    print(responseBody['token']);

    var token = Token.fromJson(responseBody);
    print("token: $token");
    return token;
  }

  Future<void> sendCode(String email) async {
    final sendCodeRequest = Uri.parse('$_baseUrl/email/send');
    final response = await _httpClient.post(
      sendCodeRequest,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send verification code');
    }

    print('Verification code sent to $email');
  }

  Future<bool> compareCode(String email, String code) async {
    final compareCodeRequest = Uri.parse('$_baseUrl/email/compare');
    final response = await _httpClient.post(
      compareCodeRequest,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );

    if (response.statusCode == 200) {
      print('Code comparison successful for $email');
      return true;
    } else if (response.statusCode == 400) {
      print('Invalid verification code for $email');
      return false;
    } else {
      throw Exception('Failed to compare verification code');
    }
  }

  void close() {
    _httpClient.close();
  }
}
