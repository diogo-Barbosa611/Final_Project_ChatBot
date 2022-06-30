// ignore_for_file: file_names, avoid_print, sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:nonoapp/Models/Medicacao.dart';

class AssistenteOp extends StatelessWidget {
  final List<Medicacao> meds;
  const AssistenteOp({Key? key, required this.meds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NoNo Assistant Section'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        height: double.infinity,
        child: meds.isEmpty
            ? Column(
                children: const <Widget>[
                  Text(
                    'No medicine schedule',
                  ),
                ],
              )
            : ListView.builder(
                itemCount: meds.length,
                itemBuilder: (context, index) {
                  final med = meds.elementAt(index);
                  var intervalo = 14 / med.contador;

                  String texto = '';
                  for (int i = 0; i < med.contador; i++) {
                    var aux = (med.hora + (intervalo * i)).toStringAsFixed(2);
                    double myDouble = med.hora + (intervalo * i);
                    double fraction = myDouble - myDouble.truncate();
                    int result = (fraction * 100).truncate();
                    if (myDouble.truncate() >= 24) {
                      aux =
                          (med.hora + (intervalo * i) - 24).toStringAsFixed(2);
                    }
                    if (result > 60) {
                      aux = (med.hora + (intervalo * i))
                          .truncate()
                          .toStringAsFixed(2);
                      if (myDouble.truncate() >= 24) {
                        aux = (med.hora + (intervalo * i) - 24)
                            .truncate()
                            .toStringAsFixed(2);
                      }
                    }

                    if (i == 0) {
                      texto = aux;
                    } else {
                      texto = '$texto  |  $aux';
                    }
                  }
                  return Container(
                    color: Colors.amber.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Drug Name: ${med.nome}',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Text('Hours: $texto'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
