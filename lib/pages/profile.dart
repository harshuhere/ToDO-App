import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_with_firebase/pages/loginPage.dart';
import 'package:todo_with_firebase/services/authService.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthClass authclass = AuthClass();
  bool loader = false;
  String? userName;
  String? email;
  String? photoURL;
  String? providerName;
  bool _isLoading = false;
  var user;

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  Future<void> setUserData() async {
    setState(() {
      _isLoading = true;
    });
    user = FirebaseAuth.instance.currentUser;
    await user.reload();
    user = FirebaseAuth.instance.currentUser;
    print(user);
    if (user != null) {
      setState(() {
        userName = user!.displayName == null || user!.displayName!.isEmpty
            ? user.providerData[0].displayName == null ||
                    user.providerData[0].displayName.isEmpty
                ? user!.phoneNumber == null || user!.phoneNumber!.isEmpty
                    ? user.providerData[0].phoneNumber == null ||
                            user.providerData[0].phoneNumber.isEmpty
                        ? "Username not found !!!"
                        : user.providerData[0].phoneNumber
                    : user!.phoneNumber
                : user.providerData[0].displayName
            : user!.displayName;
        email = user!.email == null || user!.email!.isEmpty
            ? user.providerData[0].email == null ||
                    user.providerData[0].email.isEmpty
                ? "Email not found !!!"
                : user.providerData[0].email
            : user!.email;
        photoURL = user!.photoURL == null || user!.photoURL.isEmpty
            ? user.providerData[0].photoURL == null ||
                    user.providerData[0].photoURL.isEmpty
                ? "https://www.kindpng.com/picc/m/21-214439_free-high-quality-person-icon-default-profile-picture.png"
                : user.providerData[0].photoURL
            : user!.photoURL;
        providerName = user.providerData[0].providerId == null ||
                user.providerData[0].providerId.isEmpty
            ? "Unknown login"
            : user.providerData[0].providerId;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: Center(
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
                      "Profile info",
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
              // height: 540,
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
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
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : CircleAvatar(
                              radius: 81.0,
                              backgroundColor: Colors.black.withOpacity(0.2),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  "$photoURL",
                                ),
                                radius: 80.0,
                              ),
                            ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      alignment: Alignment.bottomCenter,
                      // color: Colors.red,
                      child: Text(
                        "Logged in via $providerName",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            letterSpacing: 1),
                      ),
                    ),
                    Divider(
                      height: 80.0,
                      color: Colors.black,
                    ),
                    userName == null || userName == "Username not found !!!"
                        ? Container()
                        : Text(
                            '*USERNAME',
                            style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w300),
                          ),
                    SizedBox(
                      height: 8.0,
                    ),
                    userName == null || userName == "Username not found !!!"
                        ? Container()
                        : Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.black,
                              ),
                              Text(
                                "$userName",
                                style: TextStyle(
                                    color: Colors.black,
                                    letterSpacing: 2.0,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 10.0,
                    ),
                    email == null || email == "Email not found !!!"
                        ? Container()
                        : Text(
                            '*Email',
                            style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w300),
                          ),
                    SizedBox(
                      height: 10.0,
                    ),
                    email == null || email == "Email not found !!!"
                        ? Container()
                        : Row(
                            children: <Widget>[
                              Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "$email",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          loader = true;
                        });
                        authclass.signOut();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => LoginPage()),
                            (route) => false).whenComplete(() {
                          setState(() {
                            loader = false;
                          });
                        });
                        print("Clicked Signout");
                      },
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20),
                          height: 45,
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey.withOpacity(0),
                                Colors.black.withOpacity(0.5),
                              ],
                            ),
                            border: Border.all(
                                color: Colors.black87.withOpacity(0.05)),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child: Center(
                            child: loader
                                ? CircularProgressIndicator(
                                    color: Colors.black,
                                  )
                                : Text(
                                    'Sign out',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w300),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            iconSize: 30,
                            onPressed: () {},
                            icon: Icon(Icons.keyboard_arrow_left),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              "Back ",
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
