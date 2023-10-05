import 'package:flutter/material.dart';
import 'package:home_mate/constant/colors.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clBG,
      appBar: AppBar(
        backgroundColor: clPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Privacy Policy",
          style: TextStyle(color: Colors.white),),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''Effective Date: 21/08/2023

            \nThank you for using Home Mate! This Privacy Policy explains how we collect, use, and disclose your information when you use our app.

            \nInformation Collection and Use:
            We may collect various types of information when you use our app, including personal information you provide and usage data. This information is used to provide and improve our services.

            \nData Security:
            We take appropriate measures to protect your information from unauthorized access, alteration, disclosure, or destruction. However, no method of data transmission over the internet or electronic storage is completely secure.

            \nThird-Party Services:
            Our app may contain links to third-party websites or services that we do not control. We are not responsible for the content or privacy practices of those third-party services.

            \nChanges to This Policy:
            We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.

            \nContact Us:
            If you have any questions or concerns about our Privacy Policy, please contact us at privacy@homemateapp.com.

            \nBy using Home Mate, you agree to the terms of this Privacy Policy.

            Last Updated: 21/08/2023
            ''',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
