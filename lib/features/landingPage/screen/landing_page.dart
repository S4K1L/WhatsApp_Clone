import 'package:flutter/material.dart';
import 'package:whatsapp_clone_app/colors.dart';
import 'package:whatsapp_clone_app/common/widgets/custom_button.dart';

import '../../auth/screens/login_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);


  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/backgroundImage.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Text(
                "Welcome To WhatsApp",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: size.height / 12),
              Image.asset(
                'assets/bg.png',
                height: 340,
                width: 340,
                color: tabColor,
              ),
              SizedBox(height: size.height / 9),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Read our Privacy Policy Tap, ',
                        style: TextStyle(color: greyColor),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        ' "Agree and continue" ',
                        style: TextStyle(color: tabColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Text(
                    'to accept the Terms of Service.',
                    style: TextStyle(color: greyColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: size.width * 0.75,
                child: CustomButton(
                  text: "Agree and Continue",
                  onPressed: () => navigateToLoginScreen(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
