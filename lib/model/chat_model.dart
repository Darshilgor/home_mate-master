import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ChatRoomModel {
  String chatId;
  String userId;
  String anotherUserId;
  String lastMsg;

  ChatRoomModel({
    required this.chatId,
    required this.userId,
    required this.anotherUserId,
    required this.lastMsg,
  });

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) => ChatRoomModel(
        chatId: map['chatId'],
        userId: map['userId'],
        anotherUserId: map['anotherUserId'],
        lastMsg: map['lastMsg'],
      );

  Map<String, dynamic> toMap() => {
        "chatId": chatId,
        "userId": userId,
        "anotherUserId": anotherUserId,
        "lastMsg": lastMsg,
      };

  static Future<ChatRoomModel> createChatroom(String currentUserId,String anotherUserId)async {
    String uniqueId = const Uuid().v1();
    ChatRoomModel currentUserChatRoom = ChatRoomModel(chatId: uniqueId, userId: currentUserId, anotherUserId: anotherUserId, lastMsg: "");
    ChatRoomModel anotherUserChatRoom = ChatRoomModel(chatId: uniqueId, userId: anotherUserId, anotherUserId: currentUserId, lastMsg: "");
    await FirebaseFirestore.instance.collection("users").doc(currentUserId).collection("chatRooms").doc(uniqueId).set(currentUserChatRoom.toMap());
    await FirebaseFirestore.instance.collection("users").doc(anotherUserId).collection("chatRooms").doc(uniqueId).set(anotherUserChatRoom.toMap());
    return currentUserChatRoom;
  }

  static Future<void> updateLastMessage(String lastMessage,ChatRoomModel chatroom)async{
    await FirebaseFirestore.instance.collection("users").doc(chatroom.userId).collection("chatRooms").doc(chatroom.chatId).update({
      "lastMsg":lastMessage,
    });
    await FirebaseFirestore.instance.collection("users").doc(chatroom.anotherUserId).collection("chatRooms").doc(chatroom.chatId).update({
      "lastMsg":lastMessage,
    });
  }

  static Future<void> deleteChatRoom(ChatRoomModel chatroom)async{
    if(chatroom.userId != chatroom.anotherUserId){
      await FirebaseFirestore.instance.collection("users").doc(chatroom.userId).collection("chatRooms").doc(chatroom.chatId).delete();
      await FirebaseFirestore.instance.collection("users").doc(chatroom.anotherUserId).collection("chatRooms").doc(chatroom.chatId).delete();
    }else{
      await FirebaseFirestore.instance.collection("users").doc(chatroom.userId).collection("chatRooms").doc(chatroom.chatId).delete();

    }

  }
}
