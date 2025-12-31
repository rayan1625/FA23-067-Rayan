class Product {
  final int? id;
  final String sku;
  final String name;
  final double price;
  final double cost;
  final String category;
  final int stockQuantity;

  Product({
    this.id,
    required this.sku,
    required this.name,
    required this.price,
    required this.cost,
    required this.category,
    required this.stockQuantity,
  });

  Product copyWith({
    int? id,
    String? sku,
    String? name,
    double? price,
    double? cost,
    String? category,
    int? stockQuantity,
  }) {
    return Product(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      category: category ?? this.category,
      stockQuantity: stockQuantity ?? this.stockQuantity,
    );
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      sku: map['sku'] as String,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      cost: (map['cost'] as num).toDouble(),
      category: map['category'] as String,
      stockQuantity: map['stock_quantity'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'sku': sku,
      'name': name,
      'price': price,
      'cost': cost,
      'category': category,
      'stock_quantity': stockQuantity,
    };
  }
}
