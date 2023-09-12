class Customer {
  int id;
  String firstName;
  String lastName;
  String cedula;
  String phoneNumber;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.cedula,
    required this.phoneNumber,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      cedula: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': cedula,
      'phoneNumber': phoneNumber,
    };
  }
}
