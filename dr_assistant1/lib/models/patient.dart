class Patient {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String dateOfBirth;
  final String gender;
  final String address;
  final String notes;
  final String imagePath;
  final String createdAt;
  final String updatedAt;

  Patient({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.notes,
    required this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  int get age {
    final birthDate = DateTime.parse(dateOfBirth);
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'] ?? '',
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      address: json['address'],
      notes: json['notes'] ?? '',
      imagePath: json['imagePath'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'address': address,
      'notes': notes,
      'imagePath': imagePath,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
    }
}
