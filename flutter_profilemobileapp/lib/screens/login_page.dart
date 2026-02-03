import 'package:flutter/material.dart';
import 'main_page.dart';
import '../main.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreen(title: 'Login');
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //variables
  final _loginForm = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future <void> _signIn() async {
    try {
      await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } catch (e) {

    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF232738),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://media1.tenor.com/m/Al8FHubXhZsAAAAd/max-verstappen-donuts.gif'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.5),
              BlendMode.darken,
            )
          ),
        ),
        
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 500,
                width: 350,

                clipBehavior: Clip.antiAlias,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),

                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,

                    colors: [
                      Color(0xFF2D27D7),
                      Color(0xFF191755),
                    ],
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Color(0xBF000000), 
                      blurRadius: 7
                    ),
                  ],
                ),

                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double containerHeight = constraints.maxHeight * 0.75;
                    double iconPosition = constraints.maxHeight * 0.12;

                    return Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: containerHeight,

                            padding: EdgeInsets.all(20),

                            alignment: Alignment.bottomCenter,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFFFFFFF),
                            ),

                            child: Container(
                              padding: EdgeInsets.only(top: 75),
                              child: Column(
                                children: [
                                  Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      fontFamily: 'IBMPlexSans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  //The Actual Login Form
                                  Container(
                                    child: Form(
                                      key: _loginForm,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            decoration: InputDecoration(
                                              labelText: 'Email',
                                              hintText: 'Enter email here.',
                                            ),

                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Input required.';
                                              }
                                              return null;
                                            },
                                          ),

                                          TextFormField(
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              labelText: 'Password',
                                              hintText:
                                                  'Enter your password here.',
                                            ),

                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Input required.';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Container(
                                    margin: EdgeInsets.all(20),

                                    alignment: Alignment.center,

                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color(0xFF0F0A8F),
                                        disabledForegroundColor: Color(
                                          0xFF030231,
                                        ),

                                        foregroundColor: Color(0xFFFFFFFF),

                                        textStyle: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'IBMPlexSans',
                                          fontWeight: FontWeight.w500,
                                        ),

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),

                                      child: Text('Submit'),

                                      onPressed: () {
                                        if (_loginForm.currentState!.validate()) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: const Text(
                                                    'Form Completed',
                                                  ),
                                                  content: Text(
                                                    'Successfully logged in. Hello.',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            context,
                                                            'Cancel',
                                                          ),
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => const ProfilePage())
                                                          ),
                                                      child: Text('OK'),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          top: iconPosition,
                          left: 0,
                          right: 0,

                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF232738),
                            ),
                            child: Icon(
                              Icons.account_circle_sharp,
                              size: 150,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
