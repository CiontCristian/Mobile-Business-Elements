import 'model/TransactionObj.dart';
import 'package:http/http.dart';
import 'dart:convert';

class APIUtils{
  final String url = "http://10.0.2.2:8080/wallet";

  Future<List<TransactionObj>> findAll() async {
    Response response = await get("$url/findAll");

    if (response.statusCode == 200) {
      print("Transactions retrieved from API");
      List<dynamic> body = jsonDecode(response.body);
      List<TransactionObj> transactions = body.map((dynamic item) => TransactionObj.fromJson(item)).toList();
      return transactions;
    } else {
      throw "Failed to load transactions list";
    }
  }

  Future<TransactionObj> insertTransaction(TransactionObj transaction) async {

    final Response response = await post(
      "$url/insertTransaction",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(transaction.toMap()),
    );
    if (response.statusCode == 200) {
      print("Transaction inserted from API");
      return TransactionObj.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to post Transaction');
    }
  }

  Future<void> deleteTransaction(int id) async {
    Response response = await delete("$url/deleteTransaction/$id");

    if (response.statusCode == 200) {
      print("Transaction deleted from API");
    } else {
      throw "Failed to delete Transaction.";
    }
  }

}