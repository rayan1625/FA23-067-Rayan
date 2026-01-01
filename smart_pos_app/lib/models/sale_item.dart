class SaleItem {
  final int? id;
  final int saleId;
  final int productId;
  final int quantity;
  final double priceAtSale;
  final double lineTotal;

  SaleItem({
    this.id,
    required this.saleId,
    required this.productId,
    required this.quantity,
    required this.priceAtSale,
    required this.lineTotal,
  });

  factory SaleItem.fromMap(Map<String, dynamic> map) {
    return SaleItem(
      id: map['id'] as int?,
      saleId: map['sale_id'] as int,
      productId: map['product_id'] as int,
      quantity: map['quantity'] as int,
      priceAtSale: (map['price_at_sale'] as num).toDouble(),
      lineTotal: (map['line_total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'sale_id': saleId,
      'product_id': productId,
      'quantity': quantity,
      'price_at_sale': priceAtSale,
      'line_total': lineTotal,
    };
  }
}
