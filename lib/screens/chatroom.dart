import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/chat_model.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatRoom extends StatefulWidget {
  final ChatRoomModel chatroom;
  const ChatRoom({Key? key, required this.chatroom}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  late DatabaseReference ref;
  late User? user;
  TextEditingController message = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref = FirebaseDatabase.instance.ref("chats/${widget.chatroom.chatId}");
    user = FirebaseAuth.instance.currentUser;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clBG,
      appBar: AppBar(
        titleSpacing: 1,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: clPrimary,
        title: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(widget.chatroom.anotherUserId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Row(
                  children: [
                    CircleAvatar(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  ],
                );
              }
              Map<String, dynamic> userMap =
                  snapshot.data!.data() as Map<String, dynamic>;
              String profileUrl = userMap["profileUrl"];
              String fName = userMap["fName"];
              String lName = userMap["lName"];

              return Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: (profileUrl.isNotEmpty)
                        ? NetworkImage(profileUrl)
                        : null,
                    child: (profileUrl.isEmpty)
                        ? const Icon(Icons.person_outline)
                        : null,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "$fName $lName",
                    style: const TextStyle(color: Colors.white,fontSize: 18),
                  ),
                ],
              );
            }),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/chatbg.png"),
                fit: BoxFit.cover)),
        child: Column(
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                  query: ref,
                  defaultChild: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  itemBuilder: (context, snapshot, animation, index) =>
                      messageFromSnapshot(snapshot, animation)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.only(bottom: 15, right: 12, left: 12),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: message,
                      maxLines: null,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "Message"),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (message.text.isNotEmpty) {
                        String? newPostKey = ref.push().key;
                        await ref.child(newPostKey!).set({
                          "type": "text",
                          "message": message.text.trim(),
                          "time": DateTime.now().toIso8601String(),
                          "senderId": user!.uid,
                          "key": newPostKey,
                        });
                        await ChatRoomModel.updateLastMessage(
                            message.text.trim(), widget.chatroom);

                        message.clear();
                        setState(() {});
                      }
                    },
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageFromSnapshot(
    DataSnapshot snapshot,
    Animation<double> animation,
  ) {
    final val = snapshot.value;
    if (val == null) {
      return Container();
    }
    final json = val as Map;
    String senderId = val['senderId'];
    String message = val['message'];
    String messageType = val['type'];
    DateTime? time = DateTime.tryParse(val['time']) ?? DateTime.now();
    String printTime = "${time.hour}:${time.minute}";
    String key = val['key'];
    bool isSender = user!.uid == senderId;
    Color textColor = (isSender) ? Colors.white : Colors.black;
    Color backgroundColor = (isSender) ? clPrimary : Colors.white;
    Alignment alignment =
        (isSender) ? Alignment.bottomRight : Alignment.bottomLeft;
    final messageUI = Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            Text(
              printTime,
              style: TextStyle(fontSize: 12, color: textColor),
            ),
          ],
        ),
      ),
    );
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animation,
        curve: Curves.easeIn,
      ),
      child: messageUI,
    );
  }
}
