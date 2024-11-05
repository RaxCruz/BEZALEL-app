import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/device_provider.dart';
import 'providers/locale_provider.dart';
import 'pages/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[50],
        useMaterial3: true,
      ),
      home: Scaffold(
        body: LoginPage(),
      ),
    );
  }
}
