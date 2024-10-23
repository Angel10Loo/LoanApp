// import 'package:firebase_auth/firebase_auth.dart';
// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:loan_app/src/domain/entities/amortization.dart';
import 'package:loan_app/src/domain/entities/customer.dart';
import 'package:loan_app/src/domain/entities/income.dart';
import 'package:loan_app/src/domain/entities/inventory.dart';
import 'package:loan_app/src/domain/entities/inventory_detail.dart';
import 'package:loan_app/src/domain/entities/loan.dart';
import 'package:loan_app/src/domain/enums/term_type.dart';
import 'package:loan_app/src/utils/helper.dart';

class FirebaseService {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Authentication methods

  // Future<User?> signInWithEmailAndPassword(String email, String password) async {
  //   try {
  //     final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return userCredential.user;
  //   } catch (e) {
  //     print('Error signing in: $e');
  //     return null;
  //   }
  // }

  // Future<void> signOut() async {
  //   await _auth.signOut();
  // }

  // FireStore Loans

  Future<List<Income>> getIncomes() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection("Incomes").get();

      List<Income> incomes = [];
      for (QueryDocumentSnapshot document in snapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        incomes.add(Income(
          incomeId: document.id,
          income: data['income'] as double,
          createdDate: data['createdDate'] ?? '',
        ));
      }
      return incomes;
    } catch (e) {
      print(e);
      return List.empty();
    }
  }

  Future<Income> getIncome() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection("Incomes")
        .orderBy("createdDate", descending: true)
        .limit(1)
        .get();
    final Income income;
    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> document = snapshot.docs.first;
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      income = Income(
        incomeId: document.id,
        income: data["income"],
        createdDate: data['createdDate'] ?? '',
      );
      return income;
    } else {
      print('No document found for the given date.');
    }
    return Income(createdDate: Timestamp.fromDate(DateTime.now()), income: 0);
  }

  Future<void> updateIncome(double income) async {
    CollectionReference _incomes = _firestore.collection("Incomes");
    List<Income> incomes = await getIncomes();
    String incomeID = "";
    double incomeFromDb = 0;

    for (var income in incomes.where((element) =>
        Helper.isDateInCurrentMonth(element.createdDate.toDate()))) {
      incomeID = income.incomeId!;
      incomeFromDb = income.income;
    }
    if (incomeID.isEmpty) {
      try {
        await _incomes.add({
          "income": income,
          "createdDate": Timestamp.fromDate(DateTime.now()),
        });
      } catch (e) {
        print(e);
      }
    } else {
      try {
        incomeFromDb = incomeFromDb + income;
        await _incomes.doc(incomeID).update({"income": incomeFromDb});
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> updateAmortizationIsPayment(
      String amortizationId, bool isPayment) async {
    try {
      CollectionReference _inventories = _firestore.collection("Amortizations");
      await _inventories.doc(amortizationId).update({"isPayment": isPayment});
    } catch (e) {
      print(e);
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> getAmortizationBaseOnLoanId(
      String Id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection("Amortizations")
          .where("loanId", isEqualTo: Id)
          .get();

      return snapshot;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> deleteLoan(String loanId) async {
    try {
      CollectionReference _inventories = _firestore.collection("Loans");
      _inventories.doc(loanId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> getLoans() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection("Loans").get();
      return snapshot;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> saveAmortization(Amortization model) async {
    try {
      CollectionReference _loan = _firestore.collection("Amortizations");
      await _loan.add({
        'interest': model.interest,
        'principal': model.principal,
        'remainingBalance': model.remainingBalance,
        'loanId': model.loanId,
        'quote': model.quote,
        'period': model.period,
        'paymentDate': model.paymentDate,
        'isPayment': model.isPayment
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> saveLoan(Loan model) async {
    switch (model.termType) {
      case TermType.Mensual:
        model.termTypevalue = 'Mes';
        break;
      case TermType.Quincenal:
        model.termTypevalue = 'Quincena';
        break;
      case TermType.Semanal:
        model.termTypevalue = 'Semana';
        break;
      case TermType.Daily:
        model.termTypevalue = 'Diario';
        break;
      default:
        return 'Unknown';
    }

    try {
      CollectionReference _loan = _firestore.collection("Loans");
      var loanSaved = await _loan.add({
        'customerName': model.customerName,
        'amount': model.amount,
        'interest': model.interest,
        'period': model.period,
        'termTypevalue': model.termTypevalue,
        'createdDate': DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
      });
      return loanSaved.id;
    } catch (e) {
      print(e);
    }
    return "";
  }

  // FireStore InventoriesSele

  Future<QuerySnapshot<Map<String, dynamic>>?> getInventoySales(
      String Id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection("InventoriesSale")
          .where("inventoryId", isEqualTo: Id)
          .get();

      return snapshot;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> saveInventoySale(InventoryDetail model) async {
    try {
      CollectionReference _inventories =
          _firestore.collection("InventoriesSale");
      await _inventories.add({
        'inventoryId': model.inventoryId,
        'saleDate': model.saleDate,
        'productName': model.productName,
        'quantity': model.quantity,
        'salePrice': model.salePrice,
      });
    } catch (e) {
      print(e);
    }
  }

  // FireStore Inventories
  Future<void> updateInventoryQuantity(String inventoryId, int quantity) async {
    try {
      CollectionReference _inventories = _firestore.collection("Inventories");
      _inventories.doc(inventoryId).update({"quantity": quantity});
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteInventory(String inventoryId) async {
    try {
      CollectionReference _inventories = _firestore.collection("Inventories");
      _inventories.doc(inventoryId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> getInventoriesData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('Inventories').get();
      return snapshot;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> saveInventory(Inventory inventory) async {
    try {
      CollectionReference _inventories = _firestore.collection("Inventories");
      await _inventories.add({
        'product': inventory.product,
        'quantity': inventory.quantity,
        'price': inventory.price,
        'salePrice': inventory.salePrice
      });
    } catch (e) {
      print(e);
    }
  }

  // Firestore Customers
  Future<List<Customer>> getCustomers() async {
    try {
      QuerySnapshot? querySnapshot =
          await _firestore.collection('Customers').get();
      List<Customer> customers = [];
      for (QueryDocumentSnapshot document in querySnapshot?.docs ?? []) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        customers.add(Customer(
          customerId: document.id,
          firstName: data['FirstName'] ?? '',
          lastName: data['LastName'] ?? '',
          cedula: data["Cedula"] ?? '',
          phoneNumber: data["PhoneNumber"] ?? '',
        ));
      }
      return customers;
    } catch (e) {
      print('Error fetching customers: $e');
      return [];
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> getCustomerData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('Customers').get();
      return snapshot;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<DocumentSnapshot?> getCustomerDataByDoc(String uid) async {
    try {
      final DocumentSnapshot snapshot =
          await _firestore.collection('Customers').doc(uid).get();
      return snapshot;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> deleteCustomer(String customerId) async {
    try {
      CollectionReference _inventories = _firestore.collection("Customers");
      _inventories.doc(customerId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateCustomersData(
      String uid, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection('Customers')
          .doc(uid)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  Future<void> saveCustomer(Customer customer) async {
    try {
      // Reference to the Firestore collection
      CollectionReference customers = _firestore.collection('Customers');

      // Add a new document with a generated ID
      await customers.add({
        'FirstName': customer.firstName,
        'LastName': customer.lastName,
        'PhoneNumber': customer.phoneNumber,
        'Cedula': customer.cedula,
      });
    } catch (e) {
      print('Error adding customer to Firestore: $e');
    }
  }
}
