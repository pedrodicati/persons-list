import 'package:flutter/material.dart';
import 'package:trabalho1/pages/home.dart';

class FakeAuthService {
  // Simula um usuário autenticado
  static const String fakeUsername = 'admin';
  static const String fakePassword = '1234';

  // Função para validar as credenciais
  static bool validateCredentials(String username, String password) {
    return username == fakeUsername && password == fakePassword;
  }
}

class LoginPage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  LoginPage({Key? key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: const Color.fromRGBO(0, 12, 102, 1),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(0, 12, 102, 1),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(0, 12, 102, 1),
                    width: 2,
                  ),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;

                // Valida as credenciais usando a classe FakeAuthService
                if (FakeAuthService.validateCredentials(username, password)) {
                  // Se as credenciais são válidas, retorne True
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                } else {
                  // Se as credenciais não são válidas, exiba uma mensagem de erro
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Login failed. Please try again.'),
                      duration: Duration(seconds: 5),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0, 12, 102, 1),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
