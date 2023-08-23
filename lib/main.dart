import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:postfirebase/home_page.dart';
import 'package:postfirebase/checagem_page.dart';
import 'package:postfirebase/firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Publicacões',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.deepPurple,
      ),
      home: const ChecagemPage(),
    );
  }
}