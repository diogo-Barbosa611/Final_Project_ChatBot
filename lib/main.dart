// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, deprecated_member_use, avoid_print
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nonoapp/Models/Medicacao.dart';
import 'package:nonoapp/assistenteOp.dart';
import 'package:nonoapp/rotina.dart';
import 'package:path_provider/path_provider.dart';
import 'chatbot.dart';
import 'duvidas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoNo Bot',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const MyHomePage(title: 'NoNo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Medicacao> _meds = [];

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/calendarioAtu.txt');
  }

  Future<String> readCalendar() async {
    try {
      final file = await _localFile;
      _meds.clear();
      final contents = await file.readAsString();
      //print(contents);

      var linha = contents.split(' ');

      print(linha.toString());
      //var linhaSep
      for (var item in linha) {
        var cenas = item.split(';');
        double contador = double.tryParse(cenas[1]) ?? 1;
        double hora = double.tryParse(cenas[0]) ?? 9;
        Medicacao med1 =
            Medicacao(nome: cenas[2], contador: contador, hora: hora);
        setState(() {
          _meds.add(med1);
        });
      }

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    readCalendar();
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 40),
                    child: Text(
                      "Hello I am NoNo \n Press on the button to do the action",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 25, 30, 25),
                  child: RaisedButton(
                    elevation: 10,
                    color: Colors.amber,
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Rotina()),
                      ),
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Schedule your medicines',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 25, 30, 25),
                  child: RaisedButton(
                    color: Colors.amber,
                    elevation: 10,
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChatBot()),
                      ),
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Chat with NoNo',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 40),
                  child: RaisedButton(
                    color: Colors.amber,
                    elevation: 10,
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AssistenteOp(meds: _meds)),
                      ),
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Assistant / Family',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
                  child: FloatingActionButton(
                    onPressed: (() => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Duvidas()),
                          ),
                        }),
                    backgroundColor: Colors.amber, //withOpacity(0.8),
                    child: Icon(
                      Icons.question_mark_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  'To explain some doubts press button above',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
