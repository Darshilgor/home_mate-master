import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/category_model.dart';
import 'package:home_mate/model/service_model.dart';
import 'package:home_mate/model/user_model.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddService extends StatefulWidget {
  const AddService({Key? key}) : super(key: key);

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  File? coverImage;
  String? categoryValue;
  String? subCategoryValue;
  late List<CategoryModel> category;
  List subCategory = [];
  late FirebaseAuth auth;
  User? user;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  Reference storageRef = FirebaseStorage.instance.ref();
  @override
  void initState() {
    super.initState();
    category = providerCategories;
    auth = FirebaseAuth.instance;
    user = auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clBG,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: clPrimary,
        title: const Text(
          "New Service",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          await getCategories();
          setState(() {
            category = providerCategories;
          });
        },
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),

            SizedBox(
              height: 165,
              child: InkWell(
                onTap: () {
                  selectImage(context);
                },
                child: (coverImage == null)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_box_outlined,
                              size: 50,
                              color: clPrimary,
                            ),
                            const Text("Add Cover Image"),
                          ],
                        ),
                      )
                    : Image.file(coverImage!),
              ),
            ),
            // SizedBox(
            //   height: 200,
            //   child: InkWell(
            //     onTap: () {
            //       selectImage(context);
            //     },
            //     child: DottedBorder(
            //       dashPattern: const [5, 3],
            //       color: clPrimary,
            //       padding: const EdgeInsets.all(12),
            //       borderPadding: const EdgeInsets.all(12),
            //       child: Center(
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Icon(
            //               Icons.add_box_outlined,
            //               size: 50,
            //               color: clPrimary,
            //             ),
            //             const Text("Add Cover Image"),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              decoration: BoxDecoration(
                color: clContainer,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.only(top: 30, left: 12, right: 12),
              margin: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field can't be null";
                            } else if (value.length < 4) {
                              return "Enter at least 4 characters";
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
                              hintText: "eg. Car Wash",
                              labelText: "Service Name"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField(
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
                              subCategory=[];
                              subCategoryValue = null;
                              categoryValue = value;
                              int i = category
                                  .indexWhere((element) => element.name == value);
                              subCategory = category[i].subCategories;
                            });
                          },
                          value: categoryValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field can't be null";
                            } else if (value.length < 4) {
                              return "Enter at least 4 characters";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Select Category",
                            labelText: "Select Category",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          dropdownColor: clContainer,
                          items: List<DropdownMenuItem>.generate(
                            category.length,
                            (index) => DropdownMenuItem(
                              value: category[index].name,
                              child: Text(category[index].name,overflow: TextOverflow.ellipsis,),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField(
                          isExpanded:true,
                          onChanged: (value) {
                            setState(() {
                              subCategoryValue = value;
                            });
                          },
                          value: subCategoryValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          validator: (value) {
                            if (value == null) {
                              return "Please Select a SubCategory";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Select Sub Category",
                            labelText: "Select Sub Category",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          dropdownColor: clContainer,
                          items: List<DropdownMenuItem>.generate(
                            subCategory.length,
                            (index) => DropdownMenuItem(
                              value: subCategory[index],
                              child: Text(
                                subCategory[index],
                                style: const TextStyle(overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: price,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field can't be null";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              hintText: "eg. 200 (in Rupees)",
                              labelText: "Price"),
                        ),
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
                              if (value!.isEmpty) {
                                return "This field can't be null";
                              } else if (value.length < 10) {
                                return "Enter at least 10 characters";
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              hintText: "Service Description",
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
                        if (categoryValue != null && subCategoryValue != null) {
                          await createService(context);
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);

                          snackMessage(context, "Please recheck entered details");
                        }
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
          ],
        ),
      ),
    );
  }

  void selectImage(context) async {
    XFile? selectedFile;
    selectedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectedFile != null) {
      cropImage(selectedFile);
    }
  }

  void cropImage(XFile img) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: img.path,
      aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 2),
      cropStyle: CropStyle.rectangle,
      compressQuality: 50,
    );

    if (croppedImage != null) {
      setState(() {
        coverImage = File(croppedImage.path);
      });
    }
  }

  Future<String> uploadProfile(File? file, String serviceId) async {
    if (file != null) {
      UploadTask task =
          storageRef.child("images/services/$serviceId").putFile(file);

      TaskSnapshot snap = await task;

      Future<String> downloadUrl = snap.ref.getDownloadURL();

      return downloadUrl;
    } else {
      return Future(() => "");
    }
  }

  Future<void> createService(BuildContext context) async {
    processDialog(context);
    String uniqueId = const Uuid().v1();
    String url = await uploadProfile(coverImage, uniqueId);
    ServiceModel newService = ServiceModel(
        id: uniqueId,
        name: name.text.trim(),
        description: description.text,
        category: categoryValue!,
        subCategory: subCategoryValue!,
        rating: 0.0,
        isFeatured: false,
        isSlider: false,
        coverUrl: url,
        price: double.parse(price.text.trim()),
        providerId: user!.uid,
    );
    try {
      await FirebaseFirestore.instance
          .collection("services")
          .doc(uniqueId)
          .set(newService.toMap());

      Navigator.pop(context);
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      snackMessage(context, e.code);
    }
  }
}
