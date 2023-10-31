import 'package:firebase_database/firebase_database.dart';
import 'package:firee/utilies/utilites.dart';
import 'package:firee/widget/round_button.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _openKey = GlobalKey<FormState>();
  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  // Post = table(SQL) and node(FIREBASE)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30.0,
            ),
            Form(
              key: _openKey,
              child: TextFormField(
                controller: postController,
                maxLength: 256,
                maxLines: 5,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: 'what is in your mind?',
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter discription😒..';
                  }
                  // Add additional validation logic for phone number format if needed
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            RoundButton(
              loading: loading,
              title: 'Add',
              onTap: () {
                if (_openKey.currentState!.validate()) {}
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().microsecondsSinceEpoch.toString();
                databaseRef.child(id).set({
                  'Title': postController.text.toString(),
                  'id': id,
                }).then((value) {
                  Utiles().textMessage('Post added');
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace) {
                  Utiles().textMessage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
