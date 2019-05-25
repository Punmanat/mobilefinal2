import 'package:http/http.dart' as http;
import 'dart:convert';

class Todo {
  int id;
  int userId;
  String title;
  bool completed;

  Todo({this.id, this.userId, this.title, this.completed});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return new Todo(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}

class TodoList {
  final List<Todo> todos;
  TodoList({
    this.todos,
  });
  factory TodoList.fromJson(List<dynamic> parsedJson) {
    List<Todo> todos = new List<Todo>();
    todos = parsedJson.map((i) => Todo.fromJson(i)).toList();

    return new TodoList(
      todos: todos,
    );
  }
}

class TodoProvider {
  Future<List<Todo>> loadTodo(String id) async {
    http.Response resp = await http
        .get("https://jsonplaceholder.typicode.com/todos?userId=" + id);
    final jresp = json.decode(resp.body);
    TodoList todoList = TodoList.fromJson(jresp);
    return todoList.todos;
  }
}