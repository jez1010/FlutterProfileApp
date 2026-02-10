import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

import '../main.dart';

class jsonConversion {
  Map<String,String> convertString(String jsonString) {
    Map<String, String> mappedValues = jsonDecode(jsonString);
    return mappedValues;
  }
}

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
      return [userId, "DEfault Username", "Default Name", "Default Social Media", "Default Description", "Default Photo URL"];
    }

    String name1 = response['first_name'] ?? "";
    String name2 = response['last_name'] ?? "";
    String names = "";
    if (name1.isNotEmpty || name2.isNotEmpty) {
      names = "$name1 $name2";
    } else {
      names = name1.isNotEmpty ? name1 : name2;
    }
    
    final List<dynamic> details = [
      userId,
      userEmail,
      response['username'],
      names,
      response['social_media'],
      response['description'],
      response['photo_link']
    ];

    _cachedProfile = details;
    return _cachedProfile!;
  }

  static void clearCache() => _cachedProfile = null;
}