//dart-flutter libraries
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

//main file
import '../main.dart';

//local files
import '../functions/functions.dart';
import 'edit_page.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;
  const ProfileScreen({super.key, this.userId});

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

  @override
  void didUpdateWidget(ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userId != oldWidget.userId) {
      _loadProfile();
    }
  }

  final ProfileRepository _repository = ProfileRepository();

  var defaultLinks = ["LinkedIn", "Github", "Facebook"];

  Future<void> _loadProfile() async {
    await Future.delayed(Duration(milliseconds: 500));
    final data = await _repository.getProfileDetails(personId: widget.userId);

    if (mounted) {
      setState(() {
        profileData = data;
        isLoading = false;
      });
    }
  }

  Widget _schoolLists(Map<String, dynamic> eduMap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (eduMap.containsKey('college') &&
            eduMap['college'] is List &&
            (eduMap['college'] as List).isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [..._buildEducationWidgets(eduMap, 'college')],
          ),
        if (eduMap.containsKey('highschool') &&
            eduMap['highschool'] is List &&
            (eduMap['highschool'] as List).isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [..._buildEducationWidgets(eduMap, 'highschool')],
          ),
        if (eduMap.containsKey('elementary') &&
            eduMap['elementary'] is List &&
            (eduMap['elementary'] as List).isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [..._buildEducationWidgets(eduMap, 'elementary')],
          ),
      ],
    );
  }

  List<Widget> _buildEducationWidgets(
    Map<String, dynamic> eduMap,
    String category,
  ) {
    if (!eduMap.containsKey(category) || eduMap[category] is! List) {
      return [const Text("No data available for this category")];
    }

    List<dynamic> list = eduMap[category];

    return list.map((item) {
      var school = item as Map<String, dynamic>;

      String displayContent = "${school['name'] ?? 'Unknown School'}";

      if (school.containsKey('course'))
        displayContent += "\n${school['course']}";
      if (school.containsKey('level'))
        displayContent += " - ${school['level']}";

      if (school.containsKey('year_start')) {
        displayContent +=
            "\n${school['year_start']} - ${school['year_end'] ?? 'Present'}";
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

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _contactFields() {
    var mappedContacts = Map<String, String>.from(profileData![3] as Map);

    return Column(
      children: [
        if (mappedContacts.isEmpty) Text("User has yet to add socials."),

        for (String key in defaultLinks)
          if (mappedContacts.containsKey(key))
            _buildContact(key, mappedContacts[key]!, isDefault: true),

        for (var entry in mappedContacts.entries)
          if (!defaultLinks.contains(entry.key))
            _buildContact(entry.key, entry.value, isDefault: false),
      ],
    );
  }

  Widget _buildContact(String key, String value, {required bool isDefault}) {
    return InkWell(
      onTap: () => _launchURL(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 30,

        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.5, color: Color(0xFF8D8D8D)),
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 22, // Increased for icon safety
              alignment: Alignment.centerLeft,
              child: isDefault
                  ? switch (key) {
                      "Github" => const FaIcon(
                        FontAwesomeIcons.github,
                        size: 15,
                      ),
                      "Facebook" => const FaIcon(
                        FontAwesomeIcons.facebook,
                        size: 15,
                      ),
                      "LinkedIn" => const FaIcon(
                        FontAwesomeIcons.linkedin,
                        size: 15,
                      ),
                      _ => const Icon(Icons.link, size: 15),
                    }
                  : const Icon(Icons.link, size: 15),
            ),

            SizedBox(
              width: 75,
              child: Text(
                isDefault ? key[0].toUpperCase() + key.substring(1) : key,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            Spacer(),

            Icon(Icons.arrow_outward_sharp, size: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildTags() {
    if (profileData![6] == null) {
      return const Text("User has yet to add tags.");
    }

    List<String> tagList = _repository.parseTags(profileData![6]);
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: [
        for (String tag in tagList)
          if (tag != "")
            Container(
              height: 20,
              padding: EdgeInsets.only(top: 2, bottom: 2, left: 10, right: 10),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFF8D8D8D)),
              ),

              child: Text(
                tag,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
              ),
            ),
      ],
    );
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
              height: 200,

              padding: EdgeInsets.only(
                top: 100,
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
                              !profileData![5].toString().startsWith(
                                "DEFAULT_PROFILE_",
                              )
                              ? NetworkImage(profileData![5].toString())
                              : AssetImage(
                                  'assets/images/defaults/${profileData![5].toString()}.png',
                                ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    SizedBox(width: 10),

                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileData![2]
                                      .toString()
                                      .replaceAll('|', '')
                                      .isEmpty
                                  ? profileData![1].toString()
                                  : profileData![2].toString().replaceAll(
                                      '|',
                                      ' ',
                                    ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w600,
                                fontSize: 25,
                              ),
                            ),

                            Text(
                              "@${profileData![1].toString()}",
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
                  ],
                ),
              ),
            ),
          ],
        ),

        //edit profile button
        if (profileData![0] == supabase.auth.currentSession?.user.id)
          Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFEEEEEE),

                foregroundColor: Color(0xFF000000),

                textStyle: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'IBMPlexSans',
                  fontWeight: FontWeight.w300,
                ),

                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20, child: Icon(Icons.create, size: 12)),
                  Text(
                    "Edit Profile",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pop(context);

                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditScreen()),
                  );
                }
              },
            ),
          ),

        //description
        Container(
          margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "About Me",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),

              Container(
                width: double.infinity,

                padding: EdgeInsets.all(10),

                decoration: BoxDecoration(color: Color(0xFFEEEEEE)),

                child: Text(profileData![4] ?? "No bio has been added."),
              ),
            ],
          ),
        ),

        //tags
        Container(
          margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tags",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 5),
              _buildTags(),
            ],
          ),
        ),

        //contacts
        Container(
          margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),

                decoration: BoxDecoration(color: Color(0xFFEEEEEE)),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Socials",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    _contactFields(),
                  ],
                ),
              ),
            ],
          ),
        ),

        //free space
        if (profileData![7] != null &&
            _repository.parseSchool(profileData![7]).isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Schools",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),

                SizedBox(height: 10),

                _schoolLists(_repository.parseSchool(profileData![7])),
              ],
            ),
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
          "Profile",
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),

        iconTheme: IconThemeData(color: Color(0xFFFFFFFF), size: 30),
        backgroundColor: Colors.transparent,
      ),

      drawer: standardDrawer(context),

      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: profileData == null
            ? Center(key: UniqueKey(), child: CircularProgressIndicator())
            : _pageContents(),
      ),
    );
  }
}
