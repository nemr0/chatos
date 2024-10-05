import 'package:chatos/business/auth_cubit/auth_cubit.dart';
import 'package:chatos/presentation/helpers/context_extension.dart';
import 'package:chatos/presentation/modal_sheets/search_users/search_users_sheet.dart';
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
      expandedHeight: 160,
      leading: IconButton(
          tooltip: 'Start A New Chat',
          onPressed: () {
            showModalBottomSheet(
                constraints: BoxConstraints(minHeight: context.height*.8,maxHeight: context.height),
                context: context, builder: (_) => const SearchUsersSheet());
          },
          icon: const Icon(CupertinoIcons.add)),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        expandedTitleScale: 1,

        title: expanded
            ?
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MultiAvatarGenerator(code: FirebaseAuth.instance.currentUser!.uid,side: 70,),
            Text('Hello, ${FirebaseAuth.instance.currentUser?.displayName}!', style: TextStyle(color: context.colorScheme.onPrimaryContainer,fontWeight: FontWeight.w100),),
            Text(FirebaseAuth.instance.currentUser!.email!,style: TextStyle(fontSize:14,color: context.colorScheme.onPrimaryContainer.withOpacity(.8),fontStyle:FontStyle.italic,fontWeight: FontWeight.w100),),
          ],
        )
            : null,
      ),
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Logo(
            logoOnly: true,
            side: 40,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Chats',
          ),
        ],
      ),
      actions: [

        IconButton(tooltip: 'SignOut',
            onPressed: () async {
               AuthCubit.get(context).signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.route, (r) => false);

            },
            icon: const Icon(Icons.exit_to_app))
      ],
    );
  }
}
