import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
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

  Future<String> readCounter() async {
    try {
      final file = await _localFile;

      // 파일 읽기
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // 에러가 발생할 경우 0을 반환
      return "";
    }
  }

  Future<File> writeCounter(String counter, int index) async {
    final file = await _localFile;

    print('$counter $index');
    // 파일 쓰기
    return file.writeAsString('$counter $index', mode: FileMode.append);
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  var txtcontroller = TextEditingController();
  int index = 0;
  String writeText;
  List<String> readText = List<String>(1000);
  Storage storage;

  @override
  void initState() {
    super.initState();
    storage = new Storage();
    storage.readCounter().then((String value) {
      setState(() {
        readText[index] = value;
        index++;
      });
    });
  }

  Future<File> _saveString() {
    setState(() {
      writeText = txtcontroller.text;
    });
    print(writeText);
    return storage.writeCounter(writeText, index);
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
          Flexible(
            child: TextField(
              controller: txtcontroller,
            ),
          ),
          FlatButton(onPressed: _saveString, child: Text('text 저장하기')),
          Text('${readText[0]}'),
        ],
      ),
    );
  }
}
