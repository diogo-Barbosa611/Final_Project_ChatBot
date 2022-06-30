// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, import_of_legacy_library_into_null_safe, unused_import, unnecessary_new, prefer_const_declarations, avoid_print, annotate_overrides, deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Rotina extends StatefulWidget {
  const Rotina({Key? key}) : super(key: key);

  @override
  State<Rotina> createState() => _RotinaState();
}

class _RotinaState extends State<Rotina> {
  var horaController = TextEditingController();
  var contadorController = TextEditingController();
  var medicamentoController = TextEditingController();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/calendarioAtu.txt');
  }

  Future<File> writeCalendar(
      String hora, String cont, String medicamento) async {
    final file = await _localFile;
    // Write the file
    print('vou escrever isto: ' '$hora;$cont;$medicamento');
    return file.writeAsString('$hora;$cont;$medicamento ',
        mode: FileMode.append);
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    horaController.dispose();
    contadorController.dispose();
    medicamentoController.dispose();
    super.dispose();
  }

  void onSubmit() {
    final hora = double.tryParse(horaController.text) ?? 9;
    final cont = double.tryParse(contadorController.text);
    final medicamento = medicamentoController.text;
    if (hora < 0 || hora > 24) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Digite um valor na hora de 00.00 a 24.00'),
            );
          });
      return;
    }

    if (cont == null || medicamento.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Preencha os campos todos '),
            );
          });
      return;
    }

    if (medicamento.contains(' ')) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('O medicamento não pode ter espaços'),
            );
          });
      return;
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Parabéns adicionou o $medicamento à lista'),
          );
        });

    writeCalendar(hora.toString(), cont.toString(), medicamento);

    horaController.text = '';
    medicamentoController.text = '';
    contadorController.text = '';
  }

  writeOnFile() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              TextField(
                  controller: medicamentoController,
                  onSubmitted: (_) => onSubmit(),
                  decoration: InputDecoration(
                    labelText: 'Drug name',
                  )),
              TextField(
                  controller: contadorController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (_) => {},
                  decoration: InputDecoration(
                    labelText: 'How many times a day?',
                  )),
              TextField(
                controller: horaController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => onSubmit(),
                decoration: InputDecoration(
                  labelText: 'Time of the first alarm',
                  labelStyle: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  onPressed: () => {onSubmit()},
                  textColor: Colors.blueGrey,
                  child: const Text('Register and go back!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
