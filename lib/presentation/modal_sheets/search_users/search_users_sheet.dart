import 'package:chatos/data/chat_service.dart';
import 'package:chatos/domain/user.dart';
import 'package:chatos/presentation/helpers/context_extension.dart';
import 'package:chatos/presentation/screens/chat/chat_screen.dart';
import 'package:chatos/presentation/widgets/multiavatar_generator/multiavatar_generator.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchUsersSheet extends StatelessWidget {
  const SearchUsersSheet({super.key});

  static const String route = '/home/searchUsersByEmail';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height,
      child: Scaffold(
        body: Column(
          children: [
            DropDownSearchField<User>(
              textFieldConfiguration: TextFieldConfiguration(

                  autofocus: true,
                  style: DefaultTextStyle.of(context)
                      .style
                      .copyWith(fontStyle: FontStyle.italic,color: context.colorScheme.onPrimaryContainer),
                  decoration: InputDecoration(
                    hintText: 'Enter Your Pal\'s Email Address.',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: context.colorScheme.primary)))),
              suggestionsCallback: (searchText) async {
                return await ChatService().findUsersByEmail(searchText.trim()).then((e){
                  if(kDebugMode) print(e);
                  return e;
                }).catchError((e,s){
                  if(kDebugMode){
                    print(e);
                    print(s);
                  }
                  return<User>[];
                });
              },
              itemBuilder: (BuildContext context, userFound) {
                return SizedBox(
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          MultiAvatarGenerator(
                            code: userFound.id,
                            side: 30,
                          ),
                          const SizedBox(width: 7,),
                          Text(userFound.email,style: TextStyle(color: context.colorScheme.onPrimaryContainer),)
                        ],
                      ),
                      const Spacer(),

                      const Divider(),
                    ],
                  ),
                );
              },
              onSuggestionSelected: (User? suggestion) async {
                if(suggestion!=null){

                    Navigator.pop(context);
                    Navigator.pushNamed(context, ChatScreen.route,arguments: suggestion.toMap());



                }
              },
              displayAllSuggestionWhenTap: false,
            ),
          ],
        ),
      ),
    );
  }
}
