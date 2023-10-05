import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryDetail {
  String inventoryId;
  String inventoryDetailId;
  String productName;
  int quantity;
  double salePrice;
  String saleDate;

  InventoryDetail(
      {required this.inventoryId,
      required this.inventoryDetailId,
      required this.productName,
      required this.quantity,
      required this.salePrice,
      required this.saleDate});

  static fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return InventoryDetail(
        inventoryDetailId: snapshot.id,
        productName: data['productName'],
        quantity: data['quantity'],
        salePrice: data['salePrice'],
        saleDate: data['saleDate'],
        inventoryId: data['inventoryId']);
  }
}
