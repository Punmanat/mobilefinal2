import 'package:flutter/material.dart';
import '../models/user.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController userid = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  //new instance
  UserProvider userProvider = UserProvider();
  List<User> currentUsers = List();
  @override
  void initState() {
    super.initState();
    userProvider.open('member.db').then((r) {
      print("open success");
      getUsers();
    });
  }

  void getUsers() {
    userProvider.getUsers().then((r) {
      setState(() {
        currentUsers = r;
      });
    });
  }

  void deleteUsers() {
    userProvider.deleteUsers().then((r) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formkey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: userid,
                decoration: InputDecoration(
                  labelText: "Userid",
                ),
                validator: (value) {
                  if (value.isEmpty) return "Userid is required";
                  if (value.length < 6 || value.length > 12)
                    return "Userid must be 6-12 character";
                },
              ),
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "John Wick",
                ),
                validator: (value) {
                  int count = 0;
                  if (value.isEmpty) return "Name is required";
                  for (int i = 0; i < value.length; i++) {
                    if (value[i] == " ") {
                      count = 1;
                    }
                  }
                  if (count == 0) {
                    return "Please fill name correctly";
                  }
                },
              ),
              TextFormField(
                controller: age,
                decoration: InputDecoration(
                  labelText: "Age",
                ),
                validator: (value) {
                  if (value.isEmpty) return "Age is required";
                  if (!isNumeric(value)) return "Age incorrect";
                  if (int.parse(value) < 10 || int.parse(value) > 80)
                    return "Age must be between 10 and 80";
                },
              ),
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                  labelText: "Password",
                ),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty && value.length < 6)
                    return "Password is required";
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      child: Text("Register"),
                      onPressed: () {
                        bool flag = true;
                        if (_formkey.currentState.validate()) {
                          if (currentUsers.length == 0) {
                            print("gogogo = 1");
                            User user = User(
                                userid: userid.text,
                                name: name.text,
                                age: age.text,
                                password: password.text);
                            userProvider.insert(user).then((r) {
                              Navigator.pushReplacementNamed(context, '/');
                            });
                          } else {
                            print("gogogo = 2");
                            for (int i = 0; i < currentUsers.length; i++) {
                              if (userid.text == currentUsers[i].userid) {
                                flag = false;
                                break;
                              }
                            }
                            if (flag) {
                              print("gogogo = 3");
                              User user = User(
                                  userid: userid.text,
                                  name: name.text,
                                  age: age.text,
                                  password: password.text);
                              userProvider.insert(user).then((r) {
                                Navigator.pushReplacementNamed(context, '/');
                              });
                            } else {
                              print("gogogo = 4");
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(
                                          'userid duplicate, please fill new userid'),
                                    );
                                  });
                            }
                          }
                        }
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
