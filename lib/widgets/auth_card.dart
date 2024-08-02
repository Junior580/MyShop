import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _form = GlobalKey();

  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final Map<String, String> _authData = {
    "email": "",
    "password": "",
  };

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ocorreu um error'),
        content: Text(msg),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'))
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    _form.currentState!.save();

    Auth auth = Provider.of(context, listen: false);

    try {
      if (_authMode == AuthMode.Login) {
        await auth.login(_authData['email']!, _authData["password"]!);
      } else {
        await auth.signup(_authData['email']!, _authData["password"]!);
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog("Ocorreu um erro inesperado.");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8.0,
      child: SingleChildScrollView(
        child: Container(
          height: _authMode == AuthMode.Login ? 288 : 378,
          width: deviceSize.width * 0.75,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "E-mail"),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value == null || value.isEmpty || !value.contains("@")
                          ? "Informe um e-mail invalido"
                          : null,
                  onSaved: (value) => _authData["email"] = value!,
                ),
                TextFormField(
                    decoration: const InputDecoration(labelText: "Senha"),
                    controller: _passwordController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    validator: (value) =>
                        value == null || value.isEmpty || value.length < 5
                            ? "Informe uma senha invalido"
                            : null,
                    onSaved: (value) => _authData["password"] = value!),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Confirmar senha"),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.value.text) {
                              return "As senhas devem ser iguais!";
                            }
                            return null;
                          }
                        : null,
                  ),
                const Spacer(),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Theme.of(context).primaryColor),
                    onPressed: _submit,
                    child: Text(
                      _authMode == AuthMode.Login ? "Entrar" : "REGISTRAR",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    "ALTERNAR P/ ${_authMode == AuthMode.Login ? "REGISTRAR" : "LOGIN"}",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
