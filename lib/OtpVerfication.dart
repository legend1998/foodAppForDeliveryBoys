import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartdelivery/App.dart';
import 'package:smartdelivery/services/Service.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({Key? key, required this.phone}) : super(key: key);
  final String phone;

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> with CodeAutoFill {
  FirebaseAuth auth = FirebaseAuth.instance;
  String otp = "";
  String? signature;
  bool istimeout = false;
  int step = 1;
  String? _verificationId;

  _signInWithPhoneNumber() async {
    this.setState(() {
      istimeout = false;
    });
    await auth.signOut();
    await auth.verifyPhoneNumber(
      phoneNumber: "+91" + widget.phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await auth.signInWithCredential(credential).then((value) async {
            return;
          });
        } catch (e) {
          print(e);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        print("CODE SENT");
        this.setState(() {
          _verificationId = verificationId;
          step = 2;
        });
        Fluttertoast.showToast(msg: "Otp sent");
      },
      codeAutoRetrievalTimeout: (String verificationId) async {
        this.setState(() {
          _verificationId = verificationId;
          istimeout = true;
          step = 3;
        });
        return;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    listenForCode();

    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        signature = signature;
      });
    });
    auth.setSettings(appVerificationDisabledForTesting: true);
    _signInWithPhoneNumber();
  }

  @override
  void dispose() {
    super.dispose();
    cancel();
  }

  void confirmotp(pin) async {
    try {
      await auth
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: _verificationId!, smsCode: pin))
          .then((value) async {
        print("CALLING THIS METHOD VERIFICATION");
        String? result =
            await Service.createOrSignInUserUsingPhone(value.user!);
        if (result != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainApp()));
        } else {
          print(result);
          Fluttertoast.showToast(msg: "error login with this phone number");
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(10),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Image.asset(
              "images/Header.png",
              height: 200,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "OTP Verification",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
                      children: [
                        TextSpan(text: "Enter the Otp sent to : "),
                        TextSpan(
                            text: widget.phone.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ]),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: PinFieldAutoFill(
                decoration: BoxLooseDecoration(
                  textStyle: TextStyle(fontSize: 20, color: Colors.pink),
                  strokeColorBuilder:
                      PinListenColorBuilder(Colors.pink, Colors.black),
                ),
                currentCode: otp,
                onCodeSubmitted: (code) {
                  confirmotp(code);
                },
                onCodeChanged: (code) {
                  if (code!.length == 6) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    confirmotp(code);
                  }
                },
              ),
            ),
            Container(
                height: 50,
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(top: 0, right: 10),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("didn't recieve the code ? "),
                    TextButton(
                        onPressed: () {
                          if (!istimeout) return;
                          _signInWithPhoneNumber();
                        },
                        child: Text(
                          "resend OTP",
                          style: TextStyle(
                              color: istimeout ? Colors.red : Colors.red[200]),
                        )),
                  ],
                ))
          ],
        )),
      ),
    );
  }

  @override
  void codeUpdated() {
    setState(() {
      otp = code!;
    });
  }
}
