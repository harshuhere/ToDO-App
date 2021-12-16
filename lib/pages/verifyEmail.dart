import 'dart:async';

import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:todo_with_firebase/pages/homePage.dart';
import 'package:todo_with_firebase/pages/loginPage.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key, required this.email}) : super(key: key);
  final String email;
  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool submitValid = false;
  TextEditingController otpcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  final _otpKey = GlobalKey<FormState>();
  EmailAuth? emailAuth;
  bool verified = false;
  int start = 45;
  late Timer timer;
  bool isTimetoResend = false;
  bool isldng = false;

  @override
  void initState() {
    super.initState();
    startTimer();
    emailAuth = new EmailAuth(
      sessionName: "Sample session",
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void verify() {
    verified = emailAuth!.validateOtp(
        recipientMail: widget.email, userOtp: otpcontroller.value.text);
  }

  /// a void funtion to send the OTP to the user
  /// Can also be converted into a Boolean function and render accordingly for providers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Icon(
                              Icons.email_outlined,
                              size: 70,
                              color: Color(0xFF00abff),
                              // Colors.black87.withOpacity(0.4),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0, top: 20),
                            child: Text(
                              "Verify your email",
                              style: TextStyle(
                                  color: Color(0xFF00abff),
                                  //Colors.black87.withOpacity(0.4),
                                  fontSize: 25,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 30, 30, 50),
                    margin: EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black87.withOpacity(0.3),
                            blurRadius: 14,
                            offset: Offset(5, 5),
                          ),
                        ]),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey,
                                margin: EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                            Text(
                              "Enter 6 digit OTP",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w300),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey,
                                margin: EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _otpKey,
                          child: Container(
                            child: PinCodeTextField(
                              appContext: context,
                              pastedTextStyle: TextStyle(
                                color: Colors.transparent,
                                fontWeight: FontWeight.bold,
                              ),
                              length: 6,
                              obscureText: false,
                              blinkWhenObscuring: true,
                              animationType: AnimationType.fade,
                              validator: (v) {
                                if (v!.length < 6) {
                                  return " *Enter 6 digit OTP";
                                } else {
                                  return null;
                                }
                              },
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(10),
                                fieldHeight: 42,
                                fieldWidth: 42,
                                borderWidth: 1,
                                //
                                activeColor: Colors.black.withOpacity(0.5),
                                activeFillColor: Colors.white70,
                                //
                                inactiveColor: Colors.black.withOpacity(0.5),
                                inactiveFillColor: Colors.transparent,
                                //
                                selectedFillColor: Colors.transparent,
                                errorBorderColor: Colors.black87,
                              ),
                              cursorColor: Colors.black,
                              animationDuration: Duration(milliseconds: 300),
                              enableActiveFill: true,
                              controller: otpcontroller,
                              keyboardType: TextInputType.number,
                              onCompleted: (v) {
                                print("Completed+${otpcontroller.text}");
                              },
                              onChanged: (value) {
                                print(value);
                              },
                              beforeTextPaste: (text) {
                                print("Allowing to paste $text");
                                return true;
                              },
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            verify();
                            verified
                                ? Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => HomePage()),
                                    (route) => false)
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Wrong OTP")));
                          },
                          child: Container(
                            height: 45,
                            width: 150,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  // Colors.grey.withOpacity(0),
                                  // Colors.black.withOpacity(0.5),
                                  Color(0xff6bceff),
                                  Color(0xFF00abff),
                                ],
                              ),
                              border: Border.all(
                                  color: Colors.black87.withOpacity(0.05)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            padding: EdgeInsets.only(right: 10),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '  Verify',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            child: isTimetoResend
                                ? InkWell(
                                    onTap: () async {
                                      setState(() {
                                        isldng = true;
                                      });
                                      try {
                                        await sendOtp().whenComplete(() {
                                          setState(() {
                                            isldng = false;
                                            isTimetoResend = false;
                                          });

                                          startTimer();
                                        });
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(e.toString())));
                                      }
                                    },
                                    child: isldng
                                        ? CircularProgressIndicator(
                                            color: Colors.blue,
                                          )
                                        : Text(
                                            "Resend OTP",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                  )
                                : RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Send OTP again in ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color:
                                                  // wait
                                                  //     ? Colors.black87
                                                  //     :
                                                  Colors.black,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        TextSpan(
                                          text: "00:$start",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color:
                                                  // wait
                                                  //     ? Colors.black87
                                                  //     :
                                                  Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: " sec.",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                              // wait
                                              //     ? Colors.black87
                                              //     : Colors.transparent,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () async {
                      if (FirebaseAuth.instance.currentUser != null) {
                        await FirebaseAuth.instance.currentUser?.delete();
                      }
                      timer.cancel();
                      // Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (builder) => LoginPage()),
                          (route) => false);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Back to ",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 13),
                        ),
                        Text(
                          "Sign in ",
                          style: TextStyle(
                              color: Color(0xFF00abff),
                              fontWeight: FontWeight.w300,
                              fontSize: 15),
                        ),
                        Text(
                          "page ?",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendOtp() async {
    bool result =
        await emailAuth!.sendOtp(recipientMail: widget.email, otpLength: 6);
    if (result) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("OTP Sent.")));
    }
  }

  void startTimer() {
    timer = new Timer(const Duration(seconds: 45), () {
      setState(() {});
    });

    // ignore: unused_local_variable
    Timer _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (start == 0) {
        if (mounted) {
          setState(() {
            isTimetoResend = true;
            timer.cancel();
            start = 45;
          });
        } else {}
      } else {
        if (mounted) {
          setState(() {
            start--;
            isTimetoResend = false;
          });
        }
      }
    });
  }
}
