import 'package:chatos/business/get_recent_chats/get_recent_chats_cubit.dart';
import 'package:chatos/presentation/helpers/context_extension.dart';
import 'package:chatos/presentation/modal_sheets/search_users/search_users_sheet.dart';
import 'package:chatos/presentation/widgets/home_widgets/home_app_bar.dart';
import 'package:chatos/presentation/widgets/home_widgets/chat_tiles.dart';
import 'package:chatos/presentation/widgets/login_widgets/loading_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    GetRecentChatsCubit.get(context).run();
    expanded = true;
    scrollController = ScrollController()..addListener(listener);
    super.initState();
  }

  listener() {
    if (scrollController.offset > 60 && expanded == true) {
      setState(() {
        expanded = false;
      });
    }
    if (scrollController.offset < 60 && expanded == false) {
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
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: ()async=>  await  GetRecentChatsCubit.get(context).run()
            ,),
          HomeAppBar(
            expanded: expanded,
          ),

          BlocBuilder<GetRecentChatsCubit, GetRecentChatsState>(
              builder: (context, state) {
            if (state is GetRecentChatsLoading) {
              return ChatTiles(
                chats: fakeChats,
                loading: true,
              );
            }
            if (state is GetRecentChatsError) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: context.height / 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.triangle_fill,
                        size: 60,
                      ),
                      Text(
                        state.message,
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontSize: 28),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is GetRecentChatsSuccess) {
              if (GetRecentChatsCubit.get(context).chats.isEmpty) {
                return SliverToBoxAdapter(
                    child: SizedBox(
                        height: context.height * .8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No Chats Found',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            LoadingButton(
                                text: 'Start A New Chat!',
                                width: 200,
                                onPressed: () => showModalBottomSheet(
                                    constraints: BoxConstraints(
                                        minHeight: context.height * .8,
                                        maxHeight: context.height),
                                    context: context,
                                    builder: (_) => const SearchUsersSheet()))
                          ],
                        )));
              }
              return ChatTiles(
                chats: GetRecentChatsCubit.get(context).chats,
              );
            }
            return const SliverToBoxAdapter(
              child: SizedBox(),
            );
          })
        ],
      ),
    );
  }
}
