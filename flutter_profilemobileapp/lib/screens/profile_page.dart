//dart-flutter libraries
import 'package:flutter/material.dart';
import 'package:flutter_profilemobileapp/main.dart';

//local files
import 'login_page.dart';
import '../functions/supabase_access.dart';

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
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          alignment: Alignment.center,

          children: [
            Container(
              width: double.infinity,
              height: 300,

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,

                  colors: [Color(0xFF2D27D7), Color(0xFF191755)],
                ),
              ),
            ),

            Positioned(
              top: 70,
              child: Container(
                width: 150,
                height: 150,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFFFFF),
                  image: DecorationImage(
                    image: !profileData![5].toString().startsWith("DEFAULT_PROFILE_")
                      ? NetworkImage(profileData![5].toString())
                      : AssetImage('assets/images/defaults/${profileData![5].toString()}.png'),
                    fit: BoxFit.cover,
                  )
                ),
              ),
            ),

            Positioned(
              bottom: 30,
              child: Container(
                margin: EdgeInsets.only(top: 10),

                child: Text(
                  profileData![1].toString(),
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
                await supabase.auth.signOut();

                if (mounted) {
                  profileData = null;
                  isLoading = true;
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