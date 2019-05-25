import 'package:http/http.dart' as http;
import 'dart:convert';

class Friend {
  int id;
  String email;
  String name;
  String phone;
  String website;

  Friend({this.id, this.name, this.email, this.phone, this.website});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return new Friend(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      website: json['website'],
    );
  }
}

class FriendList {
  final List<Friend> friends;
  FriendList({
    this.friends,
  });
  factory FriendList.fromJson(List<dynamic> parsedJson) {
    List<Friend> friends = new List<Friend>();
    friends = parsedJson.map((i) => Friend.fromJson(i)).toList();

    return new FriendList(
      friends: friends,
    );
  }
}

class FriendProvider {
  Future<List<Friend>> loadDatas(String url) async {
    http.Response resp = await http.get(url);
    final jresp = json.decode(resp.body);
    FriendList friendList = FriendList.fromJson(jresp);
    return friendList.friends;
  }
}