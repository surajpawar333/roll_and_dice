import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roll_dice_demo/src/utils/local_storage.dart';

import 'src/screen/home_page/home_page.dart';
import 'src/screen/login/login.dart';
import 'src/utils/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  LocalStorage();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => LoginBloc()),
        BlocProvider(create: (BuildContext context) => HomePageBloc()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.grey,
        focusColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: LoginPage(),
      navigatorKey: Navigation().navigatorKey,
      routes: Navigation().routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
