import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:intl/intl.dart';
import 'package:todo_with_firebase/services/firebaseConnection.dart';
import 'package:todo_with_firebase/pages/annonuserConvert.dart';
import 'package:todo_with_firebase/pages/profile.dart';
import 'package:todo_with_firebase/services/authService.dart';
import 'package:todo_with_firebase/todoCard.dart';

import '../search.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authclass = AuthClass();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController titlecontroller = TextEditingController();

  final secstorage = FlutterSecureStorage();
  AuthClass aclass = AuthClass();
  FirebaseConnection fconnection = FirebaseConnection();

  final _addnotekey = GlobalKey<FormState>();
  String? photourL;
  User? uSer;
  var user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;
  bool loading = false;

  late List<DocumentSnapshot> _docs;
  late List<DocumentSnapshot> _tdocs;

  Future? _saving;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    setProfilePic();
  }

  void setProfilePic() {
    if (user != null) {
      setState(() {
        var user = FirebaseAuth.instance.currentUser;
        photourL = user!.isAnonymous
            ? user.photoURL == null || user.photoURL!.isEmpty
                ? "https://www.kindpng.com/picc/m/21-214439_free-high-quality-person-icon-default-profile-picture.png"
                : user.photoURL
            : user.photoURL == null || user.photoURL!.isEmpty
                ? user.providerData[0].photoURL == null ||
                        user.providerData[0].photoURL!.isEmpty
                    ? "https://www.kindpng.com/picc/m/21-214439_free-high-quality-person-icon-default-profile-picture.png"
                    : user.providerData[0].photoURL
                : user.photoURL;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[200],
        title: Text(
          "To-Do",
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(left: 20),
            onPressed: () {
              showSearch(context: context, delegate: ListSearch());
            },
            icon: Icon(
              Icons.search,
              color: Colors.black87,
            ),
          ),
          IconButton(
            onPressed: () {
              _showbottomsheetforsortdata(context);
            },
            icon: Icon(
              Icons.sort,
              color: Colors.black87,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () async {
                setState(() {
                  loading = true;
                });
                var cUser = FirebaseAuth.instance.currentUser;

                Future.delayed(Duration(seconds: 2), () {
                  if (cUser != null) {
                    if (cUser.isAnonymous) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => AnnonUserConvert()),
                      ).whenComplete(() {
                        setState(() {
                          loading = false;
                        });
                      });
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (builder) => ProfilePage()),
                      ).whenComplete(() {
                        setState(() {
                          loading = false;
                        });
                      });
                    }
                  }
                });
              },
              child: CircleAvatar(
                radius: 18.0,
                backgroundColor: Colors.black,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : CircleAvatar(
                        backgroundImage: NetworkImage('$photourL'),
                        radius: 20.0,
                      ),
              ),
            ),
          ),
        ],
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : FutureBuilder(
              future: _saving,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.none ||
                    snapshot.connectionState == ConnectionState.done) {
                  return streamData();
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> streamData() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(user?.uid)
            .collection("ToDos")
            // .orderBy(sort, descending: boolsort)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.black87,
            ));
          } else {
            _docs = snapshot.data!.docs;
            _tdocs = _docs;

            _docs.sort((a, b) {
              dynamic tempa = a.data();
              dynamic tempb = b.data();
              return tempa["pos"].compareTo(tempb["pos"]);
            });

            // if (boolsort == false) {
            //   _docs.sort((a, b) {
            //     dynamic tempa = a.data();
            //     dynamic tempb = b.data();
            //     return tempa["$sort"].compareTo(tempb["$sort"]);
            //   });
            // } else {
            //   _docs.sort((b, a) {
            //     dynamic tempa = a.data();
            //     dynamic tempb = b.data();
            //     return tempa["$sort"].compareTo(tempb["$sort"]);
            //   });
            // }

            return Stack(
              children: [
                _docs.length < 1
                    ? Center(
                        child: Text(
                          "No Todos added, Add New one.",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: 18),
                        ),
                      )
                    : ReorderableListView(
                        onReorder: (int oldIndex, int newIndex) async {
                          if (oldIndex < newIndex) newIndex -= 1;
                          _docs.insert(newIndex, _docs.removeAt(oldIndex));
                          final futures = <Future>[];
                          for (int pos = 0; pos < _docs.length; pos++) {
                            futures
                                .add(_docs[pos].reference.update({'pos': pos}));
                          }
                          setState(() {
                            _saving = Future.wait(futures);
                          });

                          _docs.sort((a, b) {
                            dynamic tempa = a.data();
                            dynamic tempb = b.data();
                            return tempa["pos"].compareTo(tempb["pos"]);
                          });
                        },
                        children: List.generate(_docs.length, (index) {
                          Map<String, dynamic> docss =
                              _docs[index].data() as Map<String, dynamic>;

                          return TodoCard(
                            key: Key("$index"),
                            title: docss["title"] == ""
                                ? "Untitled"
                                : docss["title"],
                            description: docss["description"] == null
                                ? "Not described"
                                : docss["description"],
                            time:
                                docss["time"] == null ? "00:00" : docss["time"],
                            utitle: docss["title"],
                            udesc: docss["description"],
                            isCompleted: docss["isCompleted"],

                            // isChecked: docss["isChecked"],
                            snap: snapshot,
                            indexx: docss['pos'],
                          );
                        })),
                Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.only(right: 20, bottom: 20),
                  child: FloatingActionButton(
                    backgroundColor: Colors.black.withOpacity(0.7),
                    onPressed: () {
                      showAddnoteDialog();
                      setState(() {
                        titlecontroller.text = "";
                        descriptioncontroller.text = "";
                      });
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            );
          }
        });
  }

  void showAddnoteDialog() {
    showCupertinoDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.only(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(child: Text("Add Note")),
        titleTextStyle: TextStyle(
            color: Colors.blue[400],
            fontSize: 25,
            letterSpacing: 1,
            fontWeight: FontWeight.w400),
        content: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          height: 280,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _addnotekey,
                child: Column(
                  children: [
                    Container(
                      // height: 50,
                      child: TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ' *Enter Title';
                          }
                          return null;
                        },
                        controller: titlecontroller,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 21,
                        ),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 10, left: 10),
                            border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15))),
                            hintText: 'Title'),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ' *Enter Description';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.multiline,
                        controller: descriptioncontroller,
                        cursorColor: Colors.black87,
                        autocorrect: true,
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 17),
                        maxLines: 5,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 10),
                            border: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            // enabledBorder: OutlineInputBorder(),
                            // focusedBorder: OutlineInputBorder(),
                            hintText: "Description"),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      border:
                          Border.all(color: Colors.black87.withOpacity(0.4)),
                    ),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        _addnotekey.currentState!.validate();
                        if (_addnotekey.currentState!.validate()) {
                          //
                          DateTime times = DateTime.now();
                          final DateFormat formatter =
                              DateFormat('hh:mm a \nEEEE \ndd/M/yyyy');
                          final String formatted =
                              formatter.format(times).toString();
                          //
                          fconnection.saveToFirebase(
                              titlecontroller.text,
                              descriptioncontroller.text,
                              formatted,
                              false,
                              _docs.length);
                          //
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("ToDo added"),
                            duration: Duration(milliseconds: 1200),
                          ));
                          //
                          Navigator.pop(context);
                        }
                      },
                      color: Colors.white60,
                      child: Text(
                        "Add",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.black.withOpacity(0.7)),
                        //  Color(0xFF00abff)
                      ),
                    ),
                  ),
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      border:
                          Border.all(color: Colors.black87.withOpacity(0.4)),
                    ),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.white60,
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showbottomsheetforsortdata(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 245,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      _tdocs.sort((a, b) {
                        dynamic tempa = a.data();
                        dynamic tempb = b.data();
                        return tempa["time"].compareTo(tempb["time"]);
                      });
                      final futures = <Future>[];

                      for (int pos = 0; pos < _docs.length; pos++) {
                        futures.add(_tdocs[pos].reference.update({'pos': pos}));
                      }
                      setState(() {
                        _saving = Future.wait(futures);
                      });

                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black87),
                      ),
                      padding: EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      // color: Colors.amber,
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      child: Text(
                        "Sort by time - ascending",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                            color: Colors.black87),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  InkWell(
                    onTap: () {
                      _tdocs.sort((b, a) {
                        dynamic tempa = a.data();
                        dynamic tempb = b.data();
                        return tempa["time"].compareTo(tempb["time"]);
                      });
                      final futures = <Future>[];

                      for (int pos = 0; pos < _docs.length; pos++) {
                        futures.add(_tdocs[pos].reference.update({'pos': pos}));
                      }
                      setState(() {
                        _saving = Future.wait(futures);
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87)),
                      padding: EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      // color: Colors.red,
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      child: Text(
                        "Sort by time - descending",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                            color: Colors.black87),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  InkWell(
                    onTap: () {
                      _tdocs.sort((a, b) {
                        dynamic tempa = a.data();
                        dynamic tempb = b.data();
                        return tempa["title"].compareTo(tempb["title"]);
                      });
                      final futures = <Future>[];

                      for (int pos = 0; pos < _docs.length; pos++) {
                        futures.add(_tdocs[pos].reference.update({'pos': pos}));
                      }
                      setState(() {
                        _saving = Future.wait(futures);
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87)),
                      padding: EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      // color: Colors.amber,
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      child: Text(
                        "Sort by title - ascending",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                            color: Colors.black87),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  InkWell(
                    onTap: () {
                      _tdocs.sort((b, a) {
                        dynamic tempa = a.data();
                        dynamic tempb = b.data();
                        return tempa["title"].compareTo(tempb["title"]);
                      });
                      final futures = <Future>[];

                      for (int pos = 0; pos < _docs.length; pos++) {
                        futures.add(_tdocs[pos].reference.update({'pos': pos}));
                      }
                      setState(() {
                        _saving = Future.wait(futures);
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87)),
                      padding: EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      // color: Colors.red,
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      child: Text(
                        "Sort by title - descending",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                            color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
