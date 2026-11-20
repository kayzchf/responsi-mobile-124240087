import 'package:flutter/material.dart';
import 'package:responsi_124240087/services/auth_service.dart';
import 'package:responsi_124240087/views/books_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void checkLogin() async {
    final authPref = await SharedPreferences.getInstance();
    final isLoggedIn = authPref.getBool('isLoggedIn')?? false;

    if(isLoggedIn && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BooksScreen()) 
      );
    }

    
  }

  void login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if(username == username && password == '124240087') {
      final authPref = await SharedPreferences.getInstance();
      await authPref.setBool('isLoggedIn', true);
      await authPref.setString('username', username);

      await AuthService.login(username);

      if(mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BooksScreen()) 
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Success!", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Logged in Successfully"),
              ],
            ),
          ),
        );
      }
      await AuthService.login(username);
      print('Login Sukses');
    } else {
      print('Login Gagal');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Login Gagal"),
        ),
      );
    }

    await AuthService.login(username);
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 211, 194, 239),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        login();
                      },
                      child: Text('Login', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
