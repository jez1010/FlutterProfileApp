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

    String names = "";
    if (response['first_name'] != "" && response['last_name'] != ""){
      String name1 = response['first_name'];
      String name2 = response['last_name'];
      names = "$name1 $name2";
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