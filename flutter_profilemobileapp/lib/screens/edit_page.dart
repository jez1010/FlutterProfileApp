//dart-flutter libraries
import 'package:flutter/material.dart';
import 'dart:io';

//main file
import '../main.dart';

//localfiles
import '../functions/functions.dart';

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

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _descController = TextEditingController();

  String? selectedProfile = 'DEFAULT_PROFILE_1';
  final List<String> defaults = ['DEFAULT_PROFILE_1', 'DEFAULT_PROFILE_2', 'DEFAULT_PROFILE_3'];

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
                        "Username",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
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
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter password here.',
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
                        "Confirm Password",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
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
                        if (value == null ||
                            value != _passwordController.text) {
                          return 'Input required.';
                        }
                        return null;
                      },
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
                                  if (value == null || value.isEmpty) {
                                    return 'Input required.';
                                  }
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
                                  if (value == null || value.isEmpty) {
                                    return 'Input required.';
                                  }
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
                                    image: AssetImage('images/defaults/$profile.png'),
                                    fit: BoxFit.cover,
                                  )
                                )
                              ),
                              Text(
                                "$profile.png",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                )
                              ),
                            ]
                          )
                        );
                      }).toList(),
                      
                      onChanged: (newValue) {
                        setState(() {
                          selectedProfile = newValue;
                        });
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

                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      maxLength: 200,
                      controller: _descController,
                      decoration: InputDecoration(
                        hintText: 'Tell us about yourself...',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 15,
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

                //socials

              ),
            ),

            //submission button
            Container(
              width: double.infinity,
              height: 50,

              margin: EdgeInsets.all(10),
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

                child: Text("Submit"),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
