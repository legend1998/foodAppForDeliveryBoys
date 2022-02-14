import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartdelivery/App.dart';
import 'package:smartdelivery/LoginScreen.dart';
import 'package:smartdelivery/Permission.dart';
import 'package:smartdelivery/services/Service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  CollectionReference fs = FirebaseFirestore.instance.collection("user");

  @override
  void dispose() {
    super.dispose();
  }

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.

  @override
  void initState() {
    super.initState();
    checkPermision();
  }

  Future notificationSelected(String payload) async {}

  void checkPermision() async {
    if (await PermissionService.getPermission(context)) {
      loadUser();
    }
  }

  loadUser() async {
    var id = await Service.getuserId();

    if (id != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainApp()));
      return;
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset("images/logo.png"),
      ),
    );
  }
}
