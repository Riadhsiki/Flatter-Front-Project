import 'package:flutter/material.dart';
import 'package:fluttertesttest/models/userinfo.dart';
import 'package:fluttertesttest/screens/admin_screen.dart';
import 'package:fluttertesttest/screens/welcome_screen.dart';
import 'package:fluttertesttest/services/auth_service.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AuthService _authService = AuthService();

   @override
    Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    width: 300,
                    height: 100,
                    child: Image.asset(
                      "assets/images/LOGO.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: const TextStyle(color: Colors.amberAccent),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: Colors.amberAccent),
                              ),
                            ),
                            style: const TextStyle(color: Colors.amberAccent),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: obscureText,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscureText ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.amberAccent,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                              ),
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.amberAccent),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: Colors.amberAccent),
                              ),
                            ),
                            style: const TextStyle(color: Colors.amberAccent),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amberAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 6, 16, 116),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
 Future<void> _login() async {
    String enteredUsername = _usernameController.text;
    String enteredPassword = _passwordController.text;
    bool loginSuccess = await _oauth.login(enteredUsername, enteredPassword);
    print(loginSuccess);
    if (loginSuccess) {
      UserInfo? userinfo = await _oauth.getUserInfo();
      print(userinfo);
      if (userinfo != null) {
        if (userinfo.roles.contains('admin')) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminScreen()),
            (route) => false,
          );
        } else if (userinfo.roles.contains('controller')) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
            (route) => false,
          );
        } else {
          print('Redirecting to default screen');
        }
      } else {
        print('User info is null');
      }
    } else {
      print('Login failed');
    }
  }
}