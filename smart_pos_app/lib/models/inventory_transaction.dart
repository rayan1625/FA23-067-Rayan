class InventoryTransaction {
  final int? id;
  final int productId;
  final String type; // 'in' or 'out'
  final int quantity;
  final String? note;
  final String timestamp; // ISO string

  InventoryTransaction({
    this.id,
    required this.productId,
    required this.type,
    required this.quantity,
    this.note,
    required this.timestamp,
  });

  factory InventoryTransaction.fromMap(Map<String, dynamic> map) {
    return InventoryTransaction(
      id: map['id'] as int?,
      productId: map['product_id'] as int,
      type: map['type'] as String,
      quantity: map['quantity'] as int,
      note: map['note'] as String?,
      timestamp: map['timestamp'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'product_id': productId,
      'type': type,
      'quantity': quantity,
      'note': note,
      'timestamp': timestamp,
    };
  }
}
