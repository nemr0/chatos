import 'package:chatos/business/chat_cubit/chat_cubit.dart';
import 'package:chatos/business/get_recent_chats/get_recent_chats_cubit.dart';
import 'package:chatos/domain/user.dart';
import 'package:chatos/presentation/helpers/context_extension.dart';
import 'package:chatos/presentation/widgets/chat_widgets/message_widget.dart';
import 'package:chatos/presentation/widgets/multiavatar_generator/multiavatar_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static const String route = '/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final TextEditingController controller;
  late ChatCubit chatCubit;
  late GetRecentChatsCubit getRecentChatsCubit;
  @override
  void dispose() {
    chatCubit.killSubscription();
    getRecentChatsCubit.killSubscription();
    getRecentChatsCubit.run(withLoading: false);
    controller.dispose();
    super.dispose();
  }

  User? user;

  @override
  void initState() {
    controller = TextEditingController();
    _init();
    chatCubit = ChatCubit.get(context);
    getRecentChatsCubit = GetRecentChatsCubit.get(context);
    super.initState();
  }

  Future<void> _init() async {
    await Future.delayed(Duration.zero);
    if (context.mounted) {
      //ignore:use_build_context_synchronously
      final arguments = (ModalRoute.of(context)?.settings.arguments as Map<String, String>);
      final User userFromMap = User.fromMap(arguments);
      //ignore:use_build_context_synchronously
      ChatCubit.get(context).getMessagesForUser(userFromMap.id);
      setState(() {
        user = userFromMap;
      });
    }
  }

  _sendMessage(ChatState state) {
    if (controller.text.isNotEmpty &&
        state is! SendMessageLoading &&
        user?.id != null) {
      ChatCubit.get(context).sendMessage(user!.id, controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 140,
          flexibleSpace: FlexibleSpaceBar(

            centerTitle: true,
          title:user==null?const SizedBox.shrink(): SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MultiAvatarGenerator(code: user!.id,side: 70,),
                Text(user!.name,style: TextStyle(color: context.colorScheme.onPrimaryContainer,fontStyle:FontStyle.italic,fontWeight: FontWeight.w100),),
                Text(user!.email,style: TextStyle(fontSize:12,color: context.colorScheme.onPrimaryContainer,fontStyle:FontStyle.italic,fontWeight: FontWeight.w100),),
              ],
            ),
          ),
        ),),

        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (BuildContext context, state) {
                  print(ChatCubit.get(context).messages);
                  if (ChatCubit.get(context).messages.isNotEmpty) {
                    return MessagesView(
                      messages: ChatCubit.get(context).messages,
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return TextField(
                  controller: controller,
                  style:
                      TextStyle(color: context.colorScheme.onPrimaryContainer),
                  decoration: InputDecoration(
                      hintText: 'Enter A Message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1),
                      ),
                      suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => _sendMessage(state),
                          icon: state is SendMessageLoading
                              ? const CupertinoActivityIndicator()
                              : const Icon(CupertinoIcons.arrow_right_circle))),
                  textInputAction: TextInputAction.send,
                  keyboardType: TextInputType.text,
                  onSubmitted: (_) => _sendMessage(state),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
