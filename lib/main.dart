import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:istanabuahios/home.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  //PENTING INIT FIREBASE
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

void initFbase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Firebase initiated!");
}

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Demo Login User'),
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
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<bool> checkLoginCredential(String username, String password) async {
    List<Map<String, String>> data = await getDataFromCollection('admin');
    for (int i = 0; i < data.length; i++) {
      if (username == data[i]['username'] && password == data[i]['password']) {
        return true;
      }
    }
    return false;
  }

  Future<List<Map<String, String>>> getDataFromCollection(
      String colname) async {
    List<Map<String, String>> colData = [];
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection(colname).get();
    data.docs.forEach((doc) {
      colData.add({'username': doc['username'], 'password': doc['password']});
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
                controller: usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 25.0),
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () async {
                    bool check = await checkLoginCredential(
                        usernameController.text, passwordController.text);
                    var snackBar;
                    if (check == true) {
                      snackBar = SnackBar(
                        content: Text('Login Success'),
                      );
                    } else {
                      snackBar = SnackBar(
                        content: Text('Login Failed'),
                      );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    if (check == true) {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomeApp()));
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
