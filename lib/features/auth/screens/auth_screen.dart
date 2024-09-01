import 'package:amazon_clone/core/common/widgets/custom_button.dart';
import 'package:amazon_clone/core/common/widgets/custom_text_field.dart';
import 'package:amazon_clone/core/constants/theme/global_variables.dart';
import 'package:amazon_clone/core/common/utils/utils.dart';
import 'package:amazon_clone/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

enum Auth { signIn, signUp }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const routeName = '/auth-screen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // keys
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();

  // controllers
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  // services
  final AuthService _authService = AuthService();

  // enums
  Auth _auth = Auth.signUp;

  @override
  void initState() {
    super.initState();
    _initAllControllers();
  }

  @override
  void dispose() {
    _disposeAllControllers();
    super.dispose();
  }

  void _initAllControllers() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  void _disposeAllControllers() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _signUp() {
    if (_signUpFormKey.currentState!.validate()) {
      _authService.signUp(
        context: context,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } else {
      showSnackBar(context, 'Enter all the fields');
    }
  }

  void _signIn() {
    if (_signInFormKey.currentState!.validate()) {
      _authService.signIn(
        context: context,
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } else {
      showSnackBar(context, 'Enter all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// #welcome text
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),

              /// #sign up option
              ListTile(
                selectedTileColor: GlobalVariables.greyBackgroundColor,
                title: const Text(
                  'Create Account',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                leading: Radio(
                  value: Auth.signUp,
                  groupValue: _auth,
                  onChanged: (value) => setState(() => _auth = value!),
                ),
              ),

              /// #sign up option
              if (_auth == Auth.signUp)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _signUpFormKey,
                    child: Column(
                      children: [
                        /// #name text field
                        CustomTextField(
                          controller: _nameController,
                          hintText: 'First and last name',
                        ),
                        const SizedBox(height: 10),

                        /// #email text field
                        CustomTextField(
                          controller: _emailController,
                          hintText: 'Email',
                        ),
                        const SizedBox(height: 10),

                        /// #password text field
                        CustomTextField(
                          controller: _passwordController,
                          hintText: 'Password',
                        ),
                        const SizedBox(height: 20),

                        /// #sign up button
                        CustomButton(
                          text: 'Sign Up',
                          onPressed: _signUp,
                        ),
                      ],
                    ),
                  ),
                ),

              /// #sign in option
              ListTile(
                title: const Text(
                  'Sign In',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                leading: Radio(
                  value: Auth.signIn,
                  groupValue: _auth,
                  onChanged: (value) => setState(() => _auth = value!),
                ),
              ),

              /// #sign in option
              if (_auth == Auth.signIn)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _signInFormKey,
                    child: Column(
                      children: [
                        /// #email text field
                        CustomTextField(
                          controller: _emailController,
                          hintText: 'Email',
                        ),
                        const SizedBox(height: 10),

                        /// #password text field
                        CustomTextField(
                          controller: _passwordController,
                          hintText: 'Password',
                        ),
                        const SizedBox(height: 20),

                        /// #sign up button
                        CustomButton(
                          text: 'Sign In',
                          onPressed: _signIn,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
