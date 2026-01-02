class LedgerEntry {
  final int? id;
  final int customerId;
  final int? saleId;
  final double amount; // positive for debit (sale), negative for credit (payment) per earlier spec we will also keep type
  final String type; // 'debit' or 'credit'
  final String? description;
  final String timestamp;

  LedgerEntry({
    this.id,
    required this.customerId,
    this.saleId,
    required this.amount,
    required this.type,
    this.description,
    required this.timestamp,
  });

  factory LedgerEntry.fromMap(Map<String, dynamic> map) {
    return LedgerEntry(
      id: map['id'] as int?,
      customerId: map['customer_id'] as int,
      saleId: map['sale_id'] as int?,
      amount: (map['amount'] as num).toDouble(),
      type: map['type'] as String,
      description: map['description'] as String?,
      timestamp: map['timestamp'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'customer_id': customerId,
      'sale_id': saleId,
      'amount': amount,
      'type': type,
      'description': description,
      'timestamp': timestamp,
    };
  }
}
