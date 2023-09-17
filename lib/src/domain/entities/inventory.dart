import 'package:cloud_firestore/cloud_firestore.dart';

class Inventory {
  String inventoryId;
  String product;
  int quantity;
  double price;
  double salePrice;

  Inventory(
      {required this.inventoryId,
      required this.product,
      required this.quantity,
      required this.price,
      required this.salePrice});

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
        product: json['product'],
        quantity: json['quantity'],
        inventoryId: json['inventoryId'],
        price: json['price'],
        salePrice: json['salePrice']);
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
      inventoryId: snapshot.id,
      product: data['product'],
      quantity: data['quantity'],
      price: data['price'],
      salePrice: data['salePrice'],
    );
  }
}
