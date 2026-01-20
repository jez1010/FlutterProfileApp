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
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text(
              "Login"
            )
          ]
        )
      )
    )
  }
}