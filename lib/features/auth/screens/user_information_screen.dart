import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../common/utlis/utlis.dart';
import '../../../screens/mobile_layout_screen.dart';

class UserInformationScreen extends StatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  _UserInformationScreenState createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  Future<String> uploadImageToFirebase(File image) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profilePictures/${FirebaseAuth.instance.currentUser!.uid}');
    final uploadTask = await storageRef.putFile(image);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<void> storeUserData() async {
    String name = nameController.text.trim();
    if (name.isEmpty) {
      showSnackBar(context: context, content: 'Please enter a name');
      return;
    }

    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String profilePic = '';

      if (image != null) {
        // Upload image to Firebase Storage and get the URL
        profilePic = await uploadImageToFirebase(image!);
      }

      // Store user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'uid': uid,
        'profilePic': profilePic,
        'email': FirebaseAuth.instance.currentUser!.email,
      });

      // Navigate to the next screen after successful storage
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileLayoutScreen(),
        ),
            (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/backgroundImage.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    image == null
                        ? const CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://i0.wp.com/artsci.utk.edu/wp-content/uploads/2022/08/no-image-profile.jpg?fit=600%2C600&ssl=1',
                      ),
                      radius: 64,
                    )
                        : CircleAvatar(
                      backgroundImage: FileImage(image!),
                      radius: 64,
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: size.width * 0.85,
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: nameController,
                        decoration:
                        const InputDecoration(hintText: 'Enter your name'),
                      ),
                    ),
                    IconButton(
                      onPressed: storeUserData,
                      icon: const Icon(Icons.done),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
