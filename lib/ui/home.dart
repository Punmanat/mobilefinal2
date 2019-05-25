import 'package:flutter/material.dart';
import '../models/user.dart';
import './profile.dart';
import './friend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  HomeScreen({Key key, this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  String q;
  String name;
  SharedPreferences sharedPreferences;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<String> readcontent() async {
    try {
      print("In");
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return 'Error';
    }
  }

  Future<File> writeContent(String data) async {
    final file = await _localFile;
    file.writeAsString('$data');
  }

  Future<String> getName() async{
    sharedPreferences = await SharedPreferences.getInstance();
    String data = sharedPreferences.getString('name');
    String username = sharedPreferences.getString('username');
    print('username $username');
    print(data);
    return data;
  }


  @override
  void initState() {
    super.initState();
    readcontent().then((v) {
      setState(() {
        q = v;
        print("Data $q");
      });
    });
    getName().then((v){
      setState(() {
        name = v;
        print("Name $name");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          child: Center(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Hello $name',
                    style: new TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  subtitle: Text(
                      'this is my quote  "${q != null && q != '' ? q : "No quote yet"}"'),
                ),
                RaisedButton(
                  child: Text("PROFILE SETUP"),
                  onPressed: () {
                    print(q);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(user: user),
                      ),
                    );
                  },
                ),
                RaisedButton(
                  child: Text("MY FRIENDS"),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FriendScreen(user: user),
                      ),
                    );
                  },
                ),
                RaisedButton(
                  child: Text("SIGN OUT"),
                  onPressed: () async {
                    writeContent('');
                    sharedPreferences = await SharedPreferences.getInstance();
                    sharedPreferences.setString("username", null);
                    sharedPreferences.setString("password", null);
                    sharedPreferences.setString("name", null);
                    Navigator.pushReplacementNamed(context, '/');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
