// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:todo_with_firebase/pages/loginPage.dart';

// class VerifyEmail extends StatefulWidget {
//   const VerifyEmail({Key? key}) : super(key: key);

//   @override
//   _VerifyEmailState createState() => _VerifyEmailState();
// }

// class _VerifyEmailState extends State<VerifyEmail> {
//   final auth = FirebaseAuth.instance;
//   User? user;
//   Timer? timer;

//   @override
//   void initState() {
//     try {
//       user = auth.currentUser;
//       user?.sendEmailVerification().whenComplete(() {
//         ScaffoldMessenger.of(context).clearSnackBars();
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Verification email Sent!!!")));
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).clearSnackBars();
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(e.toString())));
//     }
//     timer = Timer.periodic(Duration(seconds: 3), (timer) {
//       checkEmailVerified();
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     timer!.cancel();
//     super.dispose();
//   }

//   // Future<void> closeapp() async {
//   //   Future.delayed(const Duration(milliseconds: 500), () {
//   //     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//   //   });
//   // }

//   Future<void> _showMyDialog() async {
//     showDialog<bool>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (
//         BuildContext context,
//       ) {
//         return AlertDialog(
//           title: const Text('Exit verification'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: const <Widget>[
//                 Text(
//                     'Verification is in process , want to cancel it and go back to Registration page ?'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Yes'),
//               onPressed: () {
//                 // closeapp();
//                 Navigator.pop(context, true);
//                 Navigator.pop(context, true);
//                 // return true;
//               },
//             ),
//             TextButton(
//               child: const Text('No'),
//               onPressed: () {
//                 Navigator.pop(context, false);
//                 // return false;
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         _showMyDialog();

//         return false;
//       },
//       child: Scaffold(
//         body: Container(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Center(
//                 child: Text(
//                   "Verification link send on \n${user?.email}\nverify it before expires,",
//                   style: TextStyle(
//                     fontSize: 25,
//                     color: Colors.black,
//                     fontWeight: FontWeight.w300,
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     IconButton(
//                       padding: EdgeInsets.only(left: 20, top: 20),
//                       iconSize: 30,
//                       onPressed: () {},
//                       icon: Icon(Icons.keyboard_arrow_left),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20, right: 25),
//                       child: Text(
//                         "Back ",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w300, color: Colors.black),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> checkEmailVerified() async {
//     user = auth.currentUser!;
//     await user!.reload();
//     if (user!.emailVerified) {
//       timer!.cancel();

//       Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => LoginPage()));
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("User verified")));
//     } else {
//       user!.delete();
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("User not verified , try again!!!")));
//     }
//   }
// }
