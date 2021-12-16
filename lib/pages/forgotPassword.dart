import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_with_firebase/pages/loginPage.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _resendemailcontroller = TextEditingController();
  bool sendlinkprogress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                    child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.error_outline,
                              size: 60,
                              color: Color(0xFF00abff),
                              // Colors.black87.withOpacity(0.4),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0, top: 0),
                              child: Text(
                                " Forgot password ?",
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
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          boxShadow: [
                            BoxShadow(
                              //color: Colors.black.withOpacity(0.15),
                              color: Colors.black87.withOpacity(0.3),
                              blurRadius: 14,
                              offset: Offset(5, 5),
                            ),
                          ]),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: TextFormField(
                              controller: _resendemailcontroller,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 18,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '         *Enter email';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Color(0xFF00abff),
                                  ),
                                  // hintText: 'Username',
                                  labelText: 'Email'),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                sendlinkprogress = true;
                              });
                              try {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(
                                        email: _resendemailcontroller.text)
                                    .whenComplete(() {
                                  setState(() {
                                    sendlinkprogress = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text("Reset link sent")));
                                });
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("No such user/email found.")));
                                setState(() {
                                  sendlinkprogress = false;
                                });
                              }
                            },
                            child: Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff6bceff),
                                      Color(0xFF00abff),
                                    ],
                                  ),
                                  // border: Border.all(
                                  //     color: Colors.black87.withOpacity(0.05)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: Center(
                                child: sendlinkprogress
                                    ? CircularProgressIndicator()
                                    : Text(
                                        'Send reset link',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w300),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => LoginPage()),
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
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
