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

            colors: [
              Color(0xFF2D27D7),
              Color(0xFF191755),
            ]
          )
        ),

        child: LayoutBuilder(
          builder: (context, constraints){
            double containerHeight = constraints.maxHeight * 0.75;

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children:[ 
                Container(
                  height: containerHeight,

                  padding: EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFFFFFFF),
                  ),
                  
                  child: Column(
                    children: [
                      Text(
                        "LOGIN",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'IBMPlexSans',
                        )
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
              ]
            );
          }
        )
      )
    );
  }
}