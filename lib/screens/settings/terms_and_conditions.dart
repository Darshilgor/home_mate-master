import 'package:flutter/material.dart';
import 'package:home_mate/constant/colors.dart';

class TermCondition extends StatelessWidget {
  const TermCondition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clBG,
      appBar: AppBar(
        backgroundColor: clPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Term & Conditions",
          style: TextStyle(color: Colors.white),),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''Welcome to Home Mate ! 
            \nBy using this app, you agree to the following terms and conditions:
            \n1. Service Usage: The services provided through this app are subject to availability and may vary based on your location.
            \n2. User Responsibilities: You are responsible for providing accurate information and ensuring the security of your account credentials.
            \n3. Payment: Payment for services is processed securely through the app. Any fees or charges will be clearly communicated before confirming a service request.
            \n4. Service Quality: We strive to provide high-quality services, but we cannot guarantee the outcome of every service.
            \n5. Privacy: Your personal and payment information will be handled according to our Privacy Policy.
            \n6. Cancellation & Refund: Cancellation and refund policies vary based on the type of service. Refer to the specific service details for more information.
            \n7. Changes to Terms: We reserve the right to modify these terms and conditions. Any changes will be communicated to you through the app.
            \n8. Contact Us: If you have any questions or concerns, please contact our customer support.
            \nBy using this app, you agree to comply with these terms and conditions. Thank you for using our Home Services App!
            ''',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
