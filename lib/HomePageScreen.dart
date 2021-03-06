import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartdelivery/services/Service.dart';
import 'package:smartdelivery/services/fun.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
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
        .where("delivered_by", whereIn: ["not_assigned", _user]).snapshots();

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
                  Center(child: Text("Orders")),
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
                            "New Orders",
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
                            "Picking",
                            style: TextStyle(
                                fontWeight: currentPage == 1
                                    ? FontWeight.w500
                                    : FontWeight.w300),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            pc.jumpToPage(2);
                          },
                          child: Text(
                            "Delivered",
                            style: TextStyle(
                                fontWeight: currentPage == 2
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
                              .where((element) =>
                                  element["delivered_by"] == "not_assigned")
                              .map(
                                (e) => ListTile(
                                  onTap: () {
                                    showOrderDetail(context, e, _user);
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
                            .where((element) =>
                                (element["delivered_by"] == _user &&
                                    element["delivery_Status"] == "new"))
                            .map(
                              (e) => ListTile(
                                onTap: () {
                                  deliveryConfirm(context, e, _user);
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
                      ListView(
                          children: newOrder
                              .where((element) => (element["delivered_by"] ==
                                      _user &&
                                  element["delivery_Status"] == "delivered"))
                              .map(
                                (e) => ListTile(
                                  onTap: () {
                                    //do nothing
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
                    ],
                  ))
                ],
              ),
      ),
    );
  }
}
