// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/chat_model.dart';
import 'package:home_mate/model/user_model.dart';
import 'package:home_mate/screens/chatroom.dart';
import 'package:uuid/uuid.dart';

class ChatSearch extends StatefulWidget {
  const ChatSearch({Key? key}) : super(key: key);

  @override
  State<ChatSearch> createState() => _ChatSearchState();
}

class _ChatSearchState extends State<ChatSearch> {
  TextEditingController search = TextEditingController();
  String query = "";
  late User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Chat Search",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            height: 60,
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: clBG,
            ),
            child: TextField(
              controller: search,
              onChanged: (value) {
                setState(() {
                  query = value.trim();
                });
              },
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.black),
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder(
                stream: (query.isNotEmpty)
                    ? FirebaseFirestore.instance
                        .collection("users")
                        .where("type", isEqualTo: "provider")
                        .orderBy("fName")
                        .startAt([
                        query.trim(),
                      ]).endAt([
                        query.trim() + '\uf8ff',
                      ]).snapshots()
                    : FirebaseFirestore.instance
                        .collection("users")
                        .where("type", isEqualTo: "provider")
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    List<ProviderModel> userList = snapshot.data!.docs
                        .map((e) => ProviderModel.fromMap(e.data()))
                        .toList();
                    if (type == "provider"){
                      userList.removeWhere((element) => element.id == providerUser.id);
                    }
                    if (userList.isNotEmpty) {
                      return usersList(userList);
                    }
                    return const Center(
                      child: Text("No User Found"),
                    );
                  }
                  return const Center(
                    child: Text("Something Went Wrong"),
                  );
                }),
          )
        ],
      ),
    );
  }

  ListView usersList(List<ProviderModel> userList) {
    return ListView.builder(
      itemCount: userList.length,
      itemBuilder: (context, index) {
        String userId = userList[index].id;
        String profileUrl = userList[index].profileUrl;
        String fName = userList[index].fName;
        String lName = userList[index].lName;
        return ListTile(
          onTap: () async {
            QuerySnapshot snapshot = await FirebaseFirestore.instance
                .collection("users")
                .doc(userId)
                .collection("chatRooms")
                .get();
            if (snapshot.docs.isNotEmpty) {
              List<ChatRoomModel> chatRoomList = snapshot.docs
                  .map((e) =>
                      ChatRoomModel.fromMap(e.data() as Map<String, dynamic>))
                  .toList()
                  .where((element) => element.anotherUserId == user!.uid)
                  .toList();
              if (chatRoomList.isNotEmpty && chatRoomList.length == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChatRoom(chatroom: chatRoomList[0])));
              } else {
                ChatRoomModel newChatRoom = await ChatRoomModel.createChatroom(
                    user!.uid, userList[index].id);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChatRoom(chatroom: newChatRoom)));
              }
            } else {
              ChatRoomModel newChatRoom = await ChatRoomModel.createChatroom(user!.uid, userList[index].id);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChatRoom(chatroom: newChatRoom)));
            }
          },
          tileColor: clContainer,
          leading: CircleAvatar(
            backgroundImage:
                (profileUrl.isNotEmpty) ? NetworkImage(profileUrl) : null,
            child:
                (profileUrl.isEmpty) ? const Icon(Icons.person_outline) : null,
          ),
          title: Text("$fName $lName"),
        );
      },
    );
  }
}
