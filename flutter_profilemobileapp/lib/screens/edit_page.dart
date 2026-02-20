//dart-flutter libraries
import 'package:flutter/material.dart';
import 'package:flutter_profilemobileapp/screens/socials_editing.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

//main file

//localfiles
import '../functions/functions.dart';
import 'profile_page.dart';


class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class SocialsStorage {
  static Map<String, dynamic> socialsData = {};
}

class _EditScreenState extends State<EditScreen> {
  //variables

  bool _isUploading = false;

  //text fields
  final _editForm = GlobalKey<FormState>();

  final _usernameController = TextEditingController();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _descController = TextEditingController();
  final _tagsController = TextEditingController();

  String? selectedProfile = 'DEFAULT_PROFILE_1';
  final List<String> defaults = ['DEFAULT_PROFILE_1', 'DEFAULT_PROFILE_2', 'DEFAULT_PROFILE_3'];

  Map<String, TextEditingController> templateControllers = {
    "key": TextEditingController(),
    "value": TextEditingController(),
  };

  final ProfileRepository _repository = ProfileRepository();
  List<dynamic>? profileData;
  List<dynamic>? updatedProfileData;

  var defaultLinks = ["LinkedIn", "Github", "Facebook"];



  void loadExistingTags(List<dynamic>? profileData) {
    _usernameController.text = profileData![1] ?? "";
    _firstNameController.text = profileData[2].split("|")[0] ?? "";
    _lastNameController.text = profileData[2].split("|")[1] ?? "";
    SocialsStorage.socialsData = profileData[3] != null
      ? Map<String, dynamic>.from(profileData[3])
      : {};
    _descController.text = profileData[4] ?? "";
    _tagsController.text = profileData[6] ?? "";
    selectedProfile = profileData[5];
  }

  @override
  void initState() {
    super.initState();

    profileData = _repository.retrieveProfile();
    
    if (profileData != null) {
      loadExistingTags(profileData);
    }
  }

  Future<void> grabEverything() async {
    setState(() => _isUploading = true);
    
    try {
      List<dynamic> inputs = [
        _usernameController.text.trim(),
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _tagsController.text.trim(),
        _descController.text.trim(),
        SocialsStorage.socialsData,
        selectedProfile,
      ];
      if (mounted) {
        await _repository.pushToDatabase(inputs, context);
      }

    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
    
  }

  void _launchURL(String urlString) async {
    final Uri? url = Uri.tryParse(urlString);
    
    if (url != null && await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Could not launch $urlString");
    }
  }

  Widget _contactFields() {
    var mappedContacts = Map<String, String>.from(SocialsStorage.socialsData);

    return Column(
      children: [
        if (mappedContacts.isEmpty)
          Text("User has yet to add socials."),

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
    if (_tagsController.text == "") {
      return const Text("User has yet to add tags.");
    }

    List<String> tagList = _repository.parseTags(_tagsController.text);
    return Wrap(
      spacing: 5, 
      runSpacing: 5, 
      children: [
        for (String tag in tagList)
          if (tag != "") 
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

  //the actual page content
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),

        iconTheme: IconThemeData(color: Color(0xFFFFFFFF), size: 30),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,

              colors: [Color(0xFF2D27D7), Color(0xFF191755)],
            ),
          ),
        ),
      ),

      drawer: standardDrawer(context),

      body: SingleChildScrollView(
          child: Column(
            children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen())
                    );
                  },
                  child: Container( 
                    margin: EdgeInsets.only(
                      top: 20, 
                      left: 10, 
                      right: 10
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                          child: Icon(
                            Icons.arrow_back_ios, 
                            size: 8
                          )
                        ),
                        Text(
                          "Return to profile",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          )
                        )
                      ]
                    )
                  )
                ),

              //the editing form
              Container(
                margin: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: Form(
                  key: _editForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Profile Card",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10),
                        child: Stack(
                          alignment: Alignment.center,

                          children: [
                            Container(
                              width: double.infinity,
                              height: 150,

                              padding: EdgeInsets.only(
                                top: 20,
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
                                            AssetImage('assets/images/defaults/$selectedProfile.png'),
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
                                              "${_firstNameController.text}${_lastNameController.text}".isEmpty
                                              ? _usernameController.text
                                              : "${_firstNameController.text} ${_lastNameController.text}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Color(0xFFFFFFFF),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 25,
                                              ),
                                            ),

                                            Text(
                                              "@${_usernameController.text.trim()}",
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
                      ),
                      
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Username",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _usernameController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        maxLength: 15,
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: 'Enter username here.',
                          contentPadding: EdgeInsets.symmetric(horizontal: 2),
                          filled: true,
                          fillColor: const Color(0xFFEEEEEE),

                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color(0xFF8D8D8D),
                            ),
                            borderRadius: BorderRadius.zero,
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF2D27D7),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        style: TextStyle(fontSize: 15),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Input required.';
                          }
                          return null;
                        },
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "First Name",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  controller: _firstNameController,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFEEEEEE),

                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: const Color(0xFF8D8D8D),
                                      ),
                                      borderRadius: BorderRadius.zero,
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF2D27D7),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                  style: TextStyle(fontSize: 15),

                                  validator: (value) {
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Last Name",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  controller: _lastNameController,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFEEEEEE),

                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: const Color(0xFF8D8D8D),
                                      ),
                                      borderRadius: BorderRadius.zero,
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF2D27D7),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                  style: TextStyle(fontSize: 15),

                                  validator: (value) {
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Profile Picture",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        initialValue: selectedProfile, 
                        
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFEEEEEE),

                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color(0xFF8D8D8D),
                            ),
                            borderRadius: BorderRadius.zero,
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF2D27D7),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        
                        items: defaults.map((String profile) {
                          return DropdownMenuItem(
                            value: profile,
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  width: 30,
                                  height: 30,

                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('images/defaults/$profile.png'),
                                      fit: BoxFit.cover,
                                    )
                                  )
                                ),
                                Text(
                                  "$profile.png",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                  )
                                ),
                              ]
                            )
                          );
                        }).toList(),
                        
                        onChanged: (newValue) {
                          setState(() {
                            selectedProfile = newValue;
                          });
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "* Due to issues in development, please use these selection of profiles pictures for now!",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      Divider(
                        color: const Color(0xFF6D6D6D),
                        thickness: 0.25,
                        height: 11,
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Profile Details",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        maxLength: 200,
                        controller: _descController,
                        decoration: InputDecoration(
                          hintText: 'Tell us about yourself...',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 15,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFEEEEEE),

                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color(0xFF8D8D8D),
                            ),
                            borderRadius: BorderRadius.zero,
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF2D27D7),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        style: TextStyle(fontSize: 15),

                        validator: (value) {
                          return null;
                        },
                      ),

                      //tags
                      SizedBox(
                        width: double.infinity,
                  
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tags",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 5,
                        controller: _tagsController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Add tags here..',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 15,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFEEEEEE),

                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color(0xFF8D8D8D),
                            ),
                            borderRadius: BorderRadius.zero,
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF2D27D7),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        style: TextStyle(fontSize: 15),

                        validator: (value) {
                          return null;
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Separate each tag with a comma. Below is how your tags will look like on your profile.",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      _buildTags(),

                      //socials
                      SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                  
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Socials",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFEEEEEE),
                            disabledForegroundColor: Color(0xFF030231),

                            foregroundColor: Color(0xFF000000),

                            textStyle: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'IBMPlexSans',
                              fontWeight: FontWeight.w300,
                            ),

                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          ),

                          child: Text("Edit my socials"),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SocialScreen()),
                            );

                            if(result == true) {
                              setState((){});
                            }
                          },
                        ),
                      ),

                      Text(
                        "Edit your socials with the button above. Below is how your socials will appear.",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),

                        decoration: BoxDecoration(
                          color: Color(0xFFE0E0E0),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            _contactFields(),
                          ],
                        )
                      ),


                      
                    ],
                  ),
                ),
              ),

              //submission button
              Container(
                width: double.infinity,
                height: 50,

                margin: EdgeInsets.all(10),
                child: _isUploading
                  ? Center(key: UniqueKey(), child: CircularProgressIndicator())
                  : TextButton(
                      style: TextButton.styleFrom(

                        backgroundColor: Color(0xFF0F0A8F),
                        disabledForegroundColor: Color(0xFF030231),

                        foregroundColor: Color(0xFFFFFFFF),

                        textStyle: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'IBMPlexSans',
                          fontWeight: FontWeight.w300,
                        ),

                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),

                      child: Text("Submit"),
                      onPressed: _isUploading
                        ? null
                        : () async {
                          await grabEverything();

                          if(mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfileScreen())
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
