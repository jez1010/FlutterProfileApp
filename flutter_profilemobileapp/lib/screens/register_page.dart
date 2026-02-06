import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../functions/supabase_access.dart';
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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  //image uploading
  File? _selectedImage;
  final ImageService _imageService = ImageService();

  void _handleImageButton() async {
    File? image = await _imageService.pickImage();

    if (image != null){
      setState(() {
        _selectedImage = image;
      });
    }
  }

  //the actual page content
  @override
  Widget build(BuildContext context) {
    final imageToDisplay = _selectedImage;

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

          //the registration form
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
                      fillColor: const Color(0xFFEEEEEE),
                      
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

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                          )
                        ),
                      ),
                  
                      SizedBox(width: 15),
                  
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                          ),
                        ),
                      ),
                    ],
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
                  
                  TextButton(
                    onPressed: () async {
                      _handleImageButton();
                    },

                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.camera_alt),
                            SizedBox(width: 5),
                            Text("Choose an Image"),
                          ]
                        ),

                        Visibility(
                          visible: imageToDisplay != null,
                          child: Container(
                            width: 100,
                            height: 100,

                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFFFFFF),
                              image: imageToDisplay != null
                                ? DecorationImage(
                                  image: FileImage(imageToDisplay),
                                  fit: BoxFit.cover,
                                )
                                : null,
                            ),
                          ),
                        )
                      ]
                    ),
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

          //submission button
        ],
      ),
    );
  }
}
