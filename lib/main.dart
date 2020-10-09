import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class Todo {
  bool isDone;
  String title;

  Todo(this.title);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Main(),
    );
  }
}

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<Todo> readCounter() async {
    try {
      final file = await _localFile;

      // 파일 읽기
      String contents = await file.readAsString();
      Todo todo;

      todo.title = contents.toString().split(',')[0];
      todo.isDone = contents.toString().split(',')[1].isEmpty;

      return todo;
    } catch (e) {
      Todo todo;
      todo.isDone = false;
      todo.title = '';
      return todo;
    }
  }

  Future<File> writeCounter(String title, [bool isDone]) async {
    final file = await _localFile;

    // print('$counter $index');
    // 파일 쓰기
    return file.writeAsString('$title, $isDone/', mode: FileMode.append);
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  var txtcontroller = TextEditingController();
  bool iconChanger = true;
  int index;
  List<Todo> items = <Todo>[];
  // List<String> readText = List<String>(100);
  Storage storage;

  void addTodo(Todo todo) {
    setState(() {
      items.add(todo);
      txtcontroller.text = '';
      _saveString(Todo(txtcontroller.text));
    });
  }

  void deleteTodo(Todo todo) {
    setState(() {
      items.remove(todo);
    });
  }

  void toggleTodo(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  @override
  void initState() {
    super.initState();
    storage = new Storage();
    storage.readCounter().then((Todo todo) {
      setState(() {
        items.add(todo);
      });
    });
  }

  Future<File> _saveString(Todo todo) {
    for (int i = 0; i < items.length; i++) {
      print(items[i]);
    }
    items.add(todo);
    if (todo.isDone == true) {
      return storage.writeCounter(todo.title);
    } else {
      return storage.writeCounter(todo.title, todo.isDone);
    }
  }

  @override
  void dispose() {
    txtcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('할일 관리 앱'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: items.map((todo) => bulidItemWidget(todo)).toList(),
            ),
          ),
          Row(
            children: [
              Flexible(
                child: TextField(
                  controller: txtcontroller,
                ),
              ),
              FlatButton(
                  onPressed: () => addTodo(Todo(txtcontroller.text)),
                  child: Text('text 저장하기')),
            ],
          ),
        ],
      ),
    );
  }

  Widget bulidItemWidget(Todo todo) {
    return ListTile(
      leading: Icon(
        iconChanger ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: Colors.blue,
      ),
      onTap: () {
        setState(() {
          if (iconChanger == true) {
            iconChanger = false;
          } else {
            iconChanger = true;
          }
          toggleTodo(todo);
        });
      },
      title: Text(
        todo.title,
        style: todo.isDone
            ? TextStyle(
                decoration: TextDecoration.lineThrough,
                fontStyle: FontStyle.italic)
            : null,
      ),
      trailing: IconButton(
          color: Colors.blue,
          icon: Icon(Icons.delete_forever),
          onPressed: () => deleteTodo(todo)),
    );
  }
}
