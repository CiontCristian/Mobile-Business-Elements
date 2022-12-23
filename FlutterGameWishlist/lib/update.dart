
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DBUtils.dart';
import 'Game.dart';
import 'main.dart';

class Update extends StatefulWidget {
  late Game game;
  late int position;

  Update(Game game, int position){
    this.game = game;
    this.position = position;
  }

  @override
  UpdateState createState() => UpdateState(game, position);

}

class UpdateState extends State<Update>{
  Game game;
  int position;
  final titleEdit = TextEditingController();
  final developerEdit = TextEditingController();
  final priceEdit = TextEditingController();
  final ratingEdit = TextEditingController();
  final genreEdit = TextEditingController();
  Pegi18 radioValue = Pegi18.No;

  UpdateState(this.game, this.position){
    this.game = game;
    this.position = position;
    titleEdit.text = game.title;
    developerEdit.text = game.developer;
    priceEdit.text = game.price.toString();
    ratingEdit.text = game.rating.toString();
    genreEdit.text = game.genre;
    radioValue = game.pegi18 == "Yes" ? Pegi18.Yes : Pegi18.No;
  }


  void update(Game updatedGame) async{
    await DBUtils.updateGame(updatedGame);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update " + game.title),
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
                Game updatedGame = Game(game.id, titleEdit.text.toString(), developerEdit.text.toString(), double.parse(priceEdit.text), double.parse(ratingEdit.text), genreEdit.text.toString(), radioValue.toString().split('.').last);
                update(updatedGame);
                Navigator.pop(context);
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