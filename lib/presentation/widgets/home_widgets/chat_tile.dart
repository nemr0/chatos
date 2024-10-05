
import 'package:chatos/domain/chat.dart';
import 'package:chatos/presentation/helpers/context_extension.dart';
import 'package:chatos/presentation/helpers/get_date_string.dart';
import 'package:chatos/presentation/widgets/multiavatar_generator/multiavatar_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key, required this.chat, required this.onPressed,this.loading=false
  });
  final Chat chat;
  final VoidCallback? onPressed;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed:loading?null :onPressed,
      child: Skeletonizer(
        enabled: loading,
        justifyMultiLineText: false,
        ignoreContainers: false,
        child: Column(
          children: [
            const SizedBox(height: 5,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if(loading)
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(height: 40,width: 40, color: Colors.deepPurple,))
                  else MultiAvatarGenerator(code: chat.user.id),
                const SizedBox(width: 8,),
                RichText(
                  text: TextSpan(
                      text: '${chat.user.name}\n',
                      children: [
                        TextSpan(
                            text: chat.lastMessage.content,
                            style: const TextStyle(fontSize: 18))
                      ],
                      style: const TextStyle(fontSize: 24)),
                ),
                const Spacer(),
                Material(child: Text(getDateString(chat.lastMessage.timestamp),style: TextStyle(fontSize: 10,color: context.colorScheme.onPrimaryContainer),))
              ],
            ),
            const SizedBox(height: 5,),

            const Divider(),

          ],
        ),
      ),
    );
  }
}
