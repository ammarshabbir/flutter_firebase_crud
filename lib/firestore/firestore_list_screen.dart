import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/firestore/add_firestore_data.dart';
import 'package:flutter_firebase/post/add_post.dart';
import 'package:flutter_firebase/ui/login_screen.dart';
import 'package:flutter_firebase/utils/utils_function.dart';

class FirestoreListScreen extends StatefulWidget {
  const FirestoreListScreen({Key? key}) : super(key: key);

  @override
  State<FirestoreListScreen> createState() => _FirestoreListScreenState();
}

class _FirestoreListScreenState extends State<FirestoreListScreen> {
  final _auth = FirebaseAuth.instance;
  bool loader = false;
  final ref = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference ref1 = FirebaseFirestore.instance.collection('users');


  final searchController = TextEditingController();
  final editController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddFirestoreData()));
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                setState(() {
                  searchController.text = value;
                });
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ref,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    String id = data['id'];
                    String title = data['title'];
                    return ListTile(
                      title: Text(title),
                      subtitle: Text(id),
                      trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                value:1,
                                onTap: () {
                                  showMyDialogue(title,
                                      id);
                                },
                                child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('Edit'),
                                )),
                            PopupMenuItem(
                                value:2,
                                onTap: () {
                                  ref1.doc(id).delete().then((value){

                                    Utils().flutterToast('Data Remove');
                                  }).onError((err, StackTrac){
                                    Utils().flutterToast(err.toString());
                                  });
                                },
                                child: ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                ))
                          ]),
                    );
                  }).toList(),
                );
              },

          ),
          )],
      ),
      appBar: AppBar(
        title: Text('Post Screen'),
        actions: [
          loader
              ? Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ))
              : IconButton(
              onPressed: () async {
                await _auth.signOut().then((value) {
                  setState(() {
                    loader = true;
                  });
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) =>
                    false, // This condition determines which routes to keep.
                  );
                }).onError((error, stackTrace) {
                  Utils().flutterToast(error.toString());
                  debugPrint('Error occurred: $error');
                  setState(() {
                    loader = false;
                  });
                });
              },
              icon: Icon(Icons.logout))
        ],
      ),
    );
  }

  Future<void> showMyDialogue(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Update'),
          content: Container(
            child: TextFormField(
              controller: editController,
              decoration: InputDecoration(hintText: 'Edit'),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            TextButton(
                onPressed: () {
                  ref1.doc(id).update({
                    'title': editController.text.toLowerCase(),
                  }).then((value) {
                    Navigator.pop(context);

                    Utils().flutterToast('updated');
                  }).onError((err, stackTrac) {
                    Navigator.pop(context);

                    Utils().flutterToast(err.toString());
                  });
                },
                child: Text('Update')),
          ],
        ));
  }
}
