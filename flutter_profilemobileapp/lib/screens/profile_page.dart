//dart-flutter libraries
import 'package:flutter/material.dart';
import 'package:flutter_profilemobileapp/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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

  var defaultLinks = ["LinkedIn", "Github", "Facebook"];
  

  
  List<Widget> _buildEducationWidgets(Map<String, dynamic> eduMap, String category) {
    if (!eduMap.containsKey(category) || eduMap[category] is! List) {
      return [const Text("No data available for this category")];
    }

    List<dynamic> list = eduMap[category];

    return list.map((item) {
      var school = item as Map<String, dynamic>;
      
      String displayContent = "${school['name'] ?? 'Unknown School'}";
      
      if (school.containsKey('course')) displayContent += "\n${school['course']}";
      if (school.containsKey('level'))  displayContent += " - ${school['level']}";
      
      if (school.containsKey('year_start')) {
        displayContent += "\n${school['year_start']} - ${school['year_end'] ?? 'Present'}";
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          displayContent,
          style: const TextStyle(fontSize: 14, height: 1.4),
        ),
      );
    }).toList();
  }

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

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _contactFields() {
    var mappedContacts = Map<String, String>.from(profileData![4] as Map);

    return Column(
      children: [
        if (mappedContacts.isEmpty)
          Text("User has yet to add socials."),

        for (String key in defaultLinks)
          if (mappedContacts.containsKey(key))
            _buildRow(key, mappedContacts[key]!, isDefault: true),

        for (var entry in mappedContacts.entries)
          if (!defaultLinks.contains(entry.key))
            _buildRow(entry.key, entry.value, isDefault: false),
      ],
    );
  }

  Widget _buildRow(String key, String value, {required bool isDefault}) {
    return InkWell(
      onTap: () => _launchURL(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 30,

        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.5, color: Color(0xFF8D8D8D))
          )
        ),

        child: Row(
          children: [
            Container(
              width: 22, // Increased for icon safety
              alignment: Alignment.centerLeft,
              child: isDefault 
                ? switch (key) {
                    "Github" => const FaIcon(FontAwesomeIcons.github, size: 15),
                    "Facebook" => const FaIcon(FontAwesomeIcons.facebook, size: 15),
                    "LinkedIn" => const FaIcon(FontAwesomeIcons.linkedin, size: 15),
                    _ => const Icon(Icons.link, size: 15,),
                  }
                : const Icon(Icons.link, size: 15),
            ),

            SizedBox(
              width: 75,
              child: Text(
                isDefault ? key[0].toUpperCase() + key.substring(1) : key,
                style: const TextStyle(
                  fontSize: 15, 
                  fontWeight: FontWeight.w400
                ),
              ),
            ),

            Spacer(),

            Icon(
              Icons.arrow_outward_sharp,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTags() {
    List<String> tagList = _repository.parseTags(profileData![7]);
    return Wrap(
      spacing: 5, 
      runSpacing: 5, 
      children: [
        for (String tag in tagList)
          Container(
            height: 20,
            padding: EdgeInsets.only(
              top: 2,
              bottom: 2,
              left: 10, 
              right: 10,
            ),
            
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFF8D8D8D)
              )
            ),

            child: Text(
              tag,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 10,
              ),
            ),
          )
      ],
    );
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

                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileData![3].toString().isEmpty
                              ? profileData![2].toString()
                              : profileData![3].toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w600,
                                fontSize: 25,
                              ),
                            ),

                            Text(
                              "@${profileData![2].toString()}",
                              style: TextStyle(
                                color: Color(0xFFC9C9C9),
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ]
                ),
              ),
            ),
          ],
        ),
        
        //description
        Container(
          margin: EdgeInsets.only(
            top: 10,
            left: 20,
            right: 20,
            bottom: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "About Me",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),

              Container(
                width: double.infinity,

                padding: EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Color(0xFFE0E0E0),
                ),

                child: Text(profileData![5]),
              ),
            ]
          ),
        ),

        //tags
        Container(
          margin: EdgeInsets.only(
            top: 10,
            left: 20,
            right: 20,
            bottom: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tags",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 5),
              _buildTags(),
            ],
          )
        ),

        //contacts
        Container(
          margin: EdgeInsets.only(
            top: 10,
            left: 20,
            right: 20,
            bottom: 5,
          ),
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

              SizedBox(height: 10),

              Container(
                padding: EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Color(0xFFE0E0E0),
                ),

                child: Row(
                  children: [
                    Container(
                      width: 22,

                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.email,
                        size: 15,
                      ),
                    ),

                    SizedBox(
                      width: 50,
                      child: Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500
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
                ),
              ),

              SizedBox(height: 5),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Color(0xFFE0E0E0),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text(
                      "Socials",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    _contactFields(),
                  ],
                )
              ),

              //free space



            ],
          )
        ),
      ],
    );
  }


  //actual build area
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