import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smartdelivery/LoginScreen.dart';
import 'package:smartdelivery/data/AppUser.dart';
import 'package:smartdelivery/services/Service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AppUser _user;
  bool loading = true;
  void loadData() async {
    _user = await Service.getuser();
    this.setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                      height: 300,
                      color: Colors.red,
                      width: MediaQuery.of(context).size.width,
                      child: _user.imageUrl == null
                          ? Image(
                              fit: BoxFit.cover,
                              image: AssetImage("images/logo.png"))
                          : CachedNetworkImage(
                              imageUrl: _user.imageUrl!,
                            )),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (route) => false);
                    },
                    subtitle: Text("log out from this app"),
                    title: Text("Log Out"),
                  ),
                ],
              ),
      ),
    );
  }
}
