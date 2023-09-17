import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String? customerId;
  String firstName;
  String lastName;
  String cedula;
  String phoneNumber;

  Customer({
    this.customerId,
    required this.firstName,
    required this.lastName,
    required this.cedula,
    required this.phoneNumber,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      cedula: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'firstName': firstName,
      'lastName': lastName,
      'email': cedula,
      'phoneNumber': phoneNumber,
    };
  }

  static fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Customer(
      customerId: snapshot.id,
      phoneNumber: data['PhoneNumber'] ?? '',
      cedula: data['Cedula'] ?? '',
      firstName: data['FirstName'] ?? '',
      lastName: data['LastName'] ?? '',
    );
  }
}
