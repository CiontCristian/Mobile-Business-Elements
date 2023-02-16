import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:transaction_wallet/model/Operation.dart';
import 'package:transaction_wallet/model/TransactionObj.dart';

import 'APIUtils.dart';
import 'DBUtils.dart';
import 'add.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transaction Wallet',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Transaction Wallet'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool connected = false;
  final APIUtils api = APIUtils();
  final List<int> colorCodes = <int>[600, 500, 100];
  Future<List<TransactionObj>>? transactionList;
  List<TransactionObj> localTransactionList = [];
  Connectivity connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? subscription;

  @override
  void initState() {
    super.initState();
    _checkConnectivityOnAppStart();
    _checkConnectivityOnChange();
  }

  void _refresh() {
    setState(() {});
  }

  void _checkConnectivityOnAppStart() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      print("No Internet!");
      localTransactionList = await DBUtils.findAll();
      setState(() {
        transactionList = DBUtils.findAll();
        connected = false;
      });
    } else if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      print("Internet");
      localTransactionList = await api.findAll();
      setState(() {
        transactionList = api.findAll();
        connected = true;
      });
    }
  }

  void _checkConnectivityOnChange() async {
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          var conn = getConnectionValue(result);
          setState(() {
            connected = conn;
          });
          if (connected) {
            print("Internet!");
            transactionList = api.findAll();
          } else {
            print("No Internet!");
            transactionList = DBUtils.findAll();
          }
        });
  }

  bool getConnectionValue(var connectivityResult) {
    bool status;
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        status = true;
        break;
      case ConnectivityResult.wifi:
        status = true;
        break;
      case ConnectivityResult.none:
        status = false;
        break;
      default:
        status = false;
        break;
    }
    return status;
  }

  void _refreshAfterAdd(var addedTransaction) {
    if (addedTransaction != null) {
      localTransactionList.add(addedTransaction);
      setState(() {});
    }
  }

  void _refreshAfterDelete(int? id, int index) async {
    localTransactionList.removeAt(index);
    List<Operation> operationForCurrentTransaction = await DBUtils.findOperationByTid(id!);
    _refresh();

    if(!connected){
      if(operationForCurrentTransaction.isNotEmpty){
        await DBUtils.deleteTransaction(id);
        print("Insert operation $id removed because of deletion");
        await DBUtils.deleteOperation(operationForCurrentTransaction[0].id!);
      }
      else{
        Operation operation = Operation(null, "remove", id);
        await DBUtils.insertOperation(operation);
      }

    }
    else{
      await DBUtils.deleteTransaction(id);
      await api.deleteTransaction(id);
    }
  }

  void _navigateToAddPage() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Add()))
        .then((state) => _refreshAfterAdd(state));
  }

  void _synchronizeWithServer() async {
    List<TransactionObj> transactions = await DBUtils.findAllUnsynchronized();
    List<Operation> operations = await DBUtils.findAllOperations();

    if(operations.length != 0)
      for (Operation operation in operations) {
        if (operation.action == "insert") {
          print("Transaction saved to API ${operation.tid}");
          api.insertTransaction(transactions
              .where((transaction) => transaction.id == operation.tid)
              .first);
        }
        else if (operation.action == "remove") {
          print("Transaction removed from API ${operation.tid}");
          api.deleteTransaction(operation.tid);
          DBUtils.deleteTransaction(operation.tid);
        }
      }
      for (Operation operation in operations) {
        DBUtils.deleteOperation(operation.id!);
        print("Operation deleted ${operation.id!}");
      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Column(children: <Widget>[
        Center(
            child: Row(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text('Recipient',
                      style: TextStyle(
                        height: 3.0,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ))),
              Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text('Amount',
                      style: TextStyle(
                        height: 3.0,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ))),
              Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text('Currency',
                      style: TextStyle(
                        height: 3.0,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ))),
            ])),
        Expanded(
            child: FutureBuilder(
                initialData: [],
                future: transactionList,
                builder: (context, snapshot) {
                  if (connected) _synchronizeWithServer();
                  return snapshot.connectionState == ConnectionState.done
                      ? ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: localTransactionList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 50,
                          color: Colors.amber[colorCodes[index % 3]],
                          child: GestureDetector(
                            child: Center(
                                child:
                                Text(localTransactionList[index].toString())),
                            onLongPress: () =>
                                showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                  title: const Text('Erase from wallet'),
                                  content: Text(
                                      'Are you sure you want to delete ${localTransactionList[index].recipient} ?'),
                                  actions: [
                                    TextButton(
                                      child: Text('No'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Yes'),
                                      onPressed: () {
                                        setState(() {
                                          TransactionObj selectedTransaction = localTransactionList[index];
                                          _refreshAfterDelete(
                                              selectedTransaction.id, index);
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ]),
                                )
                          ),
                        );
                      })
                      : const Center(
                    child: CircularProgressIndicator(),
                  );
                }))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddPage(),
        tooltip: 'Go to Add',
        child: const Icon(Icons.add),
      ), // T
    );
  }



}
