// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loan_app/src/domain/entities/customer.dart';

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

  // Firestore methods
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
      print('Customer added to Firestore successfully');
    } catch (e) {
      print('Error adding customer to Firestore: $e');
    }
  }
}
