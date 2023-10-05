import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/screens/user/profile.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  User user = FirebaseAuth.instance.currentUser!;
  FirebaseAuth auth = FirebaseAuth.instance;
  Reference storageRef = FirebaseStorage.instance.ref();
  String? profileUrl;
  String receivedID = "";
  bool flag = false;
  late String fullName;
  late String emailID;
  late String phone;
  File? profileImage;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    List name = user.displayName!.split(" ");
    fname.text = name[0];
    lname.text = name[1];
    fullName = user.displayName!;
    email.text = user.email!;
    emailID = user.email!;
    number.text = user.phoneNumber!;
    phone = user.phoneNumber!;
    profileUrl = user.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width * 1;
    double screenheight = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        //leading: IconButton(onPressed: (){Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const NavBar(index: 3)), (route) => false)},icon:const Icon(Icons.arrow_back,color: Colors.white,),),
        backgroundColor: clPrimary,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Center(
                child: SizedBox(
                  width: screenwidth * 0.3,
                  height: screenheight * 0.15,
                  child: CircleAvatar(
                    backgroundColor: clBG,
                    backgroundImage: (profileImage != null)
                        ? FileImage(profileImage!)
                        : (profileUrl != null)
                            ? NetworkImage(profileUrl!)
                                as ImageProvider<Object>?
                            : null,
                    child: (profileImage == null && profileUrl == null)
                        ? const Icon(
                            Icons.person,
                            size: 40,
                          )
                        : null,
                  ),
                ),
              ),
              Positioned(
                top: screenheight * 0.1,
                left: screenwidth * 0.55,
                child: InkWell(
                  onTap: () {
                    selectImage(context);
                  },
                  child: SvgPicture.asset(
                    'assets/icons/Camera.svg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      simpletextformfield(
                        "First Name",
                        "First Name",
                        fname,
                        Icons.account_circle_outlined,
                        (value) {
                          if (value == null) {
                            return "This field can't be null";
                          } else if (value.length < 3) {
                            return "Minimum length is 3";
                          } else {
                            return null;
                          }
                        },
                      ),
                      simpletextformfield(
                        "Last Name",
                        "Last Last",
                        lname,
                        Icons.account_circle_outlined,
                        (value) {
                          if (value == null) {
                            return "This field can't be null";
                          } else if (value.length < 3) {
                            return "Minimum length is 3";
                          } else {
                            return null;
                          }
                        },
                      ),
                      simpletextformfield(
                        "Email",
                        "example@email.com",
                        email,
                        Icons.email_outlined,
                        (value) {
                          if (value == null) {
                            return "This field can't be null";
                          } else if (value.length < 5) {
                            return "Minimum length is 8";
                          } else if (!value.characters.contains('@') &&
                              !value.characters.contains('.')) {
                            return "Please enter a valid email";
                          } else {
                            return null;
                          }
                        },
                      ),
                      simpletextformfield("Address", "Sector-26,gandhinagar",
                          address, Icons.location_on_outlined, (value) {
                        return null;
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 0.12,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: clPrimary),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    processDialog(context);
                    if (email.text.trim() != emailID) {
                      try{
                        await user.updateEmail(email.text.trim());
                      } on FirebaseException catch(e){
                        Navigator.pop(context);
                        Navigator.pop(context);
                        snackMessage(context, e.message!);
                      }
                    }
                    String url = await uploadProfile(profileImage);
                    if ("${fname.text.trim()} ${lname.text.trim()}" !=
                        fullName) {
                      await user.updateDisplayName(
                          "${fname.text.trim()} ${lname.text.trim()}");
                    }

                    if (profileImage != null) {
                      await user.updatePhotoURL(url.isNotEmpty?url:profileUrl);
                    }
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(user.uid)
                        .update({
                      "email": email.text.trim(),
                      "fName": fname.text.trim(),
                      "lName": lname.text.trim(),
                      "profileUrl": url.isNotEmpty?url:profileUrl,
                    });
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  simpletextformfield(
    String labeltext,
    String hinttext,
    TextEditingController controller,
    IconData icon,
    String? Function(String?) validator,
  ) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: hinttext,
            suffixIcon: Icon(
              icon,
            ),
            contentPadding: const EdgeInsets.only(
              left: 17,
              top: 20,
              bottom: 20,
            ),
            label: Text(
              labeltext,
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
          storageRef.child("images/profiles/${user.uid}").putFile(file);

      TaskSnapshot snap = await task;

      Future<String> downloadUrl = snap.ref.getDownloadURL();

      return downloadUrl;
    } else {
      return Future(() => "");
    }
  }
}
