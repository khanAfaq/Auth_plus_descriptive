import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firee/posts/add_posts.dart';
import 'package:firee/ui/auth/login_screen.dart';
import 'package:firee/utilies/utilites.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final editController = TextEditingController();
  final searchController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        //centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Post'),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }).onError((error, stackTrace) {
                Utiles().textMessage(error.toString());
              });
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(
            width: 10.0,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.orange,
                ),
                hintText: 'Search..',
                //contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              defaultChild: const Text('Loading...'),
              itemBuilder: (context, snapshot, animation, index) {
                final title = snapshot.child('Title').value.toString();
                if (searchController.text.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Card(
                      elevation: 10.0,
                      child: ListTile(
                        title: Text(
                          snapshot.child('Title').value.toString(),
                        ),
                        subtitle: Text(
                          snapshot.child('id').value.toString(),
                        ),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  showMyDialog(title,
                                      snapshot.child('id').value.toString());
                                },
                                leading: const Icon(Icons.edit),
                                title: const Text('Edit'),
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              onTap: () {
                                //Navigator.pop(context);
                                ref
                                    .child(
                                        snapshot.child('id').value.toString())
                                    .remove();
                              },
                              child: const ListTile(
                                leading: Icon(Icons.delete),
                                title: Text('Delete'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (title
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase())) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Card(
                      elevation: 10.0,
                      child: ListTile(
                        title: Text(
                          snapshot.child('Title').value.toString(),
                        ),
                        subtitle: Text(
                          snapshot.child('id').value.toString(),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPostScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              controller: editController,
              decoration: const InputDecoration(hintText: 'Edit here..'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.child(id).update({
                    'Title': editController.text.toString(),
                  }).then((value) {
                    Utiles().textMessage('Post Updated');
                  }).onError((error, stackTrace) {
                    Utiles().textMessage(error.toString());
                  });
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }
}
