import 'package:flutter/material.dart';
import 'package:whatsapp_clone_app/features/auth/screens/login_screen.dart';
import 'package:whatsapp_clone_app/common/widgets/error.dart';
import 'package:whatsapp_clone_app/features/auth/screens/otp_screens.dart';
import 'package:whatsapp_clone_app/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_clone_app/features/select_contacts/screens/select_contact_screen.dart';
import 'package:whatsapp_clone_app/features/chat/screens/mobile_chat_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );

    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );

    case MobileChatScreen.routeName:
      final arguements = settings.arguments as Map<String, dynamic>;
      final name = arguements['name'];
      final uid = arguements['uid'];

      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: "This page doesn't exist."),
        ),
      );
  }
}
