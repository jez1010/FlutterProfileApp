import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';
import '../screens/login_page.dart';
import '../screens/edit_page.dart';

//grab current user
String getUser(){
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
    String firstName,//varchar
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
        }
      );

      return null;
    } on AuthException catch (e) {
      return e.code ?? e.message;
    } catch (e) {
      print("$e");
      return(e.toString());
    }
  }
}

//grab profile and store it on local
class ProfileRepository {
  static List<dynamic>? _cachedProfile;

  List<dynamic>? retrieveProfile() {
    return _cachedProfile;
  }

  Future<List<dynamic>> getProfileDetails() async{
    final userId = supabase.auth.currentUser?.id;
    final userEmail = supabase.auth.currentUser?.email;

    if (userId == null) return [];
    if (_cachedProfile != null) return _cachedProfile!;

    final response = await supabase
      .from('PROFILE')
      .select()
      .eq('user_id', userId)
      .maybeSingle();

    print("Raw database response from supabase_access.dart: $response");

    if (response == null) {
      print("No profile found for user: $userId");
      return [userId, "Default Username", "Default Name", "Default Social Media", "Default Description", "Default Photo URL"];
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
      userId,
      userEmail,
      response['username'],
      names,
      response['social_media'],
      response['description'],
      response['photo_link'],
      response['tags'],
      response['extra_details'],
    ];

    _cachedProfile = details;
    return _cachedProfile!;
  }

  static void clearCache() => _cachedProfile = null;

  List<String> parseTags(String tagString) {
    List<String> tags = tagString.split(',');

    for (int i = 0; i <tags.length; i++) {
      tags[i] = tags[i].trim();
    }

    return tags;
  }

  Map<String, dynamic> parseSchool(Map<String, dynamic> decodedJson) {
    if(decodedJson.containsKey('education') && decodedJson['education'] is Map) {
      return decodedJson['education'] as Map<String, dynamic>;
    }
    return {};
  }
}

Widget standardDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Edit profile"),
          onTap: () async {
            Navigator.pop(context);

            if(context.mounted){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditPage())
              );
            }
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
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            }
          },
        ),
      ],
    ),
  );
}
