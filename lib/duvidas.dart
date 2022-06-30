// ignore_for_file: file_names, avoid_print, sized_box_for_whitespace, prefer_const_constructors, use_key_in_widget_constructors, sort_child_properties_last

import 'package:flutter/material.dart';

class Duvidas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Help Section')),
      ),
      body: Container(
        height: double.infinity,
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(25, 75, 25, 45),
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: ButtonTheme(
                    minWidth: 500,
                    height: 350,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      child: Text(
                        'This app was made by Diogo Barbosa. On the main page there are 3 buttons. If you click the first you are taken to a page that allows you to schedule your medicines so you dont forget. The midle one, if you click you will talk with NoNo. NoNo will help to find an answer about medicines or drugs you may be taking. If you press the last button you can see your history of medicine and questions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.amber.withOpacity(0.8),
                      elevation: 10,
                      onPressed: () => {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
