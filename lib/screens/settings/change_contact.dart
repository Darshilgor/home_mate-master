import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';

class ChangeContact extends StatefulWidget {
  const ChangeContact({Key? key}) : super(key: key);

  @override
  State<ChangeContact> createState() => _ChangeContactState();
}

class _ChangeContactState extends State<ChangeContact> {
  TextEditingController number = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  bool flag = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  late String phone;
  String receivedID = "";
  GlobalKey<FormState> otpKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = auth.currentUser;
    phone = user!.phoneNumber!;
    number.text = user!.phoneNumber!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clBG,
      appBar: AppBar(
        backgroundColor: clPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Change Contact",
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
              "Enter or edit contact and verify with OTP to change contact details",
              style: TextStyle(),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Note: This will be your login number in future",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: formKey,
              child: TextFormField(
                controller: number,
                validator: (value) {
                  if (value == null) {
                    return "This value can't be null";
                  } else if ((!value.contains("+91") && value.length != 10) ||
                      (value.contains("+91") && value.length != 13)) {
                    return "Enter valid number";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
                onChanged: (x) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  enabled: !flag,
                  hintText: "9876543210",
                  suffixIcon: (user!.phoneNumber == number.text.trim())
                      ? const Icon(Icons.verified)
                      : (number.text.trim() != phone &&
                              "+91${number.text.trim()}" != phone &&
                              !flag &&
                              ((!number.text.trim().contains("+91") &&
                                      number.text.length == 10) ||
                                  (number.text.trim().contains("+91") &&
                                      number.text.length == 13)))
                          ? InkWell(
                              onTap: () {
                                verifyUserPhoneNumber(context);
                              },
                              child: Text(
                                "Send OTP ",
                                style: TextStyle(color: clPrimary, height: 3),
                              ),
                            )
                          : const Icon(Icons.phone),
                  contentPadding: const EdgeInsets.only(
                    left: 17,
                    top: 20,
                    bottom: 20,
                  ),
                  label: const Text(
                    "Phone Number",
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: flag,
              child: Form(
                key: otpKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller2,
                      maxLength: 6,
                      onChanged: (x) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null) {
                          return "This value can't be null";
                        } else if (value.length != 6) {
                          return "Enter valid 6 digit OTP";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "Six Digit OTP",
                        suffixIcon: (controller2.text.trim().length == 6)
                            ? InkWell(
                                onTap: () {
                                  verifyOTPCode(context);
                                  setState(() {});
                                },
                                child: Text(
                                  "Verify ",
                                  style: TextStyle(color: clPrimary, height: 3),
                                ),
                              )
                            : const Icon(Icons.key),
                        contentPadding: const EdgeInsets.only(
                          left: 17,
                          top: 20,
                          bottom: 20,
                        ),
                        label: const Text(
                          "OTP",
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void verifyUserPhoneNumber(context) {
    if (formKey.currentState!.validate()) {
      processDialog(context);
      auth.verifyPhoneNumber(
        phoneNumber: (number.text.contains("+91", 0))
            ? number.text
            : "+91${number.text}",
        codeSent: (String verificationId, int? resendToken) {
          receivedID = verificationId;
          flag = true;
          Navigator.pop(context);
          setState(() {});
        },
        timeout: const Duration(minutes: 1),
        codeAutoRetrievalTimeout: (String verificationId) {},
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException error) {},
      );
    }
  }

  Future<void> verifyOTPCode(context) async {
    if (otpKey.currentState!.validate()) {
      processDialog(context);
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: receivedID,
          smsCode: controller2.text,
        );

        await user!.updatePhoneNumber(credential);
        flag = false;

        Navigator.pop(context);
        Navigator.pop(context);
        snackMessage(context, "Contact Details Changed");


      } on FirebaseException catch (e) {
        if (e.code == "invalid-verification-code") {
          Navigator.pop(context);
          print(e.code);
          snackMessage(context, "Incorrect OTP");
        } else {
          Navigator.pop(context);
          print(e.code);
          snackMessage(context, e.code);
        }
      }
    }
  }
}
