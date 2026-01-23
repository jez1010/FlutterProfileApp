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
 
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF686868))), 
 
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
      body: Container(
        child: Column(
          children: [
            Text(
              "LOGIN"
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

                      validator: (value){
                        if (value == null || value.isEmpty){
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

                      validator: (value){
                        if (value == null || value.isEmpty){
                          return 'Input required.';
                        }
                        return null;
                      },
                    ),
                  ]
                )
              )
            ),
          ]
        )
      )
    );
  }
}