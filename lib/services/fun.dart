import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sms_autofill/sms_autofill.dart';

void showOrderDetail(context, order, String userid) {
  var date = DateTime.parse(order["orderTime"]);
  var time = DateFormat('dd/mm – kk:mm').format(date);
  List items = order["ordersTotal"] ?? [];

  showModalBottomSheet(
      context: context,
      builder: (context) => Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 220,
                        margin: EdgeInsets.only(top: 10, right: 10),
                        child: Text(
                          order["pinCode"] + " " + order["address"].toString(),
                          maxLines: 3,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, right: 10),
                        child: Text(
                          '$time',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Are you sure want to deliver this.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    child: ListView(
                  shrinkWrap: true,
                  children: items
                      .map((it) => Container(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  child: CachedNetworkImage(
                                    imageUrl: it["imageUrl"],
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        it["name"],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(it["quantity"].toString()),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(it["unit"]),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ))
                      .toList(),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black)),
                          child: Text("No"),
                          onPressed: () {
                            //do nothing
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          child: Text("Yes"),
                          onPressed: () async {
                            //do nothing
                            await FirebaseFirestore.instance
                                .collection("orders")
                                .doc(order["id"])
                                .update({"delivered_by": userid});
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ));
}

Future<bool> confirmPin(order, pin) async {
  if (order["code"] == pin) {
    return await FirebaseFirestore.instance
        .collection("orders")
        .doc(order["id"])
        .update({"delivery_Status": "delivered"})
        .then((value) => true)
        .catchError((onError) => false);
  } else
    return Future.value(false);
}

void deliveryConfirm(context, order, String userid) {
  TextEditingController pinController = TextEditingController();
  var date = DateTime.parse(order["orderTime"]);
  var time = DateFormat('dd/mm – kk:mm').format(date);

  showModalBottomSheet(
      context: context,
      builder: (context) => Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 220,
                        margin: EdgeInsets.only(top: 10, right: 10),
                        child: Text(
                          order["pinCode"] + " " + order["address"].toString(),
                          maxLines: 3,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, right: 10),
                        child: Text(
                          '$time',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Reach out to the User and ask for Deliver Code",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Enter delivery Code",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                  child: PinInputTextField(
                    controller: pinController,
                    pinLength: 4,
                    onChanged: (value) {
                      if (value.length == 4) {
                        confirmPin(order, value);
                      }
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    child: Text("Done"),
                    onPressed: () async {
                      //do nothing
                      if (await confirmPin(order, pinController.text)) {
                        Navigator.pop(context);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Wrong pin entered.",
                            toastLength: Toast.LENGTH_LONG);
                        pinController.text = "";
                      }
                    },
                  ),
                )
              ],
            ),
          ));
}

void afterDelivery(context, order) {
  var date = DateTime.parse(order["orderTime"]);
  var time = DateFormat('dd/mm – kk:mm').format(date);

  showModalBottomSheet(
      context: context,
      builder: (context) => Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 220,
                        margin: EdgeInsets.only(top: 10, right: 10),
                        child: Text(
                          order["pinCode"] + " " + order["address"].toString(),
                          maxLines: 3,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, right: 10),
                        child: Text(
                          '$time',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Text(order["ordered_by"]),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "This order is delivered successFully",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    child: Text("Okay"),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ));
}
