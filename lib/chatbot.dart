// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_collection_literals, deprecated_member_use, import_of_legacy_library_into_null_safe, non_constant_identifier_names, prefer_const_declarations, unused_local_variable, unused_field

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';
import 'package:nonoapp/Models/Mensagem.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({Key? key}) : super(key: key);

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final messageInsert = TextEditingController();

  late stt.SpeechToText speech;
  bool _isListening = false;

  List<Mensagem> messages = <Mensagem>[];
  String name = "";
  Future<void> Post() async {
    final url = 'http://10.0.2.2:5000/name';
    String name = ""; //user's response will be assigned to this variable
    String final_response = "";
    name = messageInsert.toString();
    //sending a post request to the url
    final response = await http.post(url, body: json.encode({'name': name}));
  }

  Future<void> GetResponse() async {
    final url = 'http://10.0.2.2:5000/name';
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        speech.listen(
          onResult: (val) => setState(() {
            messageInsert.text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      speech.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with NoNo'),
      ),
      body: Container(
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
              child: ListTile(
                title: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color.fromRGBO(220, 220, 220, 1),
                  ),
                  padding: EdgeInsets.fromLTRB(15, 13, 0, 0),
                  child: TextFormField(
                    controller: messageInsert,
                    decoration: InputDecoration(
                      hintText: "Enter a Message...",
                      hintStyle: TextStyle(color: Colors.black26),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    onChanged: (value) {},
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.send,
                    size: 30.0,
                    color: Colors.greenAccent,
                  ),
                  onPressed: () async {
                    if (messageInsert.text.isEmpty == false) {
                      String label = messageInsert.text;
                      //print(messageInsert.text);
                      Timer(Duration(seconds: 7), () async {
                        final url = 'http://10.0.2.2:5000/name';
                        //user's response will be assigned to this variable
                        String final_response = "";
                        name = label;
                        //sending a post request to the url
                        print(label);
                        final response = await http.post(url,
                            body: json.encode({'name': name}));
                      });
                      Timer(Duration(seconds: 13), () async {
                        //getting data from the python server script and assigning it to response
                        final url = 'http://10.0.2.2:5000/name';
                        final response = await http.get(url);

                        //converting the fetched data from json to key value pair that can be displayed on the screen
                        final decoded =
                            json.decode(response.body) as Map<String, dynamic>;
                        Mensagem m1 =
                            Mensagem(msg: messageInsert.text, BOT: false);

                        Mensagem botReply =
                            Mensagem(msg: decoded['name'], BOT: true);

                        setState(() {
                          messages.add(m1);
                          messages.add(botReply);
                          messageInsert.text = '';
                        });
                      });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content:
                                  Text('Write something on the label above'),
                            );
                          });
                      return;
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 450,
                child: messages.isEmpty
                    ? Column(
                        children: const <Widget>[
                          Text('Write Something Up There I will answer'),
                        ],
                      )
                    : ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages.elementAt(index);
                          print(msg.BOT);
                          if (msg.BOT == true) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(10, 2, 150, 2),
                              child: Card(
                                elevation: 5,
                                color: Colors.amber,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    msg.msg,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(150, 2, 10, 2),
                              child: Card(
                                elevation: 5,
                                color: Colors.cyan.withOpacity(0.35),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Text(
                                    msg.msg,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
              ),
            ),
            /*
            Container(
              child: Center(
                child: FloatingActionButton(
                  onPressed: () => _listen,
                  backgroundColor: Colors.amber, //withOpacity(0.8),
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: Colors.white,
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
