import 'package:chatos/business/auth_cubit.dart';
import 'package:chatos/presentation/screens/login/login_screen.dart';
import 'package:chatos/presentation/widgets/login_widgets/logo.dart';
import 'package:chatos/presentation/widgets/multiavatar_generator/multiavatar_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.expanded,
  });

  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.large(
      centerTitle: true,
      expandedHeight: 120,

      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: MultiAvatarGenerator(code: FirebaseAuth.instance.currentUser!.uid),
      ),
      flexibleSpace: FlexibleSpaceBar(title:expanded? Text('Hello,\n ${FirebaseAuth.instance.currentUser?.email}!',style: TextStyle(fontSize: 18,color: Theme.of(context).colorScheme.onPrimaryContainer,),):null,),
      title:  const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Logo(logoOnly: true,side: 40,),
          SizedBox(width: 8,),
          Text(
            'Chats',
          ),
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.add)),
        IconButton(
            onPressed: () async {
              await AuthCubit.get(context).signOut();
              if(context.mounted)Navigator.pushNamedAndRemoveUntil(context, LoginScreen.route, (r)=>false);
            },
            icon: const Icon(Icons.exit_to_app))
      ],
    );
  }
}
