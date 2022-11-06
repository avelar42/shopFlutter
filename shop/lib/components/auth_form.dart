import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {'email': '', 'password': ''};
  bool _isLoading = false;

  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.Signup;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  Future<void> _submit() async {
    final _isValid = _formKey.currentState?.validate() ?? false;
    if (!_isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);
    if (_isLogin()) {
      //login request
    } else {
      //Signup request
      await auth.signup(_authData['email']!, _authData['password']!);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: _isLogin() ? 310 : 400,
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (email) => _authData['email'] = email ?? '',
                  validator: (_email) {
                    final email = _email ?? '';
                    if (email.trim().isEmpty || !email.contains('@')) {
                      return 'Informe Email valido';
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Senha'),
                  keyboardType: TextInputType.visiblePassword,
                  onSaved: (password) => _authData['password'] = password ?? '',
                  controller: _passwordController,
                  obscureText: true,
                  validator: (_password) {
                    final password = _password ?? '';
                    if (password.isEmpty || password.length < 5) {
                      return 'Informe uma senha com mais de 5 caracteres';
                    } else {
                      return null;
                    }
                  },
                ),
                if (_isSignup())
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Confirmar Senha'),
                    keyboardType: TextInputType.visiblePassword,
                    validator: _isLogin()
                        ? null
                        : (_password) {
                            final password = _password ?? '';
                            if (password != _passwordController.text) {
                              return 'Senhas Informadas Nao Confere';
                            } else {
                              return null;
                            }
                          },
                    obscureText: true,
                  ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        child: Text(_authMode == AuthMode.Login
                            ? 'ENTRAR'
                            : 'REGISTRAR'),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 8)),
                      ),
                Spacer(),
                TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                        _isLogin() ? 'DESEJA REGISTRAR?' : 'JA POSSUI CONTA?'))
              ],
            )),
      ),
    );
  }
}
