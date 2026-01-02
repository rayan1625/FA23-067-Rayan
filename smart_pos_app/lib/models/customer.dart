class Customer {
  final int? id;
  final String name;
  final String? phone;
  final String? address;
  final bool isRegular;
  final String createdAt;

  Customer({
    this.id,
    required this.name,
    this.phone,
    this.address,
    required this.isRegular,
    required this.createdAt,
  });

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] as int?,
      name: map['name'] as String,
      phone: map['phone'] as String?,
      address: map['address'] as String?,
      isRegular: (map['is_regular'] as int) == 1,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'is_regular': isRegular ? 1 : 0,
      'created_at': createdAt,
    };
  }
}
