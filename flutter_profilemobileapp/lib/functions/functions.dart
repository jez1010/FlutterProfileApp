import 'package:flutter/material.dart';
import 'package:flutter_profilemobileapp/screens/search_page.dart';
import 'package:flutter_profilemobileapp/screens/profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';
import '../screens/login_page.dart';

//grab current user
String getUser() {
  final user = supabase.auth.currentUser;
  if (user != null) {
    final userId = user.id;
    return userId;
  }
  return "NO_USER_LOGGED_IN";
}

//register a new user
class RegisteringNewUsers {
  Future<String?> signUpNewUser(
    String email,
    String password,
    String username, //varchar
    String firstName, //varchar
    String lastName, //varchar
    String profilePicture,
  ) async {
    try {
      await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'first_name': firstName,
          'last_name': lastName,
          'photo_link': profilePicture,
        },
      );

      return null;
    } on AuthException catch (e) {
      return e.code ?? e.message;
    } catch (e) {
      print("$e");
      return (e.toString());
    }
  }
}

//grab profile and store it on local
class ProfileRepository {
  static List<dynamic>? _cachedProfile;

  List<dynamic>? retrieveProfile() {
    return _cachedProfile;
  }

  Future<List<dynamic>> getProfileDetails({String? personId}) async {
    final userId = supabase.auth.currentUser?.id;

    final String? targetId = personId ?? userId;

    if (targetId == null) return [];
    if (personId == null && _cachedProfile != null && targetId == userId)
      return _cachedProfile!;

    final response = await supabase
        .from('PROFILE')
        .select()
        .eq('user_id', targetId)
        .maybeSingle();

    if (response == null) {
      return [
        userId,
        "Default Username",
        "Default Name",
        "Default Social Media",
        "Default Description",
        "Default Photo URL",
      ];
    }

    String name1 = response['first_name'] ?? "";
    String name2 = response['last_name'] ?? "";
    String names = "";
    if (name1.isNotEmpty || name2.isNotEmpty) {
      names = "$name1|$name2";
    } else {
      names = name1.isNotEmpty ? "$name1|" : "|$name2";
    }

    final List<dynamic> details = [
      targetId,
      response['username'],
      names,
      response['social_media'],
      response['description'],
      response['photo_link'],
      response['tags'],
      response['extra_details'],
    ];

    if (personId == null) {
      _cachedProfile = details;
    }

    return details;
  }

  static void clearCache() => _cachedProfile = null;

  List<String> parseTags(String tagString) {
    List<String> tags = tagString.split(',');

    for (int i = 0; i < tags.length; i++) {
      tags[i] = tags[i].trim();
    }

    return tags;
  }

  Map<String, dynamic> parseSchool(Map<String, dynamic> decodedJson) {
    if (decodedJson.containsKey('education') &&
        decodedJson['education'] is Map) {
      return decodedJson['education'] as Map<String, dynamic>;
    }
    return {};
  }

  Future<void> pushToDatabase(
    List<dynamic> inputs,
    BuildContext context,
  ) async {
    // 0 = username,
    //1 = first name,
    //2 = last name,
    //3 = tags,
    //4 = desc,
    //5 = contacts
    //6 = pfp

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    Map<String, dynamic> newData = {
      'username': inputs[0],
      'first_name': inputs[1],
      'last_name': inputs[2],
      'tags': inputs[3],
      'description': inputs[4],
      'social_media': inputs[5],
      'photo_link': inputs[6],
    };

    try {
      await supabase.from('PROFILE').update(newData).eq('user_id', userId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully.")),
      );
    } catch (e) {
      print(e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error saving data. Try again later.")),
        );
      }
    }

    clearCache();
    getProfileDetails();
  }
}

Widget standardDrawer(BuildContext context) {
  return Drawer(
    child: SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text("My Profile"),
            onTap: () async {
              Navigator.pop(context);

              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text("Search"),
            onTap: () async {
              Navigator.pop(context);

              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("About"),
            onTap: () {
              Navigator.pop(context);

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    // This removes the default rounded corners
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    title: const Text("About This App"),
                    content: (Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Version 1.0.1"),
                        Text("Built with Flutter and Supabase."),
                        SizedBox(height: 5),
                        Text(
                          "Changelogs (1.0.1):",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text("> Fixed user registration."),
                      ],
                    )),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("CLOSE"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () async {
              ProfileRepository.clearCache();

              await supabase.auth.signOut();

              Navigator.pop(context);

              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    ),
  );
}

Future<Map<String, List<dynamic>>> searchProfiles({
  String? user_id,
  String? term,
}) async {
  try {
    final List<dynamic> response = await supabase.rpc(
      'searchprofiles',
      params: {'p_user_id': user_id, 'p_search_term': term},
    );

    final List<List<dynamic>> structuredResults = response.map((profile) {
      String name1 = profile['first_name'] ?? "";
      String name2 = profile['last_name'] ?? "";
      String names = (name1.isNotEmpty || name2.isNotEmpty)
          ? "$name1|$name2"
          : "$name1|$name2";

      return [
        profile['user_id'],
        profile['username'],
        names,
        profile['social_media'],
        profile['description'],
        profile['photo_link'],
        profile['tags'],
        profile['extra_details'],
      ];
    }).toList();

    // 3. Wrap the List of Lists in a Map
    return {'profiles': structuredResults};
  } catch (e) {
    print("Search error: $e");
    return {'profiles': []};
  }
}
