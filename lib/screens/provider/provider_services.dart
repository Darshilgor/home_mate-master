import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/model/service_model.dart';
import 'package:home_mate/widgets/services_card.dart';

class ProviderServices extends StatefulWidget {
  const ProviderServices({Key? key}) : super(key: key);

  @override
  State<ProviderServices> createState() => _ProviderServicesState();
}

class _ProviderServicesState extends State<ProviderServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 10),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("services").where("providerId",isEqualTo: providerUser.id).snapshots(),
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              if(snapshot.hasData){
                List<ServiceModel> serviceList = snapshot.data!.docs.map((e) => ServiceModel.fromMap(e.data())).toList();
                if(serviceList.isNotEmpty){
                  return ListView.builder(
                      itemCount: serviceList.length,
                      itemBuilder: (context,index)=>ServiceCard(service: serviceList[index], width: MediaQuery.of(context).size.width)
                  );
                }
                return Center(child: Text("No Services Found"),);
              }
              return Center(child: Text("Something went wrong"),);

            }),
      ),
    );
  }
}
