import 'package:flutter/material.dart';
import 'package:loan_app/src/domain/entities/customer.dart';
import 'package:loan_app/src/domain/services/firebase_service.dart';
import 'package:loan_app/src/utils/constans.dart';
import 'package:loan_app/src/utils/responsive.dart';

// ignore: use_key_in_widget_constructors
class AddCustomerScreen extends StatefulWidget {
  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  List<Customer> customers = [];
  List<Customer> customersFound = [];

  List items = [];

  searchEngine(String enteredKey) {
    List<Customer> customersResult = [];
    if (enteredKey.isEmpty) {
      customersResult = customers;
    } else {
      customersResult = customers
          .where((customer) => customer.firstName
              .toLowerCase()
              .contains(enteredKey.toLowerCase()))
          .toList();
    }
    setState(() {
      customersFound = customersResult;
    });
  }

  final Customer _customer = Customer(
      id: '', firstName: '', lastName: '', cedula: '', phoneNumber: '');

  @override
  Widget build(BuildContext context) {
    final rp = Responsive(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Listado Clientes"),
          elevation: 8.0,
          backgroundColor: mainColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Motor de búsqueda',
                  hintText: 'Que cliente deseas buscar.... ?',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // Handle search functionality here
                  searchEngine(value);
                },
              ),
            ),
            SizedBox(height: rp.hp(5)),
            FutureBuilder(
              future: _firebaseService.getCustomerData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Handle error state
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  if (snapshot.hasData) {
                    customers = snapshot.data.docs
                        .map((doc) => Customer.fromSnapshot(doc))
                        .toList()
                        .cast<Customer>();
                    customersFound = customers;
                    return _customersListView(customers);
                  }
                  return const Center(child: Text("No hay Data"));
                }
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addCustomerDialog(context);
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.indigo,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.home,
                  size: 20.8,
                ),
                focusColor: mainColor,
                color: mainColor,
                onPressed: () {
                  // Handle home tab press
                  Navigator.of(context).pop();
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.redAccent,
                onPressed: () {
                  // Handle settings tab press
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addCustomerDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Agregar Cliente'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su Nombre';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _customer.firstName = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Apellido'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su Apellido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _customer.lastName = value!;
                    },
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Numero de Celular'),
                    onSaved: (value) {
                      _customer.phoneNumber = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Cedula'),
                    onSaved: (value) {
                      _customer.cedula = value!;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _firebaseService.saveCustomer(_customer);
                    ScaffoldMessenger.of(context).showSnackBar(
                      _showSnackBar(context),
                    );

                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        });
  }

  Expanded _customersListView(List<Customer> data) {
    return Expanded(
      child: ListView.builder(
        itemCount: customersFound.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 9),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(customersFound[index].firstName.substring(0, 1) +
                    '' +
                    customersFound[index].lastName.substring(0, 1)),
              ),
              title: Text(customersFound[index].firstName +
                  ' ' +
                  customersFound[index].lastName),
              subtitle: Text(
                  'Teléfono: ${customersFound[index].phoneNumber} \n Cédula: ${customersFound[index].cedula}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.amber),
                    onPressed: () {
                      // Implement the edit functionality here
                      // You can open a dialog or navigate to an edit screen
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Editar'),
                            content: TextField(
                              controller:
                                  TextEditingController(text: items[index]),
                              onChanged: (value) {
                                items[index] = value;
                              },
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Guardar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {}); // Update the UI
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red.shade900),
                    onPressed: () {
                      // Implement the delete functionality here
                      setState(() {
                        customers.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  SnackBar _showSnackBar(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 20.0,
      backgroundColor: successColor,
      content: const Text(
        'Cliente guardado de manera exitosa**.',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      action: SnackBarAction(
        label: 'Cerrar',
        onPressed: () {},
        textColor: Colors.white,
      ),
    );
  }
}
