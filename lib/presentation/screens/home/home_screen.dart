import 'package:chatos/business/auth_cubit.dart';
import 'package:chatos/presentation/screens/login/login_screen.dart';
import 'package:chatos/presentation/widgets/home_widgets/home_app_bar.dart';
import 'package:chatos/presentation/widgets/login_widgets/logo.dart';
import 'package:chatos/presentation/widgets/multiavatar_generator/multiavatar_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String route = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController scrollController;
  late bool expanded;
  @override
  void initState() {
    expanded = true;
    scrollController = ScrollController()..addListener(listener);

    super.initState();
  }
  listener(){
    if(scrollController.offset>60 && expanded == true){
      setState(() {
        expanded = false;
      });
    }
    if(scrollController.offset<60 && expanded == false){
      setState(() {
        expanded = true;
      });
    }
  }
  @override
  void dispose() {
    scrollController.removeListener(listener);
    scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        HomeAppBar(expanded: expanded),
        SliverList(
            delegate: SliverChildBuilderDelegate((_, __) {
          return Text('data');
        }, childCount: 20))
      ],
    );
  }
}


class SingleChat extends StatelessWidget {
  const SingleChat({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
