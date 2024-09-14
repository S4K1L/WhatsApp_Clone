import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone_app/colors.dart';
import 'package:whatsapp_clone_app/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_clone_app/screens/mobile_layout_screen.dart';
import '../../../common/utils/utils.dart';
import '../../../common/widgets/error.dart';
import '../../../common/widgets/loader.dart';
import '../../../model/user_model.dart';
import '../../landingPage/screen/landing_page.dart';
import '../controller/auth_controller.dart';
import '../repository/userData_modifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Reference Firebase Auth and Firestore instances
  FirebaseAuth auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController phoneController = TextEditingController();
  Country? country;
  bool isLoading = false;


  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  Future<void> fetchUserData(String uid) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        // Use the user data as needed.
        final userData = userDoc.data();
        debugPrint('User data: $userData');
      } else {
        throw Exception('User data is null');
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      throw Exception('Failed to fetch user data');
    }
  }


  void pickCountry() {
    showCountryPicker(
      context: context,
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
      },
    );
  }

  Future<void> signUp() async {
    String phoneNumber = phoneController.text.trim();
    String email = '$phoneNumber@gmail.com';
    String password = phoneNumber;

    try {
      setState(() {
        isLoading = true; // Start loading
      });
      var userSnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        signIn();
      } else {
        // If user does not exist, create a new user
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Add the new user to Firestore (Optional: add additional fields if needed)
        await firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'uid': userCredential.user!.uid,
        });

        // Navigate to User Information Screen after signup
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const UserInformationScreen(),
          ),
              (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: 'Error: ${e.message!}');
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }
  Future<void> signIn() async {
    String phoneNumber = phoneController.text.trim();
    String email = '$phoneNumber@gmail.com';
    String password = phoneNumber;

    try {
      // Sign in the user with email and password
      await auth.signInWithEmailAndPassword(email: email, password: password);

      // If the sign-in is successful, navigate to the home page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileLayoutScreen(),
        ),
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: 'Sign-in failed: ${e.message}');
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        elevation: 5,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/backgroundImage.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("WhatsApp will need to verify your phone number."),
                const SizedBox(height: 16),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey
                  ),
                  child: TextButton(
                    onPressed: pickCountry,
                    child: const Text("Pick country", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (country != null) Text('+${country!.phoneCode}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: size.width * 0.7,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: phoneController,
                        decoration: const InputDecoration(
                          hintText: 'Phone number',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.6),
                Container(
                  width: 90,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Colors.greenAccent[700]
                  ),
                  child: TextButton(
                    onPressed: isLoading ? null : signUp,  // Disable the button when loading
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text('Next', style: TextStyle(color: Colors.black)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
