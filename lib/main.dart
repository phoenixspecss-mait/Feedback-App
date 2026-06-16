import 'package:Feedback_App/models/service_locator.dart';
import 'package:Feedback_App/views/app_shell.dart';
import 'package:Feedback_App/views/Register_Login_View.dart';
import 'package:Feedback_App/services/auth/auth_service.dart';
import 'package:Feedback_App/services/db/database_service.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Future<void> _authInitialization;

  @override
  void initState() {
    super.initState();
    _authInitialization = AuthService.firebase().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        '/home/': (context) => const app_shell(),
        '/login': (context) => const Register_Login_View(),
      },
      home: FutureBuilder(
        future: _authInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          final user = AuthService.firebase().currentUser;
          if (user != null && user.isEmailVeified) {
            return FutureBuilder(
              future: DatabaseService.instance.getUser(user.id),
              builder: (context, dbSnapshot) {
                if (dbSnapshot.connectionState != ConnectionState.done) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                return app_shell(initialIndex: dbSnapshot.data == null ? 1 : 0);
              },
            );
          }
          return const Register_Login_View();
        },
      ),
    );
  }
}
