import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/user_model.dart';
import 'package:home_mate/screens/provider/provider_sign_up.dart';
import 'package:home_mate/widgets/bottom_nav.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late User? user;
  late FirebaseAuth auth;
  late Reference storageRef;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
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
    fname.dispose();
    lname.dispose();
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
                InkWell(
                  onTap: () {
                    selectImage(context);
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: clBG,
                    backgroundImage: (profileImage != null)
                        ? FileImage(profileImage!)
                        : null,
                    child: (profileImage == null)
                        ? const Icon(
                            Icons.person,
                            size: 40,
                          )
                        : null,
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
                          controller: fname,
                          validator: (value) {
                            if (value == null) {
                              return "This field can't be null";
                            } else if (value.length < 3) {
                              return "Minimum length is 3";
                            } else {
                              return null;
                            }
                          },
                          maxLength: 10,
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: const InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: Color.fromARGB(255, 237, 237, 239),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            hintText: "First Name",
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          controller: lname,
                          maxLength: 10,
                          validator: (value) {
                            if (value == null) {
                              return "This field can't be null";
                            } else if (value.length < 3) {
                              return "Minimum length is 3";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: const InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: Color.fromARGB(255, 237, 237, 239),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            hintText: "Last Name",
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          controller: email,
                          validator: (value) {
                            if (value == null) {
                              return "This field can't be null";
                            } else if (value.length < 8) {
                              return "Minimum length is 8";
                            } else if (!value.characters.contains('@')) {
                              return "@ not found";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 237, 237, 239),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            hintText: "Email",
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        enabled: false,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(255, 237, 237, 239),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          hintText: user!.phoneNumber,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "You are here to",
                        style: TextStyle(fontSize: 19),
                        textAlign: TextAlign.left,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: opt1,
                            onChanged: (value) {
                              if (!opt2) {
                                setState(() {
                                  opt1 = value!;
                                });
                              } else {
                                setState(() {
                                  opt2 = !value!;
                                  opt1 = value;
                                });
                              }
                            },
                            shape: const CircleBorder(),
                          ),
                          const Text("Get Services"),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: opt2,
                            onChanged: (value) {
                              if (!opt1) {
                                setState(() {
                                  opt2 = value!;
                                });
                              } else {
                                setState(() {
                                  opt1 = !value!;
                                  opt2 = value;
                                });
                              }
                            },
                            shape: const CircleBorder(),
                          ),
                          const Text("Give Services"),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate() && (opt1 || opt2)) {
                      await submitUserData(context);
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
                // Row(
                //   children: [
                //     const SizedBox(width: 40),
                //     const Text("Already have an account?"),
                //     TextButton(
                //       onPressed: () {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const LogIn()));
                //       },
                //       child: const Text("Log In"),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectImage(context) async {
    XFile? selectedFile;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      selectedFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (selectedFile != null) {
                        cropImage(selectedFile!);
                      }
                    },
                    leading: const Icon(Icons.photo_album),
                    title: const Text("Select from Gallery"),
                  ),
                  ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      selectedFile = await ImagePicker()
                          .pickImage(source: ImageSource.camera);
                      if (selectedFile != null) {
                        cropImage(selectedFile!);
                      }
                    },
                    leading: const Icon(Icons.photo_album),
                    title: const Text("Select from Camera"),
                  ),
                ],
              ),
            ));
  }

  void cropImage(XFile img) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: img.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.circle,
      compressQuality: 50,
    );

    if (croppedImage != null) {
      setState(() {
        profileImage = File(croppedImage.path);
      });
    }
  }

  Future<String> uploadProfile(File? file) async {
    if (file != null) {
      UploadTask task =
          storageRef.child("images/profiles/${user!.uid}").putFile(file);

      TaskSnapshot snap = await task;

      Future<String> downloadUrl = snap.ref.getDownloadURL();

      return downloadUrl;
    } else {
      Future<String> url = Future(() => "");
      return url;
    }
  }

  Future<void> submitUserData(context) async {
    processDialog(context);
    try {
      String profileUrl = await uploadProfile(profileImage);
      await user!.updateEmail(email.text.trim());
      await user!
          .updateDisplayName("${fname.text.trim()} ${lname.text.trim()}");
      if (profileImage != null) {
        await user!.updatePhotoURL(profileUrl);
      }
      if (opt1) {
        normalUser = UserModel(
          id: user!.uid,
          fName: fname.text.trim(),
          lName: lname.text.trim(),
          email: email.text.trim(),
          location: "Sector 26, Gandhinagar, Gujarat",
          profileUrl: profileUrl,
          phone: user!.phoneNumber!,
          joined: DateTime.now(),
        );
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .set(normalUser.toMap());
        await getUserDetails(user);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const NavBar(
                      index: 0,
                    )),
            (route) => false);
      } else if (opt2) {
        providerUser = ProviderModel(
          id: user!.uid,
          fName: fname.text.trim(),
          lName: lname.text.trim(),
          email: email.text.trim(),
          location: "Sector 26, Gandhinagar, Gujarat",
          profileUrl: profileUrl,
          phone: user!.phoneNumber!,
          joined: DateTime.now(),
          rating: 0.0,
          tagline: "",
          description: "",

        );
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .set(providerUser.toMap());
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProviderSignUp(),
          ),
        );
      }
    } on FirebaseException catch (e) {
      snackMessage(context, e.message!);
      Navigator.pop(context);
    }
  }
}
