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
    print('$path/counter.txt');
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
      });
    });
  }

  Future<File> _saveString() {
    setState(() {
      writeText = txtcontroller.text;
    });
    for (int i = 0; i < readText.length; i++) {
      print(readText[i]);
    }
    index++;
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
            child: ListView.builder(
              itemCount: readText.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Row(
                    children: [Icon(Icons.radio), Text('$readText')],
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Flexible(
                child: TextField(
                  controller: txtcontroller,
                ),
              ),
              FlatButton(onPressed: _saveString, child: Text('text 저장하기')),
            ],
          ),
        ],
      ),
    );
  }
}

// abstract class ListItem{
//   Widget buildTitle(BuildContext context);

//   Widget buildIcon
// }
