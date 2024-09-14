// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone_app/common/providers/message_replay_provider.dart';
import 'package:whatsapp_clone_app/common/widgets/loader.dart';
import 'package:whatsapp_clone_app/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone_app/features/chat/widgets/sender_message_card.dart';
import 'package:whatsapp_clone_app/features/enums/message_emun.dart';
import 'package:whatsapp_clone_app/model/message.dart';

import 'my_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  const ChatList({
    Key? key,
    required this.receiverUserId,
  }) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum messageEnum,
  ) {
    ref.read(messageReplyProvider.state).update(
          (state) => MessageReply(
            message: message,
            isMe: isMe,
            messageEnum: messageEnum,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          // Show loading state until FirebaseAuth confirms the user is logged in
          return const Loader();
        }

        if (authSnapshot.hasData) {
          // If the user is authenticated, proceed to the chat list
          return buildChatList();
        } else {
          // If the user is not authenticated, redirect to login screen or show an error
          return const Center(child: Text('User not logged in.'));
        }
      },
    );
  }

  Widget buildChatList() {
    return StreamBuilder<List<Message>>(
        stream: ref.read(chatControllerProvider).chatStream(widget.receiverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (messageController.hasClients) {
              messageController.jumpTo(messageController.position.maxScrollExtent);
            }
          });

          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var timeSent = DateFormat.Hm().format(messageData.timeSent);

              if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  date: timeSent,
                  type: messageData.type,
                  repliedText: messageData.repliedMessage,
                  username: messageData.repliedTo,
                  repliedMessageType: messageData.repliedMessageType,
                  OnLeftSwipe: () =>
                      onMessageSwipe(messageData.text, true, messageData.type),
                );
              }

              return SenderMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
                username: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,
                onRightSwipe: () =>
                    onMessageSwipe(messageData.text, false, messageData.type),
                repliedText: messageData.repliedMessage,
              );
            },
          );
        });
  }

}
