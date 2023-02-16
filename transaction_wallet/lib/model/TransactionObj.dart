
class TransactionObj{
  int? id;
  String recipient;
  double amount;
  String currency;

  TransactionObj(this.id, this.recipient, this.amount, this.currency);

  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'recipient': recipient,
      'amount': amount,
      'currency' : currency
    };
    //map.removeWhere((key, value) => value == null);
    return map;
  }

  factory TransactionObj.fromJson(Map<String, dynamic> json) {
    TransactionObj transaction = TransactionObj(json['id'], json['recipient'].toString(), json['amount'], json['currency'].toString());
    return transaction;
  }

  @override
  String toString() {
    return '$recipient, $amount, $currency';
  }
}