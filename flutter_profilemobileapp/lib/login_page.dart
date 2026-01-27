import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF686868)),
        fontFamily: 'IBMPlexSans',
      ),
      home: const LoginScreen(title: 'Flutter Demo Home Page'),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF232738),

      body: Container(
        height: double.infinity,

        margin: EdgeInsets.all(25),

        clipBehavior: Clip.antiAlias,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),

          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,

            colors: [Color(0xFF2D27D7), Color(0xFF191755)],
          ),

          boxShadow: [
            BoxShadow(
              color: Color(0xBF000000),
              blurRadius: 7,
            )
          ]
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
                                      if (value == null || value.isEmpty) {
                                        return 'Input required.';
                                      }
                                      return null;
                                    },
                                  ),

                                  TextFormField(
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
                                ],
                              ),
                            ),
                          ),
                          
                          Container( 
                            margin: EdgeInsets.all(20),

                            alignment: Alignment.center, 

                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF0F0A8F),
                              ),

                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: 'IBMPlexSans',
                                  fontWeight: FontWeight.w500,
                                ),
                              ), 

                              onPressed: () { 
                                if (_loginForm.currentState!.validate()) { 
                                  showDialog( 
                                    context: context, 
                                    builder: (BuildContext context) => AlertDialog( 
                                      title: const Text('Form Completed'), 
                                      content: Text('All fields completed. Confirm?'), 
                                      actions: [ 
                                        TextButton( 
                                          onPressed: () => Navigator.pop(context, 'Cancel'), 
                                          child: Text('Cancel'), 
                                        ), 
                                        TextButton( 
                                          onPressed: () => Navigator.pop(context, 'OK'), 
                                          child: Text('OK'), 
                                        ), 
                                      ] 
                                    ) 
                                  ); 
                                } 
                              } 
                            ), 
                          ) 

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
    );
  }
}
