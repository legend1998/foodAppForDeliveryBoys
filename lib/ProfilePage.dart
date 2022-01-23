import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartdelivery/services/fun.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndexForBottomNavigationBar = 3;
  void _onItemTappedForBottomNavigationBar(index) {
    if (index != 3) onItemTappedForBottomNavigationBar(index, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 20,
        unselectedFontSize: 10,
        selectedFontSize: 12,

        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          _onItemTappedForBottomNavigationBar(value);
        }, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(icon: new Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: new Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
              icon: new Icon(Icons.shopping_basket), label: "Cart"),
          BottomNavigationBarItem(
              icon: new Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedIndexForBottomNavigationBar,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(),
        ),
      ),
    );
  }
}
