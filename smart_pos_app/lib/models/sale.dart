class Sale {
  final int? id;
  final String saleDate; // ISO date string (date only)
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final String timestamp; // ISO datetime

  Sale({
    this.id,
    required this.saleDate,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.timestamp,
  });

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'] as int?,
      saleDate: map['sale_date'] as String,
      subtotal: (map['subtotal'] as num).toDouble(),
      discount: (map['discount'] as num).toDouble(),
      tax: (map['tax'] as num).toDouble(),
      total: (map['total'] as num).toDouble(),
      timestamp: map['timestamp'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'sale_date': saleDate,
      'subtotal': subtotal,
      'discount': discount,
      'tax': tax,
      'total': total,
      'timestamp': timestamp,
    };
  }
}
