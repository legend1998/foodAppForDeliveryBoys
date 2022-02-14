import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartdelivery/services/Service.dart';
import 'package:smartdelivery/services/fun.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({Key? key}) : super(key: key);

  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  PageController pc = PageController();
  int currentPage = 0;
  List newOrder = [];
  late String _user;
  bool loading = true;
  late StreamSubscription cancelStream;

  void loaddata() async {
    _user = await Service.getuserId();
    //restaurantId
    var orderStream = FirebaseFirestore.instance
        .collection("orders")
        .where("delivered_by", isEqualTo: _user)
        .where("delivery_Status", isEqualTo: "delivered")
        .snapshots();

    cancelStream = orderStream.listen((event) {
      print(event.docs.length);
      this.setState(() {
        newOrder = event.docs.map((e) => {"id": e.id, ...e.data()}).toList();
      });
    });
    this.setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    cancelStream.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loaddata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(10),
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Center(child: Text("Deliveries")),
                  Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            pc.jumpToPage(0);
                          },
                          child: Text(
                            "Today",
                            style: TextStyle(
                                fontWeight: currentPage == 0
                                    ? FontWeight.w500
                                    : FontWeight.w300),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            pc.jumpToPage(1);
                          },
                          child: Text(
                            "All",
                            style: TextStyle(
                                fontWeight: currentPage == 1
                                    ? FontWeight.w500
                                    : FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Flexible(
                      child: PageView(
                    controller: pc,
                    onPageChanged: (pageNUmber) {
                      this.setState(() {
                        currentPage = pageNUmber;
                      });
                      print(currentPage);
                    },
                    scrollDirection: Axis.horizontal,
                    children: [
                      ListView(
                          children: newOrder
                              .where((element) {
                                var today =
                                    DateTime.parse(element["orderTime"]);
                                var oldtime = DateTime.now();

                                oldtime = new DateTime(
                                    oldtime.year, oldtime.month, oldtime.day);
                                if (oldtime.difference(today).inMinutes > 0)
                                  return true;
                                else
                                  return false;
                              })
                              .map(
                                (e) => ListTile(
                                  onTap: () {
                                    afterDelivery(context, e);
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        e["ordersTotal"][0]["imageUrl"]),
                                  ),
                                  subtitle: Text("items : " +
                                      e["ordersTotal"].length.toString()),
                                  title: Text(e["ordered_by"]),
                                ),
                              )
                              .toList()),
                      ListView(
                        children: newOrder
                            .map(
                              (e) => ListTile(
                                onTap: () {
                                  afterDelivery(context, e);
                                },
                                leading: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      e["ordersTotal"][0]["imageUrl"]),
                                ),
                                subtitle: Text("items : " +
                                    e["ordersTotal"].length.toString()),
                                title: Text(e["ordered_by"]),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ))
                ],
              ),
      ),
    );
  }
}
