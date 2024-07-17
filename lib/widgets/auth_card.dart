import 'package:flutter/material.dart';

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
  final _passwordController = TextEditingController();

  final Map<String, String> _authData = {
    "email": "",
    "password": "",
  };

  void _submit() {
    if (!_form.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    _form.currentState?.save();
    if (_authData == AuthMode.Login) {
      //login
    } else {
      //registrar
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
      child: Container(
        height: _authMode == AuthMode.Login ? 270 : 320,
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                  decoration: const InputDecoration(labelText: "E-mail"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains("@")) {
                      return "Informe um e-mail invalido";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData["email"] = value!;
                  }),
              TextFormField(
                  decoration: const InputDecoration(labelText: "Senha"),
                  controller: _passwordController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 5) {
                      return "Informe uma senha invalido";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData["email"] = value!;
                  }),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: "Confirmar senha"),
                  controller: _passwordController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: _authMode == AuthMode.Signup
                      ? (value) {
                          if (value != _passwordController.value) {
                            return "As senhas devem ser iguais!";
                          }
                          return null;
                        }
                      : null,
                  onSaved: (value) => _authData["email"] = value!,
                ),
              const SizedBox(height: 20),
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
    );
  }
}
