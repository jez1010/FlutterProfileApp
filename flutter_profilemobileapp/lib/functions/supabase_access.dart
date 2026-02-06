import '../main.dart';

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
  Future<void> signUpNewUser(
    String email,
    String username, //varchar
    String firstName,//varchar
    String lastName, //varchar
    String socialMedia, //jsonb
    String description, //text
    String password,
  ) async {
    try {
      final authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final String? userId = authResponse.user?.id;

      if (userId != null){
        await supabase.from('PROFILES').insert({
          'user_id': userId,
          'username': username,
          'first_name': firstName,
          'last_name': lastName,
        });
      }
    } catch (e) {
      print("Registration failed: $e");
    }
  }
}


//grab profile and store it on local
class ProfileRepository {
  static List<dynamic>? _cachedProfile;

  final String userId = supabase.auth.currentUser?.id ?? "";

  Future<List<dynamic>> getProfileDetails() async{
    if (_cachedProfile != null) return _cachedProfile!;

    final response = await supabase
      .from('PROFILE')
      .select()
      .eq('user_id', userId)
      .maybeSingle();

    print("Raw database response: $response");

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
      response['user_id'],
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