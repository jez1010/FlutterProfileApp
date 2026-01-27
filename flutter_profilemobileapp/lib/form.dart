// Jezron D. Cardona 
// BSIT-242 
// MOBPROG 
 
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
 
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Color(0xFF686868))), 
 
      home: const MyHomePage(title: 'Flutter Demo Home Page'), 
    ); 
  } 
} 
 
class MyHomePage extends StatefulWidget { 
  const MyHomePage({super.key, required this.title}); 
 
  final String title; 
 
  @override 
  State<MyHomePage> createState() => _MyHomePageState(); 
} 
 
class _MyHomePageState extends State<MyHomePage> { 
  final _formKey = GlobalKey<FormState>(); 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      backgroundColor: const Color(0xFF060621), 
 
      extendBodyBehindAppBar: true, 
 
      appBar: AppBar( 
        title: const Text( 
          "Profile", 
          style: TextStyle(color: Color(0xFFFFFFFF)), 
        ), 
 
        iconTheme: IconThemeData( 
          color: Color(0xFFFFFFFF), 
          size: 30, 
        ), 
        backgroundColor: Colors.transparent, 
      ), 
 
      drawer: Drawer(), 
 
      body: Container( 
        child: Column( 
          children: [ 
            //Stack 
            Stack( 
              alignment: Alignment.center, 
 
              children: [ 
                //background 
                Container( 
                  width: double.infinity, 
                  height: 300, 
 
                  decoration: BoxDecoration( 
                    gradient: LinearGradient( 
                      begin: Alignment.topLeft, 
                      end: Alignment.bottomRight, 
 
                      colors: [ 
                        Color(0xFF58638E), 
                        Color(0xFF212156), 
                      ] 
                    ) 
                  ), 
                ), 
                 
                //profile icon 
                Positioned( 
                  top: 70, 
                  child: Container( 
                    width: 150, 
                    height: 150, 
 
                    decoration: BoxDecoration( 
                      shape: BoxShape.circle, 
                      image: DecorationImage( 
                        fit: BoxFit.cover, 
                        image: AssetImage('assets/images/profile.png'), 
                      ), 
                    ), 
                  ), 
                ), 
 
                //profile name 
                Positioned( 
                  bottom: 30, 
                  child: Container( 
                    margin: EdgeInsets.only( 
                      top: 10 
                    ), 
 
                    child: Text( 
                      "Jezron Cardona", 
                      style: TextStyle( 
                        color: Color(0xFFFFFFFF), 
                        fontWeight: FontWeight.bold, 
                        fontSize: 30, 
                      ), 
                    ), 
                  ), 
                ), 
              ], 
            ), 
 
            //Forms 
            Container( 
              margin: EdgeInsets.all(20), 
 
              child: Form( 
                key: _formKey, 
                child: Column( 
                  children: [ 
                    Row( 
                      children: [ 
                        Expanded( 
                          flex: 50, 
                          child: TextFormField( 
                            style: TextStyle( 
                              color: Color(0xFFE9E9E9), 
                            ), 
 
                            decoration: InputDecoration( 
                              labelText: 'First Name', 
                              labelStyle: TextStyle( 
                                color: Color(0xFFE9E9E9), 
                                fontSize: 14, 
                              ), 
                              floatingLabelStyle: TextStyle( 
                                color: Color(0xFFE9E9E9), 
                              ), 
 
                              hintText: 'e.g. Juan', 
                              hintStyle: TextStyle( 
                                color: Color(0xFFE9E9E9), 
                              ), 
                            ), 
 
                            validator: (value) { 
                              if (value == null || value.isEmpty) { 
                                return 'Input required.'; 
                              } 
                              return null; 
                            } 
 
                          ), 
                        ), 
 
                        SizedBox( 
                          width: 20, 
                        ), 
 
                        Expanded( 
                          flex: 50, 
                          child: TextFormField( 
                            style: TextStyle( 
                              color: Color(0xFFE9E9E9), 
                            ), 
 
                            decoration: InputDecoration( 
                              labelText: 'Last Name', 
                              labelStyle: TextStyle( 
                                color: Color(0xFFE9E9E9), 
                                fontSize: 14, 
                              ), 
                              floatingLabelStyle: TextStyle( 
                                color: Color(0xFFE9E9E9), 
                              ), 
 
                              hintText: 'e.g. Dela Cruz', 
                              hintStyle: TextStyle( 
                                color: Color(0xFFE9E9E9), 
                              ), 
                            ), 
 
                            validator: (value) { 
                              if (value == null || value.isEmpty) { 
                                return 'Input required.'; 
                              } 
                              return null; 
                            } 
                          ), 
                        ), 
                      ], 
                    ), 
 
                    TextFormField( 
                      style: TextStyle( 
                        color: Color(0xFFE9E9E9), 
                      ), 
 
                      decoration: InputDecoration( 
                        labelText: 'Email Address', 
                        labelStyle: TextStyle( 
                          color: Color(0xFFE9E9E9), 
                          fontSize: 14, 
                        ), 
                        floatingLabelStyle: TextStyle( 
                          color: Color(0xFFE9E9E9) 
                        ), 
 
                        hintText: 'e.g. jdelacruz@email.com', 
                        hintStyle: TextStyle( 
                          color: Color(0xFFE9E9E9), 
                        ), 
                      ), 
 
                      validator: (value) { 
                        if (value == null || value.isEmpty) { 
                          return 'Input required.'; 
                        } 
                        final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_{|}~]+@[a-zA-Z09]+.[a-zA-Z]+"); 
                        if (!emailRegex.hasMatch(value)) { 
                          return 'Enter a valid email.'; 
                        } 
                        return null; 
                      }, 
                    ), 
 
                    TextFormField( 
                      obscureText: true, 
 
                      style: TextStyle( 
                        color: Color(0xFFE9E9E9), 
                      ), 
 
                      decoration: InputDecoration( 
                        labelText: 'Password', 
                        labelStyle: TextStyle( 
                          color: Color(0xFFE9E9E9), 
                          fontSize: 14, 
                        ), 
                        floatingLabelStyle: TextStyle( 
                          color: Color(0xFFE9E9E9) 
                        ), 
 
                        hintText: 'Enter your password here', 
                        hintStyle: TextStyle( 
                          color: Color(0xFFE9E9E9), 
                        ), 
                      ), 
 
                      validator: (value) { 
                        if (value == null || value.isEmpty) { 
                          return 'Input required.'; 
                        } 
                        if (value.length < 8){ 
                          return 'Password needs to be 8 characters or more.'; 
                        } 
                        return null; 
                      }, 
                    ), 
                  ] 
                ) 
              ) 
            ), 
 
            //Alert Dialog 
            Container( 
              alignment: Alignment.center, 
              child: ElevatedButton( 
                child: Text('Submit'), 
                onPressed: () { 
                  if (_formKey.currentState!.validate()) { 
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
    ); 
} 
} 