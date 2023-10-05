import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/service_model.dart';
import 'package:home_mate/model/user_model.dart';
import 'package:home_mate/screens/providerdetail.dart';
import 'package:home_mate/screens/search.dart';
import 'package:home_mate/screens/servicedetail.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.service,
    required this.width,
  });

  final ServiceModel service;
  final double width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetail(info: service),
          ),
        );
      },
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(service.providerId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> providerMap =
                snapshot.data!.data() as Map<String, dynamic>;
            ProviderModel provider = ProviderModel.fromMap(providerMap);
            return Container(
              width: width,
              height: 320,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: clBG,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          image: DecorationImage(
                            image: (service.coverUrl.isNotEmpty)
                                ? NetworkImage(service.coverUrl)
                                : const AssetImage(
                                        "assets/images/new_service.png")
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 7,
                        left: 7,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchService(
                                  category: service.category,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: clPrimary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Text(
                              service.category,
                              style: TextStyle(
                                fontSize: 12,
                                color: clBG,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 140,
                        right: 7,
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: clPrimary,
                            border: Border.all(color: clBG, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Text(
                            "₹${service.price.toInt().toString()}",
                            style: TextStyle(
                                fontSize: 15,
                                color: clBG,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          printRating(service.rating),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Text(
                              service.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProviderDetails(providerId: provider.id),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      (provider.profileUrl.isNotEmpty)
                                          ? NetworkImage(provider.profileUrl)
                                          : null,
                                  child: (!provider.profileUrl.isNotEmpty)
                                      ? const Icon(Icons.person_outline)
                                      : null,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text("${provider.fName} ${provider.lName}"),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
