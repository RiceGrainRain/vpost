//Manas Navale - Vpost
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projects/components/home_components.dart/my_searchbar.dart';
import 'package:projects/pages/home_pages/get_title.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void updateList(String value) {
    //filters list
  }

  List<String> docIDs = [];

  Future getDocID() async {
    await FirebaseFirestore.instance
        .collection('userposts')
        .doc('postinfo')
        .collection('posts')
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach((document) {
            print(document.reference);
            docIDs.add(document.reference.id);
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MySearchBar(),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder(
              future: getDocID(),
              builder: (context, snapshot) {
              return ListView.builder(
                itemCount: docIDs.length,
                itemBuilder: (context, index) {
                return ListTile(
                  title: GetTitle(documentID: docIDs[index],
                  ),
                  subtitle: const Text('Nothing yet'),
                  );
            });
          }))
        ],
      ),
    );
  }
}
