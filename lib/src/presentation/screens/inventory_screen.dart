import 'package:flutter/material.dart';
import 'package:loan_app/src/domain/entities/inventory.dart';
import 'package:loan_app/src/domain/services/firebase_service.dart';
import 'package:loan_app/src/presentation/Widgets/appbar_widget.dart';
import 'package:loan_app/src/presentation/screens/inventory_sale_screen.dart';
import 'package:loan_app/src/utils/constans.dart';
import 'package:loan_app/src/utils/helper.dart';
import 'package:loan_app/src/utils/responsive.dart';

// ignore: use_key_in_widget_constructors
class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Inventory> _inventories = [];
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();

  final Inventory _inventory = Inventory(
      inventoryId: "", product: "", quantity: 0, salePrice: 0.00, price: 0.00);

  @override
  Widget build(BuildContext context) {
    final rp = Responsive(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: bodyColor,
        appBar: const AppBarCustomWidget(
          title: "Inventario",
          isCentered: true,
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: rp.hp(10)),
            FutureBuilder(
              future: _firebaseService.getInventoriesData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Handle error state
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  if (snapshot.data.docs.length > 0) {
                    _inventories = snapshot.data.docs
                        .map((doc) => Inventory.fromSnapshot(doc))
                        .toList()
                        .cast<Inventory>();
                    return _listViewInventories();
                  } else {
                    return Container(
                      margin: EdgeInsets.only(top: rp.dp(20)),
                      child: const Center(
                          child: Text(
                        "No tenemos registro en el inventario 😔",
                        style: TextStyle(fontSize: 17),
                      )),
                    );
                  }
                }
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: mainColor,
          onPressed: () {
            _addToInventoryDialog(context);
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: _bottomTab(context),
      ),
    );
  }

  Expanded _listViewInventories() {
    return Expanded(
      child: ListView.builder(
        itemCount: _inventories.length,
        itemBuilder: (context, index) {
          return Card(
            color: cardColor,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              onTap: () {},
              title: Text(
                _inventories[index].product,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                          text: 'Cantidad : ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF9E9E9E),
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: '${_inventories[index].quantity}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          )),
                    ])),
                    RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                          text: 'Capital : ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF9E9E9E),
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: Helper.formatNumberWithCommas(
                              _inventories[index].price.toString()),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          )),
                    ])),
                    RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                          text: 'Precio Venta : ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF9E9E9E),
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: Helper.formatNumberWithCommas(
                              _inventories[index].salePrice.toString()),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          )),
                    ])),
                  ]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => const InventorySale()),
                            settings: RouteSettings(arguments: {
                              "id": _inventories[index].inventoryId,
                              "productName": _inventories[index].product,
                              "salePrice": _inventories[index].salePrice,
                              "quantityAvaible": _inventories[index].quantity
                            })));
                      },
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.blue.shade700,
                      )),
                  IconButton(
                      icon: const Icon(Icons.edit, color: Colors.amber),
                      onPressed: () {}
                      // Implement the
                      ),
                  IconButton(
                      onPressed: () {
                        _firebaseService
                            .deleteInventory(_inventories[index].inventoryId);
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red.shade700,
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _addToInventoryDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Agregar al inventario'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Producto'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el tipo de producto';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _inventory.product = value!;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la Cantidad';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _inventory.quantity = int.parse(value!);
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Precio'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el Precio';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _inventory.price = double.parse(value!);
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Precio de venta'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el precio  que desea venderla';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _inventory.salePrice = double.parse(value!);
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

                    _firebaseService.saveInventory(_inventory);

                    ScaffoldMessenger.of(context).showSnackBar(
                      _showSnackBar(context),
                    );

                    Navigator.of(context).pop();
                    setState(() {});
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        });
  }

  BottomAppBar _bottomTab(BuildContext context) {
    return BottomAppBar(
      color: bootomNavColor,
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
    );
  }

  SnackBar _showSnackBar(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 20.0,
      backgroundColor: successColor,
      content: const Text(
        'Agregado al inventario de manera exitosa**',
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
