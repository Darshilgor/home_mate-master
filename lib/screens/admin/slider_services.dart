import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/service_model.dart';

class SliderServices extends StatefulWidget {
  const SliderServices({Key? key}) : super(key: key);

  @override
  State<SliderServices> createState() => _SliderServices();
}

class _SliderServices extends State<SliderServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("services").snapshots(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            if(snapshot.hasData){
              List<ServiceModel> serviceList = snapshot.data!.docs.map((e) => ServiceModel.fromMap(e.data())).toList();
              if(serviceList.isNotEmpty){
                List<ServiceModel> sliderServices = serviceList.where((element) => element.isSlider == true).toList();
                serviceList.removeWhere((element) => element.isSlider == true);
                return ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 30),
                      color: clBG,
                      child: Text(
                        "SLIDER SERVICES",
                        style: TextStyle(
                          fontSize: 16,
                          color: clPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: (sliderServices.isNotEmpty)?Column(
                        children: [
                          for(ServiceModel e in sliderServices)
                            ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: (e.coverUrl.isNotEmpty)?Image.network(e.coverUrl):const Icon(Icons.home_repair_service),
                              ),
                              title: Text(e.name),
                              subtitle: Text(e.category),
                              trailing: InkWell(
                                  onTap: ()async{
                                    processDialog(context);
                                    try{
                                      await FirebaseFirestore.instance.collection("services").doc(e.id).update({
                                        "isSlider":false,
                                      });
                                      Navigator.pop(context);
                                    } on FirebaseException catch(e){
                                      snackMessage(context, e.message!);
                                      Navigator.pop(context);

                                    }
                                  },
                                  child: const Icon(Icons.remove)),
                            ),
                        ],
                      ): const Center(child:Text("No Slider Services Found")),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 30),
                      color: clBG,
                      child: Text(
                        "ADD SLIDER SERVICES",
                        style: TextStyle(
                          fontSize: 16,
                          color: clPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: (serviceList.isNotEmpty)?Column(
                        children: [
                          for(ServiceModel e in serviceList)
                            ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: (e.coverUrl.isNotEmpty)?Image.network(e.coverUrl):const Icon(Icons.home_repair_service),
                              ),
                              title: Text(e.name),
                              subtitle: Text(e.category),
                              trailing: InkWell(
                                  onTap: ()async{
                                    processDialog(context);
                                    try{
                                      await FirebaseFirestore.instance.collection("services").doc(e.id).update({
                                        "isSlider":true,
                                      });
                                      Navigator.pop(context);
                                    } on FirebaseException catch(e){
                                      snackMessage(context, e.message!);
                                      Navigator.pop(context);

                                    }
                                  },
                                  child: const Icon(Icons.add)),
                            ),
                        ],
                      ):const Center(child: Text("All Services is in Slider")),
                    ),

                  ],
                );

              }
              return const Center(child: Text("No Services Found"),);
            }
            return const Center(child: Text("Something went wrong"),);

          }),
    );
  }
}
