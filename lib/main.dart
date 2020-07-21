import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _todDoController = TextEditingController();

  List _todoList = [];

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _todDoController.text;
      _todDoController.text = "";
      newToDo["ok"] = false;
      _todoList.add(newToDo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller:_todDoController,
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(color: Colors.blueGrey)
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.blueGrey,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: _addToDo,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: _todoList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(_todoList[index]["title"]),
                    value: _todoList[index]["ok"],
                    secondary: CircleAvatar(
                      child: Icon(_todoList[index]["ok"] ? Icons.check : Icons.error),
                    ),
                    onChanged: (c){
                      setState(() {
                        _todoList[index]["ok"] = c;
                      });
                    },
                  );
                }
            ),
          )
        ],
      ),
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory(); //pega o diretório onde armazenamos documentos de um app
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_todoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try{
      final file = await _getFile();
      return file.readAsString();
    } catch(e) {
      return null;
    }
  }

}

