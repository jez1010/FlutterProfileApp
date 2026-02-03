import 'package:flutter/material.dart';
import 'package:flutter_profilemobileapp/screens/login_page.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF686868)),
        fontFamily: 'IBMPlexSans',
      ),
      home: const ProfileScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.title});

  final String title;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //variables

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: const Text(
          "Jez's Profile",
          style: TextStyle(
            color: Color(0xFFFFFFFF)
          ),
        ),

        iconTheme: IconThemeData(
          color: Color(0xFFFFFFFF), 
          size: 30
        ),
        backgroundColor: Colors.transparent,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.login),
              title: Text("Login"),
              onTap:(){
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage())
                );
              },
            )
          ]
        )
      ),

      body: Container(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,

              children:[
                Container(
                  width: double.infinity,
                  height: 300,

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      
                      colors: [
                        Color(0xFF2D27D7),
                        Color(0xFF191755)
                      ]
                    )
                  )
                ),


              ]
            )
          ],
        )
      )
    );
  }
}