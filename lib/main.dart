import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_app/login.dart';
import 'package:user_app/stackbasics.dart';

import 'package:user_app/userregistration.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://oaodufxcoxopwdsrpzkb.supabase.co',
    anonKey: 'sb_publishable_sTCfZJCJ5CKRDmKke9omng_ACVqydil',
  );
  runApp(MainApp());
}
        

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:UserLoginPage()
    );
  }
}
