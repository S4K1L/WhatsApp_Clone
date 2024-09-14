// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone_app/common/providers/message_replay_provider.dart';
import 'package:whatsapp_clone_app/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone_app/features/chat/repositories/chat_repository.dart';
import 'package:whatsapp_clone_app/features/enums/message_emun.dart';
import 'package:whatsapp_clone_app/model/chat_contact.dart';
import 'package:whatsapp_clone_app/model/message.dart';

final chatControllerProvider = Provider<ChatController>((ref) {
  final chatRepository = ref.watch(ChatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

/// Controller that manages chat functionality (sending messages, files, etc.).
class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  /// Stream for chat contacts.
  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  /// Stream for fetching messages for a specific chat.
  Stream<List<Message>> chatStream(String receiverUserId) {
    return chatRepository.getChatStream(receiverUserId);
  }

  /// Sends a text message to the specified receiver.
  Future<void> sendTextMessage(
      BuildContext context, String text, String receiverUserId) async {
    final messageReply = ref.read(messageReplyProvider);
    try {
      // Get current user data before sending the message.
      final userData = await ref.read(userDataAuthProvider.future);
      if (userData != null) {
        await chatRepository.sendTextMessage(
          context: context,
          text: text,
          recieverUserId: receiverUserId,
          senderUser: userData,
          messageReply: messageReply,
        );
        // Clear message reply after sending.
        ref.read(messageReplyProvider.state).state = null;
      } else {
        throw Exception('User data is null');
      }
    } catch (e) {
      debugPrint('Error sending text message: $e');
      // Handle error (e.g., show a snackbar or log the error).
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send message')),
      );
    }
  }

  /// Sends a file (image/video) as a message.
  Future<void> sendFileMessage(
      BuildContext context,
      File file,
      String receiverUserId,
      MessageEnum messageEnum,
      ) async {
    final messageReply = ref.read(messageReplyProvider);
    try {
      // Get current user data before sending the file message.
      final userData = await ref.read(userDataAuthProvider.future);
      if (userData != null) {
        await chatRepository.sendFileMessage(
          context: context,
          file: file,
          receiverUserId: receiverUserId,
          senderUserData: userData,
          messageEnum: messageEnum,
          ref: ref,
          messageReply: messageReply,
        );
        // Clear message reply after sending.
        ref.read(messageReplyProvider.state).state = null;
      } else {
        throw Exception('User data is null');
      }
    } catch (e) {
      debugPrint('Error sending file message: $e');
      // Handle error (e.g., show a snackbar or log the error).
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send file')),
      );
    }
  }
}
