
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DBUtils.dart';
import 'Game.dart';
import 'main.dart';

class Add extends StatefulWidget {

  Add();

  @override
  AddState createState() => AddState();

}

class AddState extends State<Add>{

  final titleEdit = TextEditingController();
  final developerEdit = TextEditingController();
  final priceEdit = TextEditingController();
  final ratingEdit = TextEditingController();
  final genreEdit = TextEditingController();
  Pegi18 radioValue = Pegi18.No;


  @override
  void initState() {
    super.initState();
  }


  void add(Game newGame) async{
    await DBUtils.insertGame(newGame);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expand wishlist"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 100.0,
                      margin: const EdgeInsets.only(right: 10.0),
                      child: Text("Title")),
                  Container(
                      width: 100.0,
                      child: TextField(
                        controller: titleEdit,

                      ))]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 100.0,
                      margin: const EdgeInsets.only(right: 10.0),
                      child: Text("Developer")),
                  Container(
                      width: 100.0,
                      child: TextField(
                        controller: developerEdit,

                      ))]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 100.0,
                      margin: const EdgeInsets.only(right: 10.0),
                      child: Text("Price")),
                  Container(
                      width: 100.0,
                      child: TextField(
                        controller: priceEdit,

                      ))]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 100.0,
                      margin: const EdgeInsets.only(right: 10.0),
                      child: Text("Rating")),
                  Container(
                      width: 100.0,
                      child: TextField(
                        controller: ratingEdit,

                      ))]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 100.0,
                      margin: const EdgeInsets.only(right: 10.0),
                      child: Text("Genre")),
                  Container(
                      width: 100.0,
                      child: TextField(
                        controller: genreEdit,

                      ))]),
            Container(
                width: 100.0,
                margin: const EdgeInsets.only(right: 100.0, top: 50.0),
                child: Text("Pegi18")),
            Container(
                margin: const EdgeInsets.only(left: 175.0),
                child:
                ListTile(
                  title: const Text('Yes'),
                  leading: Radio(
                    value: Pegi18.Yes,
                    groupValue: radioValue,
                    onChanged: (value) {
                      setState(() {
                        radioValue = value!;
                      });
                    },
                  ),
                )
            ),
            Container(
                margin: const EdgeInsets.only(left: 175.0),
                child:
                ListTile(
                  title: const Text('No'),
                  leading: Radio(
                    value: Pegi18.No,
                    groupValue: radioValue,
                    onChanged: (value) {
                      setState(() {
                        radioValue = value!;
                      });
                    },
                  ),
                )
            ),
            ElevatedButton(
              child: Text('Confirm'),
              onPressed: () {
                Game newGame = Game(null, titleEdit.text, developerEdit.text, double.parse(priceEdit.text), double.parse(ratingEdit.text), genreEdit.text, radioValue.toString().split('.').last);
                add(newGame);
                Navigator.pop(context, newGame);
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleEdit.dispose();
    developerEdit.dispose();
    priceEdit.dispose();
    ratingEdit.dispose();
    genreEdit.dispose();
  }

}