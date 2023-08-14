import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetUserName extends StatelessWidget {
  const GetUserName({
    super.key,
  });
  getUserUid() {
    if (FirebaseAuth.instance.currentUser != null) {
      return (FirebaseAuth.instance.currentUser?.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance
        .collection('userposts')
        .doc('userinfo')
        .collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(getUserUid()).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text("${data['first name']} ${data['last name']}");
        }
        return Text("loading", style: TextStyle(color: Colors.blue.shade600));
      },
    );
  }
}