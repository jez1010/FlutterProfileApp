import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/login_page.dart';
import 'screens/profile_page.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");

    final url = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (url ==null){
      throw Exception("Missing url");
    }

    if (url ==anonKey){
      throw Exception("Missing anonKey");
    }

    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
  } catch (e) {
    debugPrint("Initialization Error: $e");
    return;
  }
  runApp(const MyApp());
}

SupabaseClient get supabase => Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile App',

      theme: ThemeData(
        fontFamily: 'IBMPlexSans',
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      ),

      home: supabase.auth.currentSession == null
        ? const LoginScreen()
        :const ProfileScreen(),
    );
  }
}