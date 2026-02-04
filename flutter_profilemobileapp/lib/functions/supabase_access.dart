import '../main.dart';

//grab current user
Future<String> getUser() async{
  final user = supabase.auth.currentUser;
  if (user != null) {
    final userId = user.id;
    return userId;
  }
  return "NO_USER_LOGGED_IN";
}

//grab profile
Future<List<dynamic>> getProfileDetails() async{
  final response = await supabase
    .from('PROFILE')
    .select()
    .eq('user_id', getUser())
    .single();

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

  return details;
}