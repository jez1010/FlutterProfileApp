import 'package:flutter/material.dart';
import 'profile_page.dart';
import '../main.dart';

void main() {
  runApp(RegisterPage());
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF686868)),
        fontFamily: 'IBMPlexSans',
      ),
      home: const RegisterScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.title});

  final String title;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //variables
  final _registerForm = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: const Text(
          "Registration",
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),

        iconTheme: IconThemeData(color: Color(0xFFFFFFFF), size: 30),
        backgroundColor: Colors.transparent,
      ),

      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,

            children: [
              Container(
                width: double.infinity,
                height: 100,

                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,

                    colors: [Color(0xFF2D27D7), Color(0xFF191755)],
                  ),
                ),
              ),
            ],
          ),

          Container(
            margin: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            child: Text(
              "Sign up for Compass",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w400,
              )
            ),
          ),

          Container(
            margin: EdgeInsets.all(20),
            child: Form(
              key: _registerForm,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Enter email here.',

                      filled: true,
                      fillColor: Colors.grey[200],
                      
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Input required.';
                      }
                      return null;
                    },
                  ),

                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter username here.',
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Input required.';
                      }
                      return null;
                    },
                  ),

                  

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password here.',
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Input required.';
                      }
                      return null;
                    },
                  ),

                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Reenter your password here.',
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Input required.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
