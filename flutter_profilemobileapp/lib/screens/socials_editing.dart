//dart-flutter libraries
import 'package:flutter/material.dart';

//main file

//localfiles
import 'edit_page.dart';


class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  //variables

  //text fields
  final _socialForm = GlobalKey<FormState>();

  final defaultLinks = ["LinkedIn", "Github", "Facebook"];
  List<Map<String, TextEditingController>> _defaultControllers = [];

  //social data
  Map<String, dynamic> data = SocialsStorage.socialsData;
  @override
  void initState() {
    super.initState();

    _defaultControllers = [
      { "key": TextEditingController(), "value": TextEditingController() }, //LinkedIn
      { "key": TextEditingController(), "value": TextEditingController() }, //Github
      { "key": TextEditingController(), "value": TextEditingController() }, //Facebook
    ];
    
    populateDefaults();
  }

  //populate _defaultControllers' controllers
  void populateDefaults(){
    //linkedin
    _defaultControllers[0]["key"]!.text = "LinkedIn";
    _defaultControllers[0]["value"]!.text = data["LinkedIn"] ?? "";

    //github
    _defaultControllers[1]["key"]!.text = "Github";
    _defaultControllers[1]["value"]!.text = data["Github"] ?? "";

    //facebook
    _defaultControllers[2]["key"]!.text = "Facebook";
    _defaultControllers[2]["value"]!.text = data["Facebook"] ?? "";
  }

  void pushToStatic(){
    Map<String, dynamic> currentHandles = {};

    for (Map<String, TextEditingController> controller in _defaultControllers) {
      String platform = controller["key"]!.text.trim();
      String value = controller["value"]!.text.trim();

      if (platform.isNotEmpty && value.isNotEmpty) {
        currentHandles[platform] = value;
      }
    }
    
    SocialsStorage.socialsData = currentHandles;
  }

  //the actual page content
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Editing Contacts",
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
        automaticallyImplyLeading: false,
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

      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Container( 
                    margin: EdgeInsets.only(
                      top: 10,
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
                          "Return to editing",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          )
                        )
                      ]
                    )
                  )
                ),

                //socials editing
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Socials",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 15),

                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "URL",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                //default form field rows
                Form(
                  key: _socialForm,
                  child: Column(
                    children: [
                      for (Map<String, TextEditingController> controller in _defaultControllers)
                        Column(
                            children: [
                              Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: controller["key"],
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
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: controller["value"],
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
                            SizedBox(height: 10)
                          ],
                        ),
                    ],
                  ),
                ),

                Container(
                  width: double.infinity,
                  height: 50,

                  margin: EdgeInsets.only(top: 10),
                  child: TextButton(
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

                    child: Text("Update Connections"),
                    onPressed: () {
                      pushToStatic();
                    },
                  ),
                  ),

                Container(
                  margin: EdgeInsets.only(top: 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "This will not update your profile, but simply update the connection view in the main editing screen.",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
