//dart-flutter libraries
import 'package:flutter/material.dart';

//main file
import '../main.dart';

//localfiles
import 'profile_page.dart';
import 'register_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //variables

  //login forms
  final _loginForm = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordField = false;

  Future<void> _signIn() async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (response.user != null && mounted) {
        _successMessage();
      }
    } catch (e) {
      _errorMessage();
    }
  }

  //status messages
  void _errorMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text('Failed to authenticate. Try again later.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _successMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Form Completed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Successfully logged in. Hello.'),
            Text(supabase.auth.currentUser?.id ?? "ID was not retrieved."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  //removing form contents
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //the actual page content
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF232738),

      body: Container(
        clipBehavior: Clip.antiAlias,

        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,

            colors: [Color(0xFF2D27D7), Color(0xFF191755)],
          ),

          boxShadow: [BoxShadow(color: Color(0xBF000000), blurRadius: 7)],
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

                    decoration: BoxDecoration(color: Color(0xFFFFFFFF)),

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
                          Form(
                            key: _loginForm,
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Email",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter email here.',
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFEEEEEE),

                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: const Color(0xFF8D8D8D),
                                      ),
                                      borderRadius: BorderRadius.zero,
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF2D27D7),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                  style: TextStyle(fontSize: 15),

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Input required.';
                                    }
                                    return null;
                                  },
                                ),

                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Password",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: !_passwordField,
                                  decoration: InputDecoration(
                                    hintText: 'Enter password',

                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFEEEEEE),

                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: const Color(0xFF8D8D8D),
                                      ),
                                      borderRadius: BorderRadius.zero,
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF2D27D7),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                  style: TextStyle(fontSize: 15),

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

                          Container(
                            margin: EdgeInsets.only(top: 5),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _passwordField,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _passwordField = !_passwordField;
                                    });
                                  },
                                  visualDensity: const VisualDensity(
                                    horizontal: VisualDensity.minimumDensity,
                                    vertical: VisualDensity.minimumDensity,
                                  ),
                                ),

                                SizedBox(width: 5),

                                Text("Show password"),
                              ],
                            ),
                          ),


                          //submission buttons
                          Container(
                            alignment: Alignment.center,

                            child: Column(
                              children: [
                                //submit
                                Container(
                                  width: double.infinity,
                                  height: 50,

                                  margin: EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: TextButton(
                                    style: TextButton.styleFrom(

                                      backgroundColor: Color(0xFF0F0A8F),
                                      disabledForegroundColor: Color(0xFF030231),

                                      foregroundColor: Color(0xFFFFFFFF),

                                      textStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'IBMPlexSans',
                                        fontWeight: FontWeight.w300,
                                      ),

                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                    ),

                                    child: Text('Submit'),

                                    onPressed: () {
                                      if (_loginForm.currentState!.validate()) {
                                        _signIn();
                                      }
                                    },
                                  ),
                                ),

                                //register
                                Container(
                                  width: double.infinity,
                                  height: 50,

                                  margin: EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: TextButton(
                                    style: TextButton.styleFrom(

                                      backgroundColor: Color(0xFFEEEEEE),

                                      foregroundColor: Color(0xFF000000),

                                      textStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'IBMPlexSans',
                                        fontWeight: FontWeight.w300,
                                      ),

                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                    ),

                                    child: Text('Sign up'),

                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterPage(),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                              ],

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
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
