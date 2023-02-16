class Operation{
  int? id;
  String action;
  int tid;

  Operation(this.id, this.action, this.tid);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'action': action,
      'tid': tid
    };
  }

  @override
  String toString() {
    return 'Operation{id: $id, action: $action, tid: $tid}';
  }
}