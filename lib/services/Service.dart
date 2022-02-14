import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nanoid/async.dart';
import 'package:smartdelivery/data/AppUser.dart';

class Service {
  static Future<String?> createOrSignInUserUsingPhone(User user) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var box = await Hive.openBox('testBox');

      CollectionReference users = firestore.collection("user");

      QuerySnapshot result;

      result = await users.where('phone', isEqualTo: user.phoneNumber).get();
      print(result);
      if (result.docs.isEmpty) {
        var uid = "user_" + await nanoid(8);
        AppUser appuser = AppUser(
            name: user.displayName!,
            email: user.email!,
            imageUrl: user.photoURL!,
            favorite: [],
            phone: user.phoneNumber!,
            joinDate: DateTime.now(),
            id: uid);

        await users.doc(uid).set(appuser.userAsMap());

        var userid = (await users.doc(uid).get()).id;
        box.put('userid', userid);

        return "new";
      } else {
        print(user.phoneNumber);
        var doc = result.docs[0];
        print(doc.id);
        await box.put('userid', doc.id);

        return "old";
      }
    } catch (e) {
      print(e);
      return "error";
    }
  }

  static Future<dynamic> getuserId() async {
    var box = await Hive.openBox('testBox');
    var userid = await box.get('userid');
    return userid;
  }

  static Future<AppUser> getuser() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference users = firestore.collection("user");
      var box = await Hive.openBox('testBox');
      var userid = await box.get('userid');
      Map<String, dynamic> data = await users
          .doc(userid)
          .get()
          .then((value) => value.data() as Map<String, dynamic>);
      return AppUser.userFromMap(data);
    } catch (e) {
      print(e);
      throw Error();
    }
  }
}
