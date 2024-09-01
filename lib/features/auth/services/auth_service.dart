import 'dart:convert';

import 'package:amazon_clone/core/common/widgets/custom_bottom_navigation_bar.dart';
import 'package:amazon_clone/core/constants/error_handling.dart';
import 'package:amazon_clone/core/common/utils/utils.dart';
import 'package:amazon_clone/core/models/user_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:amazon_clone/core/constants/secrets/app_secrets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  /// auth api
  static const apiSignUp = '/api/signup';
  static const apiSignIn = '/api/signin';
  static const apiTokenIsValid = '/tokenIsValid';
  static const apiGetUserData = '/';

  /// This function signes up the user into application.
  void signUp({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = UserModel(
        id: '',
        name: name,
        email: email,
        password: password,
        address: '',
        type: '',
        token: '',
        cart: [],
      );

      final uri = Uri.http(AppSecrets.baseUrl, AuthService.apiSignUp);
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final response = await http.post(
        uri,
        body: jsonEncode(user.toJson()),
        headers: headers,
      );

      if (context.mounted) {
        httpErrorHandle(
          context: context,
          response: response,
          onSuccess: () => showSnackBar(context, 'Account has been created'),
        );
      }

      debugPrint(response.body);
    } catch (e) {
      if (context.mounted) showSnackBar(context, e.toString());

      debugPrint(e.toString());
    }
  }

  /// This function signes in the user into application.
  void signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final body = {
        'email': email,
        'password': password,
      };
      final uri = Uri.http(AppSecrets.baseUrl, AuthService.apiSignIn);
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: headers,
      );

      if (context.mounted) {
        httpErrorHandle(
          context: context,
          response: response,
          onSuccess: () async {
            final prefs = await SharedPreferences.getInstance();

            if (context.mounted) {
              context
                  .read<UserProvider>()
                  .setUser(jsonDecode(response.body) as Map<String, Object?>);

              // debugPrint(response.body);
            }

            // debugPrint(jsonDecode(response.body)['token']);
            prefs.setString('x-auth-token', jsonDecode(response.body)['token']);
            debugPrint(prefs.getString('x-auth-token'));

            if (context.mounted) {
              Navigator.pushReplacementNamed(
                  context, CustomBottomNavigationBar.routeName);
            }
          },
        );
      }

      // debugPrint(response.body);
    } catch (e) {
      if (context.mounted) showSnackBar(context, e.toString());

      debugPrint(e.toString());
    }
  }

  /// Whether the token is valid(exists in the database) or not.
  ///
  /// If the token exists in the database it takes the user associated with this token
  /// and updates the current user.
  void getUserData(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('x-auth-token');
      // debugPrint(token);

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      final uri = Uri.http(AppSecrets.baseUrl, AuthService.apiTokenIsValid);
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token!,
      };

      final response = await http.post(uri, headers: headers);

      final isValidToken = jsonDecode(response.body) as bool;

      if (isValidToken) {
        final uri = Uri.http(AppSecrets.baseUrl, AuthService.apiGetUserData);
        final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        };

        final response = await http.get(uri, headers: headers);
        // debugPrint(response.body);

        if (context.mounted) {
          context
              .read<UserProvider>()
              .setUser(jsonDecode(response.body) as Map<String, Object?>);
        }
      }
    } catch (e) {
      // if (context.mounted) showSnackBar(context, e.toString());

      debugPrint(e.toString());
    }
  }
}
