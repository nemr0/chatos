import 'package:chatos/business/auth_cubit/auth_cubit.dart';
import 'package:chatos/business/chat_cubit/chat_cubit.dart';
import 'package:chatos/business/get_recent_chats/get_recent_chats_cubit.dart';
import 'package:chatos/firebase_options.dart';
import 'package:chatos/presentation/screens/home/home_screen.dart';
import 'package:chatos/presentation/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'presentation/screens/chat/chat_screen.dart';

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
        BlocProvider(
          create: (_) => AuthCubit(),
        ),
        BlocProvider(
          create: (_) => GetRecentChatsCubit(),
        ),
        BlocProvider(
          create: (_) => ChatCubit(),
        ),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSignOutState) {
            ChatCubit.get(context).killSubscription();
            GetRecentChatsCubit.get(context).killSubscription();
          }
        },
        child: MaterialApp(
          title: 'Chatos',

          /// dark theme from [Colors.purple]
          theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
            bottomSheetTheme: const BottomSheetThemeData(
                backgroundColor: Colors.transparent, elevation: 0),
            // 'cairo' font
            textTheme: GoogleFonts.cairoTextTheme(),
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple, brightness: Brightness.dark),
            useMaterial3: true,
          ),
          routes: {
            LoginScreen.route: (_) => const LoginScreen(),
            HomeScreen.route: (_) => const HomeScreen(),
            ChatScreen.route: (_) => const ChatScreen(),
          },
          initialRoute: FirebaseAuth.instance.currentUser == null
              ? LoginScreen.route
              : HomeScreen.route,
        ),
      ),
    );
  }
}
