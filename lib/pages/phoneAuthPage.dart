import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:todo_with_firebase/services/authService.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({Key? key}) : super(key: key);

  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final _numberKey = GlobalKey<FormState>();
  final _otpKey = GlobalKey<FormState>();

  bool wait = false;
  bool waits = false;
  bool isLoading = false;
  bool pressed = false;
  bool letsgoprogress = false;
  String buttonName = "Send";
  late Timer timer;
  int start = 45;
  bool otpsend = false;
  String finalverificationID = "";
  String smsCode = "";
  var currentuser = FirebaseAuth.instance.currentUser;
  bool isAnnon = false;
  TextEditingController otpcontroller = TextEditingController();
  TextEditingController phonenumbercontroller = TextEditingController();
  AuthClass authclass = AuthClass();
  final phStorage = FlutterSecureStorage();

  @override
  void initState() {
    getcurrentUser();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> getcurrentUser() async {
    var currentUuser = FirebaseAuth.instance.currentUser;
    if (currentuser != null) {
      if (currentUuser!.isAnonymous) {
        setState(() {
          isAnnon = true;
        });
      } else {
        setState(() {
          isAnnon = false;
        });
      }
    } else {
      isAnnon = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            // take stack here for center all data in singlechildscrollview
            children: [
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.phone_android,
                                size: 90,
                                color: Color(0xFF00abff),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, top: 10),
                                child: Text(
                                  "OTP Verification",
                                  style: TextStyle(
                                      color: Color(0xFF00abff),
                                      fontSize: 30,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black87.withOpacity(0.3),
                                  blurRadius: 14,
                                  offset: Offset(5, 5),
                                ),
                              ]),
                          child: Form(
                            key: _numberKey,
                            child: Column(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  child: TextFormField(
                                    controller: phonenumbercontroller,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10)
                                    ],
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w300),
                                    validator: (valuee) {
                                      if (valuee == null || valuee.isEmpty) {
                                        return "  *Enter Number";
                                      }
                                      if (valuee.length < 10) {
                                        return "*Enter 10 digit Number";
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      hintText: "Enter your phone Number",
                                      hintStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 19, horizontal: 10),
                                      prefixIcon: Container(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14, horizontal: 0),
                                          child: Text(
                                            " +91-",
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: waits
                                      ? null
                                      : () async {
                                          if (_numberKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              waits = true;
                                              isLoading = true;
                                            });
                                            isAnnon
                                                ? await _sendOtpToConvertedNumber()
                                                : await _sendOtpToNumber();
                                          } else {
                                            setState(() {
                                              waits = false;
                                              isLoading = false;
                                            });
                                            ScaffoldMessenger.of(context)
                                                .clearSnackBars();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Enter valid Input")));
                                          }
                                        },
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    width: 100,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xff6bceff),
                                            Color(0xFF00abff),
                                          ],
                                        ),
                                        border: Border.all(
                                            color: Colors.black87
                                                .withOpacity(0.1)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    child: Center(
                                      child: isLoading
                                          ? Container(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ))
                                          : Text(
                                              buttonName,
                                              style: TextStyle(
                                                  color: waits
                                                      ? Colors.white
                                                          .withOpacity(0.5)
                                                      : Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                otpsend
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              color: Colors.grey,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 12),
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
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 12),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 20,
                                ),
                                otpsend
                                    ? Form(
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              fieldHeight: 45,
                                              fieldWidth: 45,
                                              borderWidth: 1,
                                              //
                                              activeColor:
                                                  Colors.black.withOpacity(0.5),
                                              activeFillColor: Colors.white70,
                                              //
                                              inactiveColor:
                                                  Colors.black.withOpacity(0.5),
                                              inactiveFillColor:
                                                  Colors.transparent,
                                              //
                                              selectedFillColor:
                                                  Colors.transparent,
                                              errorBorderColor: Colors.black87,
                                            ),
                                            cursorColor: Colors.black,
                                            animationDuration:
                                                Duration(milliseconds: 300),
                                            enableActiveFill: true,
                                            controller: otpcontroller,
                                            keyboardType: TextInputType.number,
                                            onCompleted: (v) {
                                              print(
                                                  "Completed+${otpcontroller.text}");
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
                                      )
                                    : Container(),
                                otpsend
                                    ? wait
                                        ? RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Send OTP again in ",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: wait
                                                          ? Colors.black87
                                                          : Colors.transparent,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                TextSpan(
                                                  text: "00:$start",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: wait
                                                          ? Colors.black87
                                                          : Colors.transparent,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text: " sec.",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black87,
                                                      // wait
                                                      //     ? Colors.black87
                                                      //     : Colors.transparent,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container()
                                    : Container(),
                                otpsend
                                    ? InkWell(
                                        onTap: () async {
                                          if (currentuser != null) {
                                            if (currentuser!.isAnonymous) {
                                              await _convertwithphonenumber(
                                                  context);
                                            } else {
                                              await _signInWithphonenumber(
                                                  context);
                                            }
                                          } else {
                                            await _signInWithphonenumber(
                                                context);
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.03),
                                          height: 45,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.9,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xff6bceff),
                                                  Color(0xFF00abff),
                                                ],
                                              ),
                                              border: Border.all(
                                                  color: Colors.black87
                                                      .withOpacity(0.1)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50))),
                                          child: Center(
                                            child: letsgoprogress
                                                ? CircularProgressIndicator(
                                                    color: Colors.white,
                                                  )
                                                : Text(
                                                    "Let\'s go!!!",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          timer.cancel();
                          Navigator.pop(context);
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _convertwithphonenumber(BuildContext context) async {
    if (_otpKey.currentState!.validate()) {
      setState(() {
        letsgoprogress = true;
      });

      try {
        await authclass
            .convertToPhoneNumber(
                finalverificationID, otpcontroller.text.trim(), context)
            .whenComplete(() {
          setState(() {
            letsgoprogress = false;
          });
          if (!mounted) {
            setState(() {
              timer.cancel();
            });
          }
        });
        phStorage.write(key: 'verificationID', value: finalverificationID);
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
        setState(() {
          letsgoprogress = false;
        });
      }
    } else {}
  }

  Future<void> _signInWithphonenumber(BuildContext context) async {
    if (_otpKey.currentState!.validate()) {
      setState(() {
        letsgoprogress = true;
      });

      try {
        await authclass
            .signInWithPhoneNumber(
                finalverificationID, otpcontroller.text.trim(), context)
            .whenComplete(() {
          setState(() {
            letsgoprogress = false;
          });
          if (!mounted) {
            setState(() {
              timer.cancel();
            });
          }
        }).onError((error, stackTrace) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("error while signin :$error")));
        });
        phStorage.write(key: 'verificationID', value: finalverificationID);
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
        setState(() {
          letsgoprogress = false;
        });
      }
    } else {}
  }

  _sendOtpToNumber() async {
    if (pressed == false) {
      setState(() {
        pressed = true;
        buttonName = "Resend";
      });
      try {
        await authclass
            .verifyPhoneNumber("+91${phonenumbercontroller.text}", context,
                setData, otpsentsuccesfully, verificationFailed)
            .onError((error, stackTrace) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("error while sending otp : $error")));
          setState(() {
            otpsend = false;
            isLoading = false;
          });
        }).whenComplete(() {});
      } catch (e) {
        print("error while otp sending is : ${e.toString()}");
      }
    } else {
      print("else of if(pressed == false) in phone auth");
    }
  }

  verificationFailed(FirebaseException exception) {
    print("---------------------------expp   $exception   ");
    setState(() {
      waits = false;
      isLoading = false;
      pressed = false;
    });

    showSnackbar(context, exception.toString());
  }

  void showSnackbar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _sendOtpToConvertedNumber() async {
    if (pressed == false) {
      setState(() {
        pressed = true;
        buttonName = "Resend";
      });
      try {
        await authclass
            .verifyConvertedPhoneNumber("+91${phonenumbercontroller.text}",
                context, setData, otpsentsuccesfully, verificationFailed)
            .onError((error, stackTrace) {
          setState(() {
            otpsend = false;
          });
        }).whenComplete(() {
          // ScaffoldMessenger.of(context).clearSnackBars();
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(SnackBar(content: Text("Number Verified")));
        });
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
        print("error while otp sending is : ${e.toString()}");
      }
    } else {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("Wait")));
    }
  }

  void startTimer() {
    timer = new Timer(const Duration(seconds: 45), () {
      setState(() {
        wait = false;
        pressed = false;
      });
    });

    // ignore: unused_local_variable
    Timer _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (start == 0) {
        if (mounted) {
          setState(() {
            timer.cancel();
            wait = false;
            waits = false;
            start = 45;
          });
        } else {}
      } else {
        if (mounted) {
          setState(() {
            wait = true;
            start--;
          });
        }
      }
    });
  }

  void setData(verificationId) {
    setState(() {
      finalverificationID = verificationId;
    });
    startTimer();
  }

  void otpsentsuccesfully() {
    setState(() {
      otpsend = true;
      isLoading = false;
    });
  }
}
