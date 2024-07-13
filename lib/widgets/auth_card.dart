import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final AuthMode _authMode = AuthMode.Login;
  final _passwordController = TextEditingController();

  final Map<String, String> _authData = {
    "email": "",
    "password": "",
  };

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8.0,
      child: Container(
        height: 320,
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
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
              ElevatedButton(
                child:
                    Text(_authMode == AuthMode.Login ? "Entrar" : "REGISTRAR"),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
