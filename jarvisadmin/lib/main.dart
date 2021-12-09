import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jarvis_core/core/theme.dart';
import 'package:oktoast/oktoast.dart';

import 'pages/sign_in/sign_in_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: 'Jarvis Admin',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: SignInPage(),
      ),
    );
  }
}
