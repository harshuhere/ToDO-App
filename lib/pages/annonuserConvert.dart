import 'package:flutter/material.dart';
import 'package:todo_with_firebase/services/facebookconnection.dart';
import 'package:todo_with_firebase/pages/loginPage.dart';
import 'package:todo_with_firebase/pages/phoneAuthPage.dart';
import 'package:todo_with_firebase/services/authService.dart';

class AnnonUserConvert extends StatefulWidget {
  const AnnonUserConvert({Key? key}) : super(key: key);

  @override
  _AnnonUserConvertState createState() => _AnnonUserConvertState();
}

class _AnnonUserConvertState extends State<AnnonUserConvert> {
  AuthClass authclass = AuthClass();
  bool backtologin = false;
  bool gcbtnloading = false;
  bool fbbtnloading = false;
  FacebookConnection fc = FacebookConnection();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 90,
                    color: Colors.black.withOpacity(0.7),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, top: 30),
                    child: Text(
                      "Save Info",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 400,
              width: MediaQuery.of(context).size.width * 0.8,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Text(
                      "Connect with your account \n   and save your all data.",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            gcbtnloading = true;
                          });
                          authclass
                              .convertToGoogleaccount(context)
                              .whenComplete(() {
                            setState(() {
                              gcbtnloading = false;
                            });
                          });
                        },
                        child: Container(
                          height: 45,
                          width: 215,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            border: Border.all(
                                color: Colors.black87.withOpacity(0.1)),
                          ),
                          padding: EdgeInsets.only(right: 7),
                          child:
                              //  gbtnprogress
                              //     ? Center(
                              //         child: CircularProgressIndicator(
                              //         color: Colors.black87,
                              //       ))
                              //     :
                              gcbtnloading
                                  ? Center(child: CircularProgressIndicator())
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => PhoneAuthPage()));
                        },
                        child: Container(
                          height: 45,
                          width: 215,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
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
                          setState(() {
                            fbbtnloading = true;
                          });
                          try {
                            await fc.facebookConvert(context).whenComplete(() {
                              setState(() {
                                fbbtnloading = false;
                              });
                            }).onError((error, stackTrace) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("$error")));
                              setState(() {
                                fbbtnloading = false;
                              });
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())));
                          }
                        },
                        child: Container(
                          height: 45,
                          width: 215,
                          decoration: BoxDecoration(
                            color: Color(0xff4267B2),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          padding: EdgeInsets.only(right: 3),
                          child:
                              //  fbtnprogress
                              //     ? Center(
                              //         child: CircularProgressIndicator(
                              //         color: Colors.white,
                              //       ))
                              //     :
                              fbbtnloading
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
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text("or"),
                      ),
                      InkWell(
                        onTap: () async {
                          _showMyDialog();
                        },
                        child: backtologin
                            ? Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ))
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    padding:
                                        EdgeInsets.only(left: 20, bottom: 10),
                                    iconSize: 30,
                                    onPressed: () {},
                                    icon: Icon(Icons.keyboard_arrow_left),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, right: 30),
                                    child: Text(
                                      "Back to login page ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  iconSize: 30,
                  onPressed: () {},
                  icon: Icon(Icons.keyboard_arrow_left),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, right: 70),
                    child: Text(
                      "Back ",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showMyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          title: const Text('Back to login page'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'If you go back to login page without save your data , you\'ll loose your data , press yes if you agree and go back to login page.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                setState(() {
                  backtologin = true;
                });
                await authclass.signOut().whenComplete(() {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => LoginPage()),
                      (route) => false).whenComplete(() {
                    setState(() {
                      backtologin = false;
                    });
                  });
                }).onError((error, stackTrace) {
                  setState(() {
                    backtologin = false;
                  });
                });
                // closeapp();
                // Navigator.pop(context, true);
                // Navigator.pop(context, true);
                // return true;
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context, false);
                // return false;
              },
            ),
          ],
        );
      },
    );
  }
}
