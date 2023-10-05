import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/chat_model.dart';
import 'package:home_mate/model/service_model.dart';
import 'package:home_mate/model/user_model.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  State<AllUsers> createState() => _AllUsers();
}

class _AllUsers extends State<AllUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: clPrimary,
        title: const Text(
          "All Users",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              List allUsers = snapshot.data!.docs.map((e) => e.data()).toList();
              List<ProviderModel> providerList = allUsers
                  .where((e) => e["type"] == "provider")
                  .toList()
                  .map((e) => ProviderModel.fromMap(e))
                  .toList();
              List<UserModel> userList = allUsers
                  .where((e) => e["type"] == "user")
                  .toList()
                  .map((e) => UserModel.fromMap(e))
                  .toList();
              List<AdminModel> adminList = allUsers
                  .where((e) => e["type"] == "admin")
                  .toList()
                  .map((e) => AdminModel.fromMap(e))
                  .toList();
              if (allUsers.isNotEmpty) {
                return ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 30),
                      color: clBG,
                      child: Text(
                        "USERS",
                        style: TextStyle(
                          fontSize: 16,
                          color: clPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: (userList.isNotEmpty)
                          ? Column(
                              children: [
                                for (UserModel e in userList)
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: (e.profileUrl.isNotEmpty)
                                          ? NetworkImage(e.profileUrl)
                                          : null,
                                      child: (e.profileUrl.isEmpty)
                                          ? const Icon(Icons.person)
                                          : null,
                                    ),
                                    title: Text("${e.fName} ${e.lName}"),
                                    subtitle: Text(e.type),
                                    trailing: InkWell(
                                        onTap: () async {
                                          processDialog(context);
                                          await deleteUser(e.id);
                                          Navigator.pop(context);
                                        },
                                        child: const Icon(Icons.delete)),
                                  )
                              ],
                            )
                          : const Center(child: Text("No user found")),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 30),
                      color: clBG,
                      child: Text(
                        "PROVIDERS",
                        style: TextStyle(
                          fontSize: 16,
                          color: clPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: (providerList.isNotEmpty)
                          ? Column(
                              children: [
                                for (ProviderModel e in providerList)
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: (e.profileUrl.isNotEmpty)
                                          ? NetworkImage(e.profileUrl)
                                          : null,
                                      child: (e.profileUrl.isEmpty)
                                          ? const Icon(Icons.person)
                                          : null,
                                    ),
                                    title: Text("${e.fName} ${e.lName}"),
                                    subtitle: Text(e.type),
                                    trailing: InkWell(
                                        onTap: () async {
                                          processDialog(context);
                                          await deleteUser(e.id);
                                          Navigator.pop(context);
                                        },
                                        child: const Icon(Icons.delete)),
                                  )
                              ],
                            )
                          : const Center(child: Text("No provider found")),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 30),
                      color: clBG,
                      child: Text(
                        "ADMINS",
                        style: TextStyle(
                          fontSize: 16,
                          color: clPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: (adminList.isNotEmpty)
                          ? Column(
                              children: [
                                for (AdminModel e in adminList)
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: (e.profileUrl.isNotEmpty)
                                          ? NetworkImage(e.profileUrl)
                                          : null,
                                      child: (e.profileUrl.isEmpty)
                                          ? const Icon(Icons.person)
                                          : null,
                                    ),
                                    title: Text("${e.fName} ${e.lName}"),
                                    subtitle: Text(e.type),
                                  ),
                              ],
                            )
                          : const Text("No admin found"),
                    ),
                  ],
                );
              }
              return const Center(
                child: Text("No Users Found"),
              );
            }
            return const Center(
              child: Text("Something went wrong"),
            );
          }),
    );
  }

  Future<void> deleteUser(String id) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("chatRooms")
        .get();
    List<ChatRoomModel> chatrooms = snapshot.docs
        .map((e) => ChatRoomModel.fromMap(e.data() as Map<String, dynamic>))
        .toList();
    for (ChatRoomModel e in chatrooms) {
      await ChatRoomModel.deleteChatRoom(e);
    }
    QuerySnapshot serviceSnap = await FirebaseFirestore.instance
        .collection("services")
        .where("providerId", isEqualTo: id)
        .get();
    List<ServiceModel> services = serviceSnap.docs
        .map((e) => ServiceModel.fromMap(e.data() as Map<String, dynamic>))
        .toList();
    for (ServiceModel e in services) {
      await FirebaseFirestore.instance
          .collection("services")
          .doc(e.id)
          .delete();
    }
    await FirebaseFirestore.instance.collection("users").doc(id).delete();
  }
}
