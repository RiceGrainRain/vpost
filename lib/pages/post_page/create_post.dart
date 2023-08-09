import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projects/components/post_components/addlocation.dart';
import 'package:projects/components/post_components/attachimages.dart';
import 'package:projects/components/post_components/my_linkfield.dart';
import 'package:projects/components/post_components/my_postdescrip.dart';
import 'package:projects/components/post_components/my_posttitle.dart';
import 'package:projects/components/post_components/uploadpost.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  bool isLoaded = false;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final infolinkController = TextEditingController();
  final gclinkController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    infolinkController.dispose();
    gclinkController.dispose();
    super.dispose();
  }

  void uploadPost() async {
    //loading screen
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    Future addPostDetails(
      String title,
      String description,
      String infoLink,
      String gcLink,
    ) async {
      await FirebaseFirestore.instance.collection('posts').add({
        'Title': title,
        'Description': description,
        'InfoLink': infoLink,
        'GcLink': gcLink,
      });
    }

    try {
      addPostDetails(
        titleController.text.trim(),
        descriptionController.text.trim(),
        infolinkController.text.trim(),
        gclinkController.text.trim(),
      );

      //pop the loading screen
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop the loading screen
      Navigator.pop(context);
      //wrong email
      showErrorMessage(e.message.toString());
    }
  }

  //error popup
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          backgroundColor: const Color.fromARGB(255, 251, 46, 62),
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  void showAlertMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          backgroundColor: Colors.amber,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  void showSuccessMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          backgroundColor: Colors.blue[600],
          title: const Center(
            child: Text(
              "Post successful!",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Create a post",
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: const Color.fromARGB(255, 22, 22, 22),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          MyPostTitle(controller: titleController, hintText: "Title"),
          MyPostDescription(
              controller: descriptionController,
              hintText: "Write a description"),
          MyLinkField(
              controller: infolinkController,
              hintText: "Add any informational links"),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: MyLinkField(
                controller: gclinkController,
                hintText: "Add any groupchat links"),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: AttachImages(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: AddLocation(),
                )
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: UploadPost(onTap: () {
                if (titleController.text.isEmpty) {
                  showErrorMessage("Title cannot be empty");
                } else if (descriptionController.text.isEmpty) {
                  showErrorMessage("Description Cannot be empty");
                } else {
                  if (isLoaded) {
                    uploadPost();
                    showSuccessMessage();
                    Timer(const Duration(seconds: 1), () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  } else {
                    if (infolinkController.text.isEmpty ||
                        gclinkController.text.isEmpty) {
                      showAlertMessage(
                          "Missing some fields! Hit upload to post anyways!");
                      isLoaded = true;
                    } else {
                      uploadPost();
                      showSuccessMessage();
                      Timer(const Duration(seconds: 1), () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    }
                  }
                }
              }))
        ]),
      ),
    );
  }
}
