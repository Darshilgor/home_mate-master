import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/widgets/bottom_nav.dart';

import 'sign_up.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  void initState() {
    super.initState();
  }

  late bool flag = false;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> otpKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  String smscode = "";
  String receivedID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clBG,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 220,
                  width: 250,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/logIn.png"))),
                ),
                const Text(
                  "Welcome",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Your Home, Our Expertise",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: formKey,
                  child: TextFormField(
                      controller: controller1,
                      validator: (value) {
                        if (value == null) {
                          return "This value can't be null";
                        } else if (value.length != 10) {
                          return "Enter valid 10 digit number";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        enabled: !flag,
                        fillColor: const Color.fromARGB(255, 237, 237, 239),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        hintText: "Phone Number",
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: flag,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                        key: otpKey,
                        child: TextFormField(
                            controller: controller2,
                            maxLength: 6,
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
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(6),
                            ],
                            decoration: const InputDecoration(
                              filled: true,
                              counterText: "",
                              fillColor: Color.fromARGB(255, 237, 237, 239),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              hintText: "Enter OTP",
                            )),
                      ),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  onPressed: () async {
                    flag ? await verifyOTPCode() : verifyUserPhoneNumber();
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(330, 48),
                      backgroundColor: clPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: Text(
                    flag ? "Submit" : "Send OTP",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                // const SizedBox(height: 2),
                // Row(
                //   children: [
                //     const SizedBox(width: 40),
                //     const Text("Don't have an account?"),
                //     TextButton(
                //       onPressed: () {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const SignUp()));
                //       },
                //       child: const Text("Sign Up"),
                //     ),
                //   ],
                // ),
                // const SizedBox(
                //   height: 30,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void verifyUserPhoneNumber() {
    if (formKey.currentState!.validate()) {
      processDialog(context);
      auth.verifyPhoneNumber(
        phoneNumber: "+91${controller1.text}",
        codeSent: (String verificationId, int? resendToken) {
          receivedID = verificationId;
          flag = true;
          Navigator.pop(context);
          setState(() {});
        },
        timeout: const Duration(minutes: 1),
        codeAutoRetrievalTimeout: (String verificationId) {
        },
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then(
            (value) async{
              User? user = auth.currentUser;
              if (user != null) {
                if (user.displayName != null) {
                  await getUserDetails(user);
                  // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NavBar(
                                index: 0,
                              )),
                      (route) => false);
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
                      (route) => false);
                }
              }
            },
          );
        },
        verificationFailed: (FirebaseAuthException error) {
          Navigator.pop(context);
          snackMessage(context, error.message!);
        },
      );
    }
  }

  Future<void> verifyOTPCode() async {
    if (otpKey.currentState!.validate()) {
      try{
        processDialog(context);
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: receivedID,
          smsCode: controller2.text,
        );
        await auth.signInWithCredential(credential).then((value) async {
          User? user = value.user;
          if (user != null) {
            if (user.displayName != null && user.displayName! != "") {
                await getUserDetails(user);
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NavBar(
                          index: 0,
                        )),
                        (route) => false);


            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUp()),
                      (route) => false);
            }
          }
        });
      } on FirebaseException catch (e){
        if(e.code == "invalid-verification-code"){
          Navigator.pop(context);
          print(e.code);
          snackMessage(context, "Incorrect OTP");
        }else{
          Navigator.pop(context);
          print(e.code);
          snackMessage(context, e.code);
        }
        // Navigator.pop(context);

      }
    }
  }
}
