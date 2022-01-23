import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartdelivery/OtpVerfication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void goForotpVerification() {
    final FormState form = _formKey.currentState!;
    if (form.validate()) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  OtpVerification(phone: _phoneController.value.text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: 100,
          ),
          Container(
            child: Image.asset("images/loginpage.png"),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "LOGIN",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Enter your phone number to proceed",
              style: TextStyle(color: Colors.black54),
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                  key: _formKey,
                  child: TextFormField(
                      maxLength: 10,
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        value = value!.trim();
                        if (value.isNotEmpty) {
                          print(value);
                          RegExp regexp = new RegExp(r'^[6-9][0-9]{9}');
                          if (!regexp.hasMatch(value)) {
                            return "not valid phone number";
                          } else {
                            return null;
                          }
                        } else
                          return "enter phone number";
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.grey[100],
                        filled: true,
                        hintText: "phone number",
                        border: OutlineInputBorder(),
                      )))),
          Container(),
          Container(
            child: ElevatedButton(
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                child: Text("Login"),
              ),
              onPressed: () {
                //do nothing
                goForotpVerification();
              },
            ),
          ),
        ],
      )),
    );
  }
}
