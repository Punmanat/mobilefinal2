import 'package:flutter/material.dart';
import '../models/user.dart';
import './home.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController userid = TextEditingController();
  TextEditingController password = TextEditingController();
  UserProvider userProvider = UserProvider();
  List<User> currentUsers = List();
  SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
    userProvider.open('member.db').then((r) async {
      getUsers();
      print("open success");
    });
  }

  void getUsers() {
    userProvider.getUsers().then((r) async {
      currentUsers = r;
      sharedPreferences = await SharedPreferences.getInstance();
      String userchk = sharedPreferences.getString('username');
      String passwordchk = sharedPreferences.getString('password');
      if (userchk != "" && userchk != null) {
        for (int i = 0; i < currentUsers.length; i++) {
          if (userchk == currentUsers[i].userid &&
              passwordchk == currentUsers[i].password) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(user: currentUsers[i]),
              ),
            );
          }
        }
      }
    });
  }

  Widget loginForm() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formkey,
        child: ListView(
          children: <Widget>[
            Image.network(
              "http://www.uklockpickers.co.uk/media/catalog/product/cache/1/image/800x800/9df78eab33525d08d6e5fb8d27136e95/d/8/d8dfa4e7d36f5baac5e6378fbd2d7afe--yale-keys.jpg",
              height: 200,
            ),
            // Image.asset(
            //   "resources/cat.jpg",
            //   width: 200,
            //   height: 200,
            // ),
            TextFormField(
              controller: userid,
              decoration: InputDecoration(
                labelText: "Userid",
              ),
              validator: (value) {
                if (value.isEmpty) return "Please fill out this form";
              },
            ),
            TextFormField(
              controller: password,
              decoration: InputDecoration(
                labelText: "Password",
              ),
              obscureText: true,
              validator: (value) {
                if (value.isEmpty) return "Please fill out this form";
              },
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: RaisedButton(
                    child: Text("sign in"),
                    onPressed: () async {
                      bool flag = false;
                      if (_formkey.currentState.validate()) {
                        for (int i = 0; i < currentUsers.length; i++) {
                          if (userid.text == currentUsers[i].userid &&
                              password.text == currentUsers[i].password) {
                            flag = true;
                            sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setString(
                                "username", currentUsers[i].userid);
                            sharedPreferences.setString(
                                "password", currentUsers[i].password);
                            sharedPreferences.setString(
                                "name", currentUsers[i].name);
                            // prefs.setInt('id', currentUsers[i].userid);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HomeScreen(user: currentUsers[i]),
                              ),
                            );
                          }
                        }
                        if (!flag) {
                          Toast.show("Invalid user or password", context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text("Register new account"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          automaticallyImplyLeading: false,
        ),
        body: loginForm());
  }
}
