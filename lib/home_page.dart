import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_tutorial/add_new_task.dart';
import 'package:firebase_tutorial/utils.dart';
import 'package:firebase_tutorial/widgets/date_selector.dart';
import 'package:firebase_tutorial/widgets/task_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewTask(),
                ),
              );
            },
            icon: const Icon(
              CupertinoIcons.add,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const DateSelector(),
            StreamBuilder(
              // Make Request to firestore to get tasks collection
              stream: FirebaseFirestore.instance
                .collection("tasks")
                .where('creator', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
              // Context is the widget and snapshot is the data retrieved from firebase
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if(!snapshot.hasData) {
                  return const Text('No data here: :(');
                }

                return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  // index loop position number
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: ValueKey(index),
                      onDismissed: (direction) {
                        if(direction == DismissDirection.endToStart) {
                          FirebaseFirestore.instance
                          .collection("tasks")
                          .doc(snapshot.data!.docs[index].id)
                          .delete();
                        }
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: TaskCard(
                              // hexToColor converts the hex fromt he string ex/ "000000"
                              color: hexToColor(snapshot.data!.docs[index].data()['color']),
                              // Get the doc by index and retrieve data like title
                              headerText: snapshot.data!.docs[index].data()['title'],
                              descriptionText: snapshot.data!.docs[index].data()['description'],
                              scheduledDate: snapshot.data!.docs[index].data()['date'].toString(),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: strengthenColor(
                                const Color.fromRGBO(246, 222, 194, 1),
                                0.69,
                              ),
                              image: snapshot.data!.docs[index].data()['imageURL'] == null ? null : DecorationImage(image: NetworkImage(snapshot.data!.docs[index].data()['imageURL'])),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              '10:00AM',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          )
                        ],
                      )
                    );
                  },
                ),
              );
              },
            ),
          ],
        ),
      ),
    );
  }
}