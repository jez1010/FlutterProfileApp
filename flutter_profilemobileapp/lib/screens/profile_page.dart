//dart-flutter libraries
import 'package:flutter/material.dart';
import 'package:flutter_profilemobileapp/main.dart';
import 'dart:convert';

//local files
import 'login_page.dart';
import '../functions/functions.dart';

void main(){
  runApp(ProfilePage());
}

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
  List<dynamic>? profileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  final ProfileRepository _repository = ProfileRepository();

  Future<void> _loadProfile() async {
    await Future.delayed(Duration(milliseconds: 500));
    final data = await _repository.getProfileDetails();

    if (mounted) {
      setState((){
        profileData = data;
        isLoading = false;
      });
    }
  }

  Widget _pageContents() {
    print("Response from profile_page: ${profileData.toString()}");
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          alignment: Alignment.center,

          children: [
            Container(
              width: double.infinity,
              height: 200,

              padding: EdgeInsets.only(
                top: 70,
                left: 10,
                right: 10,
                bottom: 20,
              ),

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,

                  colors: [Color(0xFF2D27D7), Color(0xFF191755)],
                ),
              ),

              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Container(
                      width: 125,
                      height: 125,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFFFFF),
                        image: DecorationImage(
                          image:
                              !profileData![6].toString().startsWith("DEFAULT_PROFILE_")
                                ? NetworkImage(profileData![6].toString())
                                : AssetImage('assets/images/defaults/${profileData![6].toString()}.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 10,
                    ),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profileData![3].toString().isEmpty
                            ? profileData![2].toString()
                            : profileData![3].toString(),
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w600,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            "@${profileData![2].toString()}",
                            style: TextStyle(
                              color: Color(0xFFC9C9C9),
                              fontWeight: FontWeight.w300,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                ),
              ),
            ),
          ],
        ),

        //profile details
        Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Contact Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 75,
                    child: Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                      ),
                    )
                  ),

                  Text(
                    profileData![1].toString(),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                    )
                  )
                ]
              )
            ],
          )
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: const Text(
          "Your Profile",
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
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap:() async {
                ProfileRepository.clearCache();

                await supabase.auth.signOut();

                if (mounted) {
                  setState(() {
                    profileData = null;
                    isLoading = true;
                  });
                }

                Navigator.pop(context);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            )
          ]
        )
      ),

      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: profileData == null
          ? Center(key: UniqueKey(), child: CircularProgressIndicator())
          : _pageContents()
      ),
    );
  }
}