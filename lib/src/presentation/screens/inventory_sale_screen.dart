import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_app/src/domain/entities/inventory_detail.dart';
import 'package:loan_app/src/domain/services/firebase_service.dart';
import 'package:loan_app/src/presentation/Widgets/appbar_widget.dart';
import 'package:loan_app/src/utils/constans.dart';
import 'package:loan_app/src/utils/helper.dart';
import 'package:loan_app/src/utils/responsive.dart';

class InventorySale extends StatefulWidget {
  const InventorySale({Key? key}) : super(key: key);

  @override
  State<InventorySale> createState() => _InventorySaleState();
}

class _InventorySaleState extends State<InventorySale> {
  String currentDate = "";
  String inventoryId = "";
  String inventoryName = "";
  double inventorySalePrice = 0;
  List<InventoryDetail> _inventoriesDetails = [];
  int currentQuantityAvaible = 0;
  final InventoryDetail _inventoryDetail = InventoryDetail(
      inventoryId: "",
      inventoryDetailId: "",
      productName: "",
      quantity: 0,
      salePrice: 0.00,
      saleDate: "");
  bool isFirstReload = true;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerQuantity = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

    currentDate = DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
    _controllerQuantity.text = "1"; //default number
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final rp = Responsive(context);

    String id = args!["id"];
    String productName = args["productName"];
    double salePrice = args["salePrice"];
    int quantityAvaible = args["quantityAvaible"];

    if (isFirstReload) {
      _controller.text = Helper.formatNumberWithCommas(salePrice.toString());
      currentQuantityAvaible = quantityAvaible;
      inventoryId = id;
      inventoryName = productName;
      inventorySalePrice = salePrice;
      isFirstReload = false;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: bodyColor,
        key: _scaffoldKey,
        appBar: AppBarCustomWidget(
            title: "Venta de $inventoryName, Disp. ($currentQuantityAvaible)",
            isCentered: false),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Producto'),
                      initialValue: inventoryName,
                      readOnly: true,
                      enabled: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el tipo de producto';
                        }
                        return null;
                      },
                      onSaved: (value) {},
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: TextFormField(
                      initialValue: currentDate,
                      enabled: false,
                      decoration: const InputDecoration(labelText: 'Fecha'),
                      onSaved: (value) {
                        _inventoryDetail.saleDate = currentDate;
                        _inventoryDetail.productName = inventoryName;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Precio'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el precio';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: TextFormField(
                      controller: _controllerQuantity,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Cantidad'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la Cantidad';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (Helper.isValidInput(value)) {
                          int valueparse = int.parse(value);
                          inventorySalePrice = salePrice * valueparse;

                          _controller.text = Helper.formatNumberWithCommas(
                              inventorySalePrice.toString());
                        } else {
                          _controller.text = "0";
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
                onPressed: currentQuantityAvaible > 0
                    ? () => showConfirmationDialog(context)
                    : null,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.monetization_on),
                  SizedBox(width: rp.wp(1)),
                  const Text("Cobrar")
                ])),
            Center(
              child: currentQuantityAvaible > 0
                  ? null
                  : Text(
                      "Felicidades has logrado vender todo 🥂🥳🤝🎉*",
                      style:
                          TextStyle(color: Colors.green, fontSize: rp.dp(1.9)),
                    ),
            ),
            SizedBox(height: rp.wp(3)),
            const Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                ),
                Text(
                  "Historial",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: _firebaseService.getInventoySales(inventoryId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Handle error state
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  if (snapshot.data.docs.length > 0) {
                    _inventoriesDetails = snapshot.data.docs
                        .map((doc) => InventoryDetail.fromSnapshot(doc))
                        .toList()
                        .cast<InventoryDetail>();
                    return listInventoriesView();
                  } else {
                    return Container(
                      margin: EdgeInsets.only(top: rp.dp(20)),
                      child: const Center(
                          child: Text(
                        "No tenemos registro en el historial 😔",
                        style: TextStyle(fontSize: 17),
                      )),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Expanded listInventoriesView() {
    return Expanded(
      child: ListView.builder(
          itemCount: _inventoriesDetails.length,
          itemBuilder: (context, index) {
            return Card(
                key: ValueKey<String>(
                    _inventoriesDetails[index].inventoryDetailId),
                elevation: 1,
                child: ListTile(
                  onTap: () {},
                  title: Text(_inventoriesDetails[index].productName),
                  subtitle: Text(
                    'Cantidad: ${_inventoriesDetails[index].quantity} \n Precio: ${Helper.formatNumberWithCommas(_inventoriesDetails[index].salePrice.toString())} \n Fecha: ${_inventoriesDetails[index].saleDate} ',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ));
          }),
    );
  }

  SnackBar _showSnackBar(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 20.0,
      backgroundColor: successColor,
      content: const Text(
        'Su venta se ha registrado de manera exitosa**',
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

  SnackBar _showSnackBarError(BuildContext context, String error) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 20.0,
      backgroundColor: Colors.red,
      content: Text(
        error,
        style: const TextStyle(
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

  Future<void> showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Clicking outside the dialog will not dismiss it
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: Text(
              'Estas seguro que deseas vender estas cantidad  de $inventoryName ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                saveInventorySale(_scaffoldKey.currentContext);
              },
            ),
          ],
        );
      },
    );
  }

  saveInventorySale(BuildContext? context) async {
    if (_controllerQuantity.text.isNotEmpty &&
        currentQuantityAvaible < int.parse(_controllerQuantity.text)) {
      ScaffoldMessenger.of(context!).showSnackBar(
        _showSnackBarError(context,
            "⚠️ La cantidad que ingresaste es superior a la cantidad de $inventoryName disponible ⚠️"),
      );
      return;
    }

    if (_controllerQuantity.text.isNotEmpty &&
        Helper.isValidInput(_controllerQuantity.text) &&
        int.parse(_controllerQuantity.text) > 0) {
      _inventoryDetail.inventoryId = inventoryId;
      _inventoryDetail.quantity = int.parse(_controllerQuantity.text);
      _inventoryDetail.salePrice =
          double.parse(Helper.removeSpecialCharacters(_controller.text));
      _inventoryDetail.saleDate = currentDate;
      _inventoryDetail.productName = inventoryName;
      _inventoryDetail.salePrice =
          double.parse(Helper.removeTrailingZeros(_inventoryDetail.salePrice));

      await _firebaseService.saveInventoySale(_inventoryDetail);

      currentQuantityAvaible =
          currentQuantityAvaible - int.parse(_controllerQuantity.text);

      await _firebaseService.updateInventoryQuantity(
          inventoryId, currentQuantityAvaible);

      ScaffoldMessenger.of(context!).showSnackBar(
        _showSnackBar(context),
      );
      _controllerQuantity.text = "0";
      _controller.text = "0";
      setState(() {});
    } else {
      ScaffoldMessenger.of(context!).showSnackBar(
        _showSnackBarError(context, "Debes completar todos los campos*"),
      );
    }
  }
}
