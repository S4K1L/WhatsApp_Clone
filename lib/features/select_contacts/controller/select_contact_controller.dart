import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final selectContactControllerProvider =
Provider((ref) => SelectContactController());

final getUsersProvider = StreamProvider<List<UserModel>>((ref) {
  return ref.watch(selectContactControllerProvider).getAllUsers();
});

class SelectContactController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all users from Firestore
  Stream<List<UserModel>> getAllUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data());
      }).toList();
    });
  }

  // Handle contact selection
  void selectContact(UserModel selectedUser, BuildContext context) {
    // Handle contact selection logic (e.g., navigating to chat screen)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected contact: ${selectedUser.name}'),
      ),
    );

    // You can navigate to the chat screen or handle the selection logic here
    Navigator.pushNamed(
      context,
      '/mobile-chat-screen',
      arguments: {
        'name': selectedUser.name,
        'uid': selectedUser.uid,
      },
    );
  }

}
