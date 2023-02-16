
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transaction_wallet/model/TransactionObj.dart';

import 'APIUtils.dart';
import 'DBUtils.dart';
import 'model/Operation.dart';

class Add extends StatefulWidget {

  Add();

  @override
  AddState createState() => AddState();

}

class AddState extends State<Add>{
  final APIUtils api = APIUtils();

  final recipientEdit = TextEditingController();
  final amountEdit = TextEditingController();
  String currency = "EUR";
  var availableCurrencies = [
    'EUR',
    'USD',
    'RON',
    'GBP'
  ];
  bool connected = false;

  @override
  void initState() {
    super.initState();
    _checkInternetConnectivity();
  }

  void _checkInternetConnectivity() async{
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none){
      print("No Internet!");
      setState(() {
        connected = false;
      });
    }
    else if(result == ConnectivityResult.wifi || result == ConnectivityResult.mobile){
      print("Internet");
      setState(() {
        connected = true;
      });
    }
  }


  void add(TransactionObj newTransaction) async{
    var id = await DBUtils.insertTransaction(newTransaction);
    newTransaction.id = id;

    if(!connected){
      Operation operation = Operation(null, "insert", id);
      print("Insert operation created!");
      await DBUtils.insertOperation(operation);
    }
    else{
      await api.insertTransaction(newTransaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new transaction to wallet"),
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
                      child: const Text("Recipient")),
                  Container(
                      width: 100.0,
                      child: TextField(
                        controller: recipientEdit,

                      ))]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 100.0,
                      margin: const EdgeInsets.only(right: 10.0),
                      child: const Text("Amount")),
                  Container(
                      width: 100.0,
                      child: TextField(
                        controller: amountEdit,

                      ))]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 100.0,
                      margin: const EdgeInsets.only(right: 10.0),
                      child: const Text("Currency")),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton(
                        value: currency,
                        icon: const Icon(Icons.keyboard_arrow_down),

                        items: availableCurrencies.map((String availableCurrencies) {
                          return DropdownMenuItem(
                            value: availableCurrencies,
                            child: Text(availableCurrencies),
                          );
                        }).toList(),

                        onChanged: (String? newValue) {
                          setState(() {
                            currency = newValue!;
                          });
                        },
                      ),
                    ],
                  )
                ]),

            ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () {
                TransactionObj newTransaction = TransactionObj(null, recipientEdit.text, double.parse(amountEdit.text), currency);
                add(newTransaction);
                Navigator.pop(context, newTransaction);
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
    recipientEdit.dispose();
    amountEdit.dispose();
  }

}