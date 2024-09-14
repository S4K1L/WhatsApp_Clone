import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone_app/common/widgets/error.dart';
import 'package:whatsapp_clone_app/common/widgets/loader.dart';
import 'package:whatsapp_clone_app/features/select_contacts/controller/select_contact_controller.dart';
import 'package:whatsapp_clone_app/model/user_model.dart';

import '../../chat/screens/mobile_chat_screen.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const String routeName = '/select-contact';
  const SelectContactsScreen({Key? key}) : super(key: key);

  // Function to handle contact selection
  void selectContact(BuildContext context, UserModel selectedUser) {
    // Navigate to the chat room screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: selectedUser.name,
          uid: selectedUser.uid,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgroundImage.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ref.watch(getUsersProvider).when(
          data: (userList) => ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10,top: 16,left: 10,right: 10),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[700]!.withOpacity(0.3)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => selectContact(context, user),
                        child: ListTile(
                          title: Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            '0${user.email.length > 10 ? user.email.substring(0, 10) : user.email}',
                          ),
                          leading: user.profilePic.isEmpty
                              ? CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            child: const Icon(Icons.person),
                            radius: 30,
                          )
                              : CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePic),
                            radius: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          error: (err, trace) => ErrorScreen(error: err.toString()),
          loading: () => const Loader(),
        ),
      ),
    );
  }
}