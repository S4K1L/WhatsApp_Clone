import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone_app/colors.dart';
import 'package:whatsapp_clone_app/common/providers/message_replay_provider.dart';
import 'package:whatsapp_clone_app/common/utlis/utlis.dart';
import 'package:whatsapp_clone_app/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone_app/features/chat/widgets/message_replay_preview.dart';
import 'package:whatsapp_clone_app/features/enums/message_emun.dart';
import '../../../common/utils/utils.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;

  const BottomChatField({
    Key? key,
    required this.receiverUserId,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  bool isShowEmojiContainer = false;
  final TextEditingController _messageController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _messageController.dispose();
    focusNode.dispose();
    super.dispose();
  }


  /// Sends a text message if there is input and chatroom exists.
  void sendTextMessage() async {
    final messageText = _messageController.text.trim();
    // Ensure FirebaseAuth is initialized before sending
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User not authenticated')),
      );
      return;
    }
    try {
      // Ensure user data exists before sending the message
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User data is null');
      }

      // Proceed if message text is not empty
      if (messageText.isNotEmpty && isShowSendButton) {
        await ref.read(chatControllerProvider).sendTextMessage(
          context,
          messageText,
          widget.receiverUserId,
        );
        setState(() {
          _messageController.clear(); // Clear input after sending
          isShowSendButton = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Message text is empty')),
        );
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }



  /// Sends a file (image or video) to the chatroom.
  void sendFileMessage(File file, MessageEnum messageEnum) {
    try {
      ref.read(chatControllerProvider).sendFileMessage(
        context,
        file,
        widget.receiverUserId,
        messageEnum,
      );
    } catch (e) {
      debugPrint('Error sending file: $e');
    }
  }

  /// Select and send an image.
  Future<void> selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  /// Select and send a video.
  void selectVideo() async {
    File? video = await pickVideoFromGallary(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  /// Toggle emoji keyboard visibility.
  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  /// Show emoji picker.
  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  /// Hide emoji picker.
  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  /// Show the keyboard.
  void showKeyboard() => focusNode.requestFocus();

  /// Hide the keyboard.
  void hideKeyboard() => focusNode.unfocus();

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;

    return Column(
      children: [
        // Show the message reply preview if a message is being replied to
        isShowMessageReply ? const MessageReplayPreview() : const SizedBox(),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _messageController,
                focusNode: focusNode,
                onChanged: (val) {
                  setState(() {
                    isShowSendButton = val.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: IconButton(
                    onPressed: toggleEmojiKeyboardContainer,
                    icon: const Icon(Icons.emoji_emotions, color: Colors.grey),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.camera_alt, color: Colors.grey),
                        ),
                        IconButton(
                          onPressed: selectVideo,
                          icon: const Icon(Icons.attach_file, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF128C7E),
                radius: 25,
                child: GestureDetector(
                  onTap: sendTextMessage,
                  child: Icon(
                    isShowSendButton ? Icons.send : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),

        // Show emoji picker if the container is visible
        isShowEmojiContainer
            ? SizedBox(
          height: 310,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              setState(() {
                _messageController.text += emoji.emoji;
                isShowSendButton = _messageController.text.isNotEmpty;
              });
            },
          ),
        )
            : const SizedBox(),
      ],
    );
  }
}
