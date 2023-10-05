import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/category_model.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategory();
}

class _AddCategory extends State<AddCategory> {
  List<String> subCategories = [];
  File? coverImage;
  Reference storageRef = FirebaseStorage.instance.ref();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController category = TextEditingController();
  TextEditingController sub = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clBG,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: clPrimary,
        title: const Text(
          "New Category",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(children: [
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 100,
          width: 100,
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
        Container(
          decoration: BoxDecoration(
            color: clBG,
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
                      controller: category,
                      autofocus: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "This field can't be empty";
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
                          hintText: "Enter Category Name",
                          labelText: "Category"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormField(
                          controller: sub,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field can't be empty";
                            } else if (value.length < 4) {
                              return "enter at least 4 characters";
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
                              hintText: "Subcategory",
                              labelText: "Subcategory",
                              constraints: BoxConstraints(maxWidth: 230)),
                        ),
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: clPrimary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                subCategories.add(sub.text.trim());
                                sub.clear();
                                setState(() {});
                              }
                            },
                            child: const Center(
                                child: Icon(
                              Icons.add,
                              size: 40,
                              color: Colors.white,
                            )),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Sub Categories"),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                          minHeight: 200,
                          minWidth: MediaQuery.of(context).size.width,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(),
                        ),
                        child: (subCategories.isNotEmpty)
                            ? Wrap(
                                spacing: 5,
                                children: [
                                  for (String i in subCategories)
                                    Chip(
                                      label: Text(i),
                                      deleteIcon: const Icon(Icons.close),
                                      onDeleted: () {
                                        subCategories.remove(i);
                                        setState(() {});
                                      },
                                      backgroundColor: clContainer,
                                    ),
                                ],
                              )
                            : const Center(child: Text("No Subcategories"))),
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
                  if (category.text.trim().length >= 4 &&
                      subCategories.isNotEmpty) {
                    await createCategory(context);
                    Navigator.pop(context);
                  } else {
                    snackMessage(context, "Please recheck entered details");
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
      ]),
    );
  }

  Future<void> createCategory(BuildContext context) async {
    processDialog(context);
    String uniqueId = const Uuid().v1();
    CategoryModel newCategory = CategoryModel(
      id: uniqueId,
      name: category.text.trim(),
      subCategories: subCategories,
      coverUrl: await uploadProfile(coverImage, uniqueId),
      isFeatured: false,
    );
    try {
      await FirebaseFirestore.instance
          .collection("categories")
          .doc(uniqueId)
          .set(
            newCategory.toMap(),
          );

      Navigator.pop(context);
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      snackMessage(context, e.code);
    }
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
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.rectangle,
      compressQuality: 50,
    );

    if (croppedImage != null) {
      setState(() {
        coverImage = File(croppedImage.path);
      });
    }
  }

  Future<String> uploadProfile(File? file, String categoryId) async {
    if (file != null) {
      UploadTask task =
          storageRef.child("images/categories/$categoryId").putFile(file);

      TaskSnapshot snap = await task;

      Future<String> downloadUrl = snap.ref.getDownloadURL();

      return downloadUrl;
    } else {
      return Future(() => "");
    }
  }
}
