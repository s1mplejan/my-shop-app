import 'package:flutter/material.dart';
import 'package:mening_dokonim/providers/auth.dart';
import 'package:mening_dokonim/screens/home_screen.dart';
import 'package:mening_dokonim/servises/http_exception.dart';
import 'package:provider/provider.dart';

enum AuthMode {
  Register,
  Login,
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const roureName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _loading = false;
  AuthMode _authMode = AuthMode.Login;
  final _passwordController = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  Future<void> _submit() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      setState(() {
        _loading = true;
      });

      try {
        if (_authMode == AuthMode.Login) {
          ////tizimga kirish
          await Provider.of<Auth>(context, listen: false).login(
            _authData['email']!,
            _authData['password']!,
          );
        } else {
          //////ro'yxatdan o'tish
          await Provider.of<Auth>(context, listen: false).signup(
            _authData['email']!,
            _authData['password']!,
          );
          setState(() {
            _loading = false;
          });
        }
        // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      } on HttpException catch (error) {
        var errorMessage = "Xatolik sodir bo'ldi";
        if (error.message.contains("EMAIL_EXISTS")) {
          errorMessage = 'Ushbu email ro\'yxatdan o\'tgan';
        } else if (error.message.contains("INVALID_EMAIL")) {
          errorMessage = "To'g'ri email kiriting";
        } else if (error.message.contains("WEAK_PASSWORD")) {
          errorMessage = "Juda oddiy parol";
        } else if (error.message.contains("EMAIL_NOT_FOUND")) {
          errorMessage = "Bu email bilan foydalanuvchi topilmadi";
        } else if (error.message.contains("INVALID_PASSWORD")) {
          errorMessage = "Parol noto'g'ri";
        }
        _showErrorDialog(errorMessage);
      } catch (e) {
        var errorMessage =
            "Kechirasiz xatolisk sodir bo'ldi. Qaytadan urinib ko'ring!";
        _showErrorDialog(errorMessage);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Xatolik!'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  setState(() {
                    _loading = false;
                  });
                },
                child: const Text("OK"),
              ),
            ],
          );
        });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Register;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formkey,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'Iltimos, email manzil kiriting!';
                    } else if (!email.contains('@')) {
                      return "Iltimos, to'g'ri email kiriting";
                    }
                  },
                  onSaved: (email) {
                    _authData['email'] = email!;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Parol'),
                  obscureText: true,
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return 'Iltimos, parolni kiriting.';
                    } else if (password.length < 6) {
                      return 'Parol juda oson.';
                    }
                  },
                  controller: _passwordController,
                  onSaved: (password) {
                    _authData['password'] = password!;
                  },
                ),
                if (_authMode == AuthMode.Register)
                  Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Parol takrorlang'),
                        obscureText: true,
                        validator: (confimPassword) {
                          if (_passwordController.text != confimPassword) {
                            return 'Parollar mos emas!';
                          }
                        },
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 40,
                ),
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(_authMode == AuthMode.Login
                            ? 'KIRISH'
                            : 'Ro\'yxatdan o\'tish'),
                      ),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    _authMode == AuthMode.Register
                        ? 'KIRISH'
                        : 'Ro\'yxatdan o\'tish',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      decoration: TextDecoration.overline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
