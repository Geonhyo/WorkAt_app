import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workcafe/view/home-screen.dart';
import 'package:workcafe/viewModel/bookmark-provider.dart';
import 'package:workcafe/viewModel/map-provider.dart';
import 'package:workcafe/viewModel/request-provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.black, // Color for Android
      statusBarBrightness: Brightness.dark // Dark == white status bar -- for IOS.
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context)=> MapProvider(),),
            ChangeNotifierProvider(create: (context)=> BookMarkProvider(),),
            ChangeNotifierProvider(create: (context)=> RequestProvider(),),
          ],
          child: MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '워크앳',
      theme: ThemeData(
      ),
      home: const HomeScreen()
    );
  }
}