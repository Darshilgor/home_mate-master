import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/widgets/bottom_nav.dart';

class ProviderSignUp extends StatefulWidget {
  const ProviderSignUp({super.key});

  @override
  State<ProviderSignUp> createState() => _ProviderSignUp();
}

class _ProviderSignUp extends State<ProviderSignUp> {
  late User? user;
  late FirebaseAuth auth;
  late Reference storageRef;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController tagline = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController email = TextEditingController();

  File? profileImage;

  bool opt1 = false;
  bool opt2 = false;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    user = auth.currentUser;
    storageRef = FirebaseStorage.instance.ref();
  }

  @override
  void dispose() {
    super.dispose();
    tagline.dispose();
    description.dispose();
    email.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/signUp.png"))),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "We need some information about you before getting started !",
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                          controller: tagline,
                          autofocus: true,
                          validator: (value) {
                            if (value == null) {
                              return "This field can't be null";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              hintText: "eg. Electrician",
                              labelText: "Job Title")),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 200,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(),
                        ),
                        child: TextFormField(
                          controller: description,
                          maxLines: 5,
                          validator: (value) {
                            if (value == null) {
                              return "This field can't be null";
                            } else if (value.length < 10) {
                              return "Minimum length is 10";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            hintText: "Job Description",
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      processDialog(context);
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(user!.uid)
                          .update({
                        "tagline": tagline.text.trim(),
                        "description": description.text,
                      });
                      await getUserDetails(user);
                      // ignore: use_build_context_synchronously
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NavBar(index: 0)),
                          (route) => false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(330, 48),
                      backgroundColor: clPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
