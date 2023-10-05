import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/chat_model.dart';
import 'package:home_mate/screens/chat_search.dart';
import 'package:home_mate/screens/chatroom.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late User? user;
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          backgroundColor: clContainer,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ChatSearch()));
          },
          child: Icon(
            Icons.chat,
            color: clPrimary,
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: clPrimary,
        title: const Text(
          "Chat",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(user!.uid)
              .collection("chatRooms")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              List<ChatRoomModel> chatList = snapshot.data!.docs
                  .map((e) => ChatRoomModel.fromMap(e.data()))
                  .toList();
              if (chatList.isNotEmpty) {
                return ListView.builder(
                  itemCount: chatList.length,
                  itemBuilder: (context, index) => StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(chatList[index].anotherUserId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        Map<String, dynamic> userMap =
                            snapshot.data!.data() as Map<String, dynamic>;
                        String profileUrl = userMap["profileUrl"];
                        String fName = userMap["fName"];
                        String lName = userMap["lName"];
                        String lastMsg = chatList[index].lastMsg;
                        if(lastMsg.isNotEmpty){
                          return ListTile(

                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChatRoom(chatroom: chatList[index])));
                            },
                            tileColor: clContainer,
                            leading: CircleAvatar(
                              backgroundImage: (profileUrl.isNotEmpty)
                                  ? NetworkImage(profileUrl)
                                  : null,
                              child: (profileUrl.isEmpty)
                                  ? const Icon(Icons.person_outline)
                                  : null,
                            ),
                            title: Text("$fName $lName"),
                            subtitle: (lastMsg.isNotEmpty)?Text(lastMsg):null,
                          );
                        }
                        return const SizedBox();
                      }
                      return const Center(
                        child: Text("Error Loading User Data"),
                      );
                    },
                  ),
                );
              }
              return const Center(
                child: Text("No Chat Found"),
              );
            }
            return const Center(
              child: Text("Something Went Wrong"),
            );
          },
        ),
      ),
    );
  }
}
