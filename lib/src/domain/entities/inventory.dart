import 'package:cloud_firestore/cloud_firestore.dart';

class Inventory {
  String? inventoryId;
  String product;
  int quantity;

  Inventory({
    this.inventoryId,
    required this.product,
    required this.quantity,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
        product: json['product'],
        quantity: json['quantity'],
        inventoryId: json['inventoryId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product,
      'quantity': quantity,
      'inventoryId': inventoryId
    };
  }

  static fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Inventory(
      inventoryId: data['inventoryId'] ?? '',
      product: data['product'] ?? '',
      quantity: data['quantity'] ?? '',
    );
  }
}
