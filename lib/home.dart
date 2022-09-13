import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void anotherDataCollection() {
  //CARA GET COLLECTION WORK
  FirebaseFirestore.instance
      .collection('user')
      .get()
      .then((QuerySnapshot qSnap) {
    qSnap.docs.forEach((doc) {
      print('username:' + doc['username'] + " | password:" + doc['password']);
    });
  });
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homepage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Homepage User'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController soreController = TextEditingController();
  TextEditingController malamController = TextEditingController();
  TextEditingController updateMalamController = TextEditingController();
  TextEditingController updateSoreController = TextEditingController();

  Future<List<Map<String, String>>> getDataFromCollection(
      String colname) async {
    List<Map<String, String>> colData = [];
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection(colname).get();
    data.docs.forEach((doc) {
      colData.add({
        'malam': doc['malam'],
        'pagi': doc['pagi'],
        'updateMalam': doc['updateMalam'],
        'updatePagi': doc['updatePagi']
      });
    });
    // print(colData);
    return colData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                readOnly: true,
                controller: soreController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'SORE',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                readOnly: true,
                controller: updateSoreController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'UPDATE SORE',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                readOnly: true,
                controller: malamController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'MALAM',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                readOnly: true,
                controller: updateMalamController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'UPDATE MALAM',
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 25.0),
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Refresh'),
                  onPressed: () async {
                    List<Map<String, String>> data =
                        await getDataFromCollection("omzet");
                    if (data != null) {
                      malamController.text =
                          data[data.length - 1]['malam'].toString();
                      updateMalamController.text =
                          data[data.length - 1]['updateMalam'].toString();
                      soreController.text =
                          data[data.length - 1]['pagi'].toString();
                      updateSoreController.text =
                          data[data.length - 1]['updatePagi'].toString();
                    } else {
                      var snackBar = SnackBar(
                        content: Text('No data right now'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
