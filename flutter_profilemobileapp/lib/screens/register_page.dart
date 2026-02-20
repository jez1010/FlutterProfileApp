//dart-flutter libraries
import 'package:flutter/material.dart';

//localfiles
import '../functions/functions.dart';
import 'profile_page.dart';
import 'login_page.dart';

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

  //text fields
  final _registerForm = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _firstField = false;
  bool _secondField = false;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final RegisteringNewUsers _registration = RegisteringNewUsers();

  String selectedProfile = 'DEFAULT_PROFILE_1';
  final List<String> defaults = [
    'DEFAULT_PROFILE_1',
    'DEFAULT_PROFILE_2',
    'DEFAULT_PROFILE_3',
  ];

  //registration function
  bool _isLoading = false;
  Future<String?> _handleRegister() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _registration.signUpNewUser(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _usernameController.text.trim(),
      _firstNameController.text.trim(),
      _lastNameController.text.trim(),
      selectedProfile,
    );

    if (!mounted) return null;

    setState(() {
      _isLoading = false;
    });

    return result;
  }

  //removing form contents
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  //the actual page content
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registration",
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),

        iconTheme: IconThemeData(color: Color(0xFFFFFFFF), size: 30),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,

              colors: [Color(0xFF2D27D7), Color(0xFF191755)],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                "Sign up for Compass",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
              ),
            ),

            //the registration form
            Container(
              margin: EdgeInsets.all(10),
              child: Form(
                key: _registerForm,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Account Setup",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),

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
                        contentPadding: EdgeInsets.symmetric(horizontal: 2),
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
                      obscureText: !_firstField,
                      decoration: InputDecoration(
                        hintText: 'Enter password',

                        contentPadding: EdgeInsets.symmetric(horizontal: 2),
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
                        } else if (value.length < 8) {
                          return 'The password must be at least 8 characters';
                        }
                        if (!value.contains(RegExp(r'[A-Z]')))
                          return 'Add a capital letter.';
                        if (!value.contains(RegExp(r'[0-9]')))
                          return 'Add a number.';
                        if (value.contains(' ')) return 'Remove spaces.';
                        return null;
                      },
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Checkbox(
                            value: _firstField,
                            onChanged: (bool? value) {
                              setState(() {
                                _firstField = !_firstField;
                              });
                            },
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity,
                            ),
                          ),

                          SizedBox(width: 5),

                          Text("Reveal password"),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Confirm Password",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_secondField,
                      decoration: InputDecoration(
                        hintText: 'Reenter previous password here.',
                        contentPadding: EdgeInsets.symmetric(horizontal: 2),
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
                        if (value != _passwordController.text) {
                          return 'Input does not match previous field input.';
                        }
                        return null;
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Checkbox(
                            value: _secondField,
                            onChanged: (bool? value) {
                              setState(() {
                                _secondField = !_secondField;
                              });
                            },
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity,
                            ),
                          ),

                          SizedBox(width: 5),

                          Text("Reveal password"),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    Divider(
                      color: const Color(0xFF6D6D6D),
                      thickness: 0.25,
                      height: 11,
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Details and Personalization",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Username",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _usernameController,
                      maxLength: 15,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: 'Enter username here.',
                        contentPadding: EdgeInsets.symmetric(horizontal: 2),
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

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "First Name",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _firstNameController,
                                decoration: InputDecoration(
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
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Last Name",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
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
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Profile Picture",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: selectedProfile,

                      decoration: InputDecoration(
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

                      items: defaults.map((String profile) {
                        return DropdownMenuItem(
                          value: profile,
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                width: 30,
                                height: 30,

                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'images/defaults/$profile.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                "$profile.png",
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedProfile = newValue;
                          });
                        }
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "* Due to issues in development, please use these selection of profiles pictures for now!",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),

                //socials
              ),
            ),

            //submission button
            Container(
              width: double.infinity,
              height: 50,

              margin: EdgeInsets.only(top: 10, right: 10, left: 10),
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

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),

                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Color(0xFFFFFFFF),
                          strokeWidth: 2,
                        ),
                      )
                    : Text("Submit"),
                onPressed: () async {
                  if (_registerForm.currentState!.validate()) {
                    print(
                      "email: " +
                          _emailController.text.trim() +
                          ", " +
                          "password: " +
                          _passwordController.text.trim() +
                          ", " +
                          "username: " +
                          _usernameController.text.trim() +
                          ", " +
                          "first name: " +
                          _firstNameController.text.trim() +
                          ", " +
                          "last name: " +
                          _lastNameController.text.trim() +
                          ", " +
                          "selected profile: " +
                          selectedProfile,
                    );

                    final result = await _handleRegister();
                    print("thing: $result");

                    if (!mounted) return;

                    if (result == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Successfully registered"),
                          backgroundColor: const Color(0xFF78FF78),
                        ),
                      );
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    }
                    if (result != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(switch (result) {
                            'user_already_exists' =>
                              'This email is already registered. Try logging in!',
                            'invalid_credentials' =>
                              'Incorrect email or password.',
                            'signup_disabled' =>
                              'Signups are currently closed.',
                            'network_error' =>
                              'Check your internet connection and try again.',
                            'weak_password' =>
                              'That password is too easy to guess!',
                            _ => 'An unexpected error occurred (Code: $result)',
                          }),
                          backgroundColor: const Color(0xFFFF0000),
                        ),
                      );
                    }
                  }
                },
              ),
            ),

            Container(
              width: double.infinity,
              height: 50,

              margin: EdgeInsets.only(top: 10, right: 10, left: 10),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFFEEEEEE),

                  foregroundColor: Color(0xFF000000),

                  textStyle: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'IBMPlexSans',
                    fontWeight: FontWeight.w300,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),

                child: Text("Return to Login Screen"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
