import 'package:chatos/business/login_cubit.dart';
import 'package:chatos/firebase_options.dart';
import 'package:chatos/presentation/screens/login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  // insure widgets binding is initialized for firebase
  WidgetsFlutterBinding.ensureInitialized();
  // initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit(),),
      ],
      child: MaterialApp(
        title: 'Chatos',

        /// dark theme from [Colors.purple]
        theme: ThemeData(
          // 'cairo' font
          textTheme: GoogleFonts.cairoTextTheme(),
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        routes: {
          LoginScreen.route: (_) => const LoginScreen(),
        },
        initialRoute: LoginScreen.route,
      ),
    );
  }
}
