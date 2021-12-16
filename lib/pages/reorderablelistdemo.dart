//  shrinkWrap: true,
//                   itemCount: snapshot.data!.docs.length,
//                   onReorder: (int oldIndex, int newIndex) {
//                     // setState(() {
//                     //   finalIndex =
//                     //       newIndex > oldIndex ? newIndex - 1 : newIndex;
//                     //   // oldIndex = newIndex;
//                     //   final useR = snapshot.data!.docs.removeAt(oldIndex);
//                     //   snapshot.data!.docs.insert(finalIndex!, useR);
//                     // });
//                   },
//                   itemBuilder: (context, index) {
//                     // finalIndex = index;
//                     Map<String, dynamic> docss = snapshot.data!.docs[index]
//                         .data() as Map<String, dynamic>;
//                     return TodoCard(
//                       key: ValueKey(
//                         FirebaseFirestore.instance
//                             .collection("Users")
//                             .doc(user?.uid)
//                             .collection("ToDos")
//                             .snapshots(),
//                       ),
//                       title: docss["title"] == "" ? "Untitled" : docss["title"],
//                       description: docss["description"] == null
//                           ? "Not described"
//                           : docss["description"],
//                       time: docss["time"] == null ? "00:00" : docss["time"],
//                       utitle: docss["title"],
//                       udesc: docss["description"],
//                       isCompleted: docss["isCompleted"],

//                       // isChecked: docss["isChecked"],
//                       snap: snapshot,
//                       indexx: index,
//                     );
//                   },