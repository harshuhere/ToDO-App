import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_with_firebase/services/facebookconnection.dart';
import 'package:todo_with_firebase/pages/forgotPassword.dart';
import 'package:todo_with_firebase/pages/homePage.dart';
import 'package:todo_with_firebase/pages/phoneAuthPage.dart';
import 'package:todo_with_firebase/pages/signupPage.dart';
import 'package:todo_with_firebase/services/authService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _loginformKey = GlobalKey<FormState>();
  String loginemail = "";
  String loginpassword = "";
  bool showHide = true;

  final _lemailController = TextEditingController();
  final _lpasswordController = TextEditingController();
  final emailstorage = new FlutterSecureStorage();
  bool gbtnprogress = false;
  bool fbtnprogress = false;
  bool pbtnprogress = false;
  bool sbtnprogress = false;
  bool skiptxtprogress = false;

  togglepsd() {
    setState(() {
      showHide = !showHide;
    });
  }

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  AuthClass authclass = AuthClass();

  FacebookConnection fc = FacebookConnection();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  // alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Container(
                    // padding: EdgeInsets.only(
                    //     top: MediaQuery.of(context).size.height * 0.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Icon(
                              Icons.person_outline,
                              size: 90,
                              color: Color(0xFF00abff),
                              // Colors.black87.withOpacity(0.4),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0, top: 30),
                            child: Text(
                              "Sign in",
                              style: TextStyle(
                                  color: Color(0xFF00abff),
                                  //Colors.black87.withOpacity(0.4),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    // height: MediaQuery.of(context).size.height / 2,
                    //width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
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
                    child: Form(
                      key: _loginformKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            // height: MediaQuery.of(context).size.height * 0.09,
                            // padding: EdgeInsets.only(left: 16, right: 16),
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.all(Radius.circular(50)),
                            //     color: Colors.white,
                            //     boxShadow: [
                            //       BoxShadow(color: Colors.black12, blurRadius: 5)
                            //     ]),
                            child: TextFormField(
                              controller: _lemailController,
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
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Color(0xFF00abff),
                                  ),
                                  // hintText: 'Username',
                                  labelText: 'Email'),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            // height: MediaQuery.of(context).size.height * 0.1,
                            margin: EdgeInsets.only(top: 30),
                            child: TextFormField(
                              controller: _lpasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 18),
                              validator: (valuee) {
                                if (valuee == null || valuee.isEmpty) {
                                  return "         *Enter Password";
                                }
                              },
                              obscureText: showHide,
                              decoration: InputDecoration(
                                  //fillColor: Color(0xFF00abff),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Color(0xFF00abff),
                                    // Colors.black87.withOpacity(0.4),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: showHide
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility),
                                    color: Colors.grey.withOpacity(0.7),
                                    onPressed: () {
                                      togglepsd();
                                    },
                                  ),
                                  // hintText: 'Password',
                                  labelText: 'Password'),
                            ),
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.all(Radius.circular(50)),
                            //     color: Colors.white,
                            //     boxShadow: [
                            //       BoxShadow(color: Colors.black12, blurRadius: 5)
                            //     ]),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, right: 32),
                              child: InkWell(
                                onTap: () {
                                  print("Clicked forgot password");
                                  if (gbtnprogress == false &&
                                      sbtnprogress == false &&
                                      pbtnprogress == false &&
                                      fbtnprogress == false) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPassword()),
                                    );
                                  }
                                },
                                child: Text(
                                  'Forgot password ?',
                                  style: TextStyle(
                                      color: Colors.black87.withOpacity(0.5),
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () async {
                              if (gbtnprogress == false &&
                                  pbtnprogress == false &&
                                  fbtnprogress == false) {
                                setState(() {
                                  sbtnprogress = true;
                                });
                                _loginformKey.currentState!.validate();
                                if (_loginformKey.currentState!.validate()) {
                                  try {
                                    UserCredential luserCredential =
                                        await firebaseAuth
                                            .signInWithEmailAndPassword(
                                                email: _lemailController.text,
                                                password:
                                                    _lpasswordController.text);
                                    await emailstorage.write(
                                        key: 'uid',
                                        value: luserCredential.user?.uid);

                                    print(
                                        "login user uid is : ${luserCredential.user?.uid}");

                                    setState(() {
                                      sbtnprogress = false;
                                    });

                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) => HomePage()),
                                        (route) => false);
                                  } catch (e) {
                                    setState(() {
                                      sbtnprogress = false;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(e.toString()),
                                      duration: Duration(milliseconds: 1500),
                                    ));
                                    print(e);
                                  }
                                } else {
                                  setState(() {
                                    sbtnprogress = false;
                                  });
                                }
                              } else {}
                            },
                            child: Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width / 3,
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
                                child: sbtnprogress
                                    ? CircularProgressIndicator(
                                        color: Colors.black87,
                                      )
                                    : Text(
                                        'Sign in',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400),
                                      ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text(
                              "or",
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (fbtnprogress == false &&
                                  sbtnprogress == false &&
                                  pbtnprogress == false) {
                                setState(() {
                                  gbtnprogress = true;
                                });
                                await authclass
                                    .googleSignin(context)
                                    .whenComplete(() {
                                  setState(() {
                                    gbtnprogress = false;
                                  });
                                }).onError((error, stackTrace) {
                                  setState(() {
                                    gbtnprogress = true;
                                  });
                                });
                              } else {}
                            },
                            child: Container(
                              height: 45,
                              width: 215,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                border: Border.all(
                                    color: Colors.black87.withOpacity(0.1)),
                              ),
                              padding: EdgeInsets.only(right: 7),
                              child: gbtnprogress
                                  ? Center(
                                      child: CircularProgressIndicator(
                                      color: Colors.black87,
                                    ))
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/google.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            'Continue with google',
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              if (gbtnprogress == false &&
                                  sbtnprogress == false &&
                                  fbtnprogress == false) {
                                setState(() {
                                  pbtnprogress = true;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => PhoneAuthPage()),
                                ).whenComplete(() {
                                  setState(() {
                                    pbtnprogress = false;
                                  });
                                }).onError((error, stackTrace) {
                                  setState(() {
                                    pbtnprogress = false;
                                  });
                                });
                              }
                            },
                            child: Container(
                              height: 45,
                              width: 215,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                border: Border.all(
                                    color: Colors.black87.withOpacity(0.1)),
                              ),
                              padding: EdgeInsets.only(right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.phone_android),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      'Continue with phone',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              if (gbtnprogress == false &&
                                  pbtnprogress == false &&
                                  sbtnprogress == false) {
                                setState(() {
                                  fbtnprogress = true;
                                });
                                await fc
                                    .facebookLogin(context)
                                    .whenComplete(() {
                                  setState(() {
                                    fbtnprogress = false;
                                  });
                                }).onError((error, stackTrace) {
                                  setState(() {
                                    fbtnprogress = false;
                                  });
                                });
                              }
                            },
                            child: Container(
                              height: 45,
                              width: 215,
                              decoration: BoxDecoration(
                                color: Color(0xff4267B2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              padding: EdgeInsets.only(right: 3),
                              child: fbtnprogress
                                  ? Center(
                                      child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ))
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.facebook,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            'Continue with facebook',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    print("Clicked Don't have an account");
                    if (gbtnprogress == false &&
                        sbtnprogress == false &&
                        pbtnprogress == false &&
                        fbtnprogress == false) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (builder) => SignUpPage()),
                          (route) => false);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Don't have an account ? ",
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 13),
                      ),
                      Text(
                        "Sign up",
                        style: TextStyle(
                            color: Color(0xFF00abff),
                            fontWeight: FontWeight.w300,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(
                    "or",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (gbtnprogress == false &&
                        sbtnprogress == false &&
                        pbtnprogress == false &&
                        fbtnprogress == false) {
                      setState(() {
                        skiptxtprogress = true;
                      });

                      await authclass.signInAnon(context).whenComplete(() {
                        setState(() {
                          skiptxtprogress = false;
                        });
                      }).onError((error, stackTrace) {
                        setState(() {
                          skiptxtprogress = false;
                        });
                      });
                    }
                  },
                  child: skiptxtprogress
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.black87,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Skip",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w300),
                            ),
                            Text(
                              " Sign in",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF00abff),
                                  fontWeight: FontWeight.w300),
                            ),
                            Text(
                              " ?",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
