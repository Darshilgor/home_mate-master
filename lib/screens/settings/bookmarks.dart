import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/service_model.dart';
import 'package:home_mate/screens/servicedetail.dart';

class Bookmarks extends StatefulWidget {
  const Bookmarks({Key? key}) : super(key: key);

  @override
  State<Bookmarks> createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clBG,
      appBar: AppBar(
        backgroundColor: clPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Favourite Services",style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("bookmarks").snapshots(),
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }
            if(snapshot.hasData){
              List<ServiceModel> services = snapshot.data!.docs.map((e) => ServiceModel.fromMap(e.data())).toList();
              if(services.isNotEmpty){
                return Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      for (ServiceModel e in services)
                        ListTile(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceDetail(info: e)));
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: (e.coverUrl.isNotEmpty)?Image.network(e.coverUrl):const Icon(Icons.home_repair_service),
                          ),
                          title: Text(e.name),
                          subtitle: Text(e.category),
                          trailing: InkWell(
                              onTap: () async {
                                processDialog(context);
                                await updateBookmarks(e, user);
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.delete)),
                        ),
                    ],
                  )

                );
              }
              return const Center(child: Text("Empty"),);

            }
            return const Center(child: Text("Something went wrong"),);
          }
      ),
    );
  }
}
