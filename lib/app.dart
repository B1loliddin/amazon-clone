import 'package:amazon_clone/core/common/widgets/custom_bottom_navigation_bar.dart';
import 'package:amazon_clone/core/constants/theme/app_theme.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/auth/services/auth_service.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:amazon_clone/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AmazonClone extends StatefulWidget {
  const AmazonClone({super.key});

  @override
  State<AmazonClone> createState() => _AmazonCloneState();
}

class _AmazonCloneState extends State<AmazonClone> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() => _authService.getUserData(context);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amazon Clone',
      onGenerateRoute: generateRoute,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lighTheme,
      home: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // debugPrint(userProvider.user.type);

          return userProvider.user.token.isEmpty
              ? const AuthScreen()
              : userProvider.user.type == 'user'
                  ? const CustomBottomNavigationBar()
                  : const AdminScreen();
        },
      ),
    );
  }
}
