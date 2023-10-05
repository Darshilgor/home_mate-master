import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  bool emailVerified = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = auth.currentUser;
    emailVerified = user!.emailVerified;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clBG,
      appBar: AppBar(
        backgroundColor: clPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Verify Email",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Hint: This is not to change email but verify email",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Verify your current email with confirmation link",
              style: TextStyle(),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Note: You will receive notification on this mail afterword",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(user!.email!,overflow: TextOverflow.ellipsis,),
              trailing: (user!.emailVerified)?const Icon(Icons.verified):InkWell(
                onTap: () {
                  verifyUserEmail(context);
                },
                child: Text(
                  " Send Link ",
                  style: TextStyle(color: clPrimary, height: 3),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void verifyUserEmail(context) async {
    processDialog(context);
    if(user!.emailVerified){
      snackMessage(context, "Your email is already verified!");
      Navigator.pop(context);
      Navigator.pop(context);
    }else{
      await user!.sendEmailVerification();
      snackMessage(context, "Email Verification mail is sent to ${user!.email}");
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }
}
