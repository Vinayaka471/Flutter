import 'package:flutter/material.dart';
import 'package:ybt_match/services/auth_service.dart';
import 'package:ybt_match/services/locator.dart';
import 'package:ybt_match/widgets/widgets.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _auth = locator<AuthService>();
  final _formKey = GlobalKey<FormState>();

  bool _isLogin = true;
  bool _isLoading = false;
  String _email = '';
  String _password = '';
  String _name = '';

  void _trySubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState?.save();
      setState(() => _isLoading = true);

      try {
        if (_isLogin) {
          await _auth.signInWithEmailAndPassword(_email, _password);
        } else {
          await _auth.signUpWithEmailAndPassword(_name, _email, _password);
        }
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _isLogin ? 'Welcome Back' : 'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 32),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('name'),
                    validator: (value) => (value?.isEmpty ?? true) ? 'Please enter a name.' : null,
                    onSaved: (value) => _name = value ?? '',
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                TextFormField(
                  key: const ValueKey('email'),
                  validator: (value) =>
                      (value?.isEmpty ?? true) || !value!.contains('@') ? 'Please enter a valid email.' : null,
                  onSaved: (value) => _email = value ?? '',
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                ),
                TextFormField(
                  key: const ValueKey('password'),
                  validator: (value) =>
                      (value?.length ?? 0) < 7 ? 'Password must be at least 7 characters long.' : null,
                  onSaved: (value) => _password = value ?? '',
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 24),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  CustomButton(
                    text: _isLogin ? 'Login' : 'Sign Up',
                    onPressed: _trySubmit,
                  ),
                TextButton(
                  child: Text(_isLogin ? 'Create new account' : 'I already have an account'),
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
