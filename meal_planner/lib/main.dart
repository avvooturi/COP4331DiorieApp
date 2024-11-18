import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginPage(),
    );
  }
}

// Backend integration functions
Future<void> registerUser(
  String firstName,
  String lastName,
  String email,
  String login,
  String password,
) async {
  final response = await http.post(
    Uri.parse(
        'http://cop4331-t23.xyz:5079/api/register'), // Ensure '/api' is included
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'login': login,
      'password': password,
    }),
  );
  if (response.statusCode != 201) {
    throw Exception('Failed to register: ${response.body}');
  }
}

Future<void> loginUser(String login, String password) async {
  final response = await http.post(
    Uri.parse(
        'http://cop4331-t23.xyz:5079/api/login'), // Ensure '/api' is included
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'login': login, // Changed from 'email' to 'login'
      'password': password,
    }),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to login: ${response.body}');
  }
}

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      // Replace with your API call for changing the password
      final response = await http.post(
        Uri.parse('http://cop4331-t23.xyz:5079/api/change-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'code': _codeController.text,
          'newPassword': _newPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password successfully changed!")),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to change password: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: "One-Time Code"),
            ),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: "New Password"),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: "Confirm New Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePassword,
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.green[800]),
              child: Text("Change Password"),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    try {
      final response = await http.post(
        Uri.parse('http://cop4331-t23.xyz:5079/api/forgotPassword'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _emailController.text}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password reset link sent!")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResetPasswordPage()),
        );
      } else {
        throw Exception('Failed to send reset link: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.green[800]),
              child: Text("Reset Password"),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    try {
      final response = await http.post(
        Uri.parse('http://cop4331-t23.xyz:5079/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'login': _loginController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final objectId = responseData['user']
            ['_id']; // Assuming response contains ObjectId here

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomePage(name: _loginController.text, objectId: objectId),
          ),
        );
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Navbar background color
        title: Text(
          "Di-orie",
          style: TextStyle(
            color: Colors.black, // Navbar text color
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _loginController,
              decoration: InputDecoration(
                labelText: "Login",
                labelStyle: TextStyle(color: Colors.green), // Label text green
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.green), // Focus border color
                ),
              ),
              style: TextStyle(color: Colors.white), // Input text color white
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Colors.green), // Label text green
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.green), // Focus border color
                ),
              ),
              obscureText: true,
              style: TextStyle(color: Colors.white), // Input text color white
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.green[800]),
              child: Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text(
                "Don't have an account? Register here",
                style: TextStyle(color: Colors.green), // Green link color
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                );
              },
              child: Text(
                "Forgot Password?",
                style: TextStyle(color: Colors.green), // Green link color
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black, // Background color for LoginPage
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://cop4331-t23.xyz:5079/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration successful! Please log in.")),
        );

        Navigator.pop(context);
      } else {
        throw Exception('Failed to register: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Navbar background color
        title: Text(
          "Di-orie",
          style: TextStyle(
            color: Colors.black, // Navbar text color
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  labelStyle:
                      TextStyle(color: Colors.green), // Label text green
                ),
                style: TextStyle(color: Colors.white), // Input text white
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle:
                      TextStyle(color: Colors.green), // Label text green
                ),
                style: TextStyle(color: Colors.white), // Input text white
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle:
                      TextStyle(color: Colors.green), // Label text green
                ),
                obscureText: true,
                style: TextStyle(color: Colors.white), // Input text white
              ),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  labelStyle:
                      TextStyle(color: Colors.green), // Label text green
                ),
                obscureText: true,
                style: TextStyle(color: Colors.white), // Input text white
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800]),
                child: Text("Register"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Already have an account? Log in here",
                  style: TextStyle(color: Colors.green), // Green link color
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black, // Background color for RegisterPage
    );
  }
}

// QuizPage Class (Placeholder for actual quiz functionality)
class QuizPage extends StatelessWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz Page")),
      body: Center(child: Text("Welcome to the Quiz Page!")),
    );
  }
}
