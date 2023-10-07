import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_app/src/domain/entities/amortization.dart';
import 'package:loan_app/src/domain/entities/customer.dart';
import 'package:loan_app/src/domain/entities/loan.dart';
import 'package:loan_app/src/domain/enums/term_type.dart';
import 'package:loan_app/src/domain/services/firebase_service.dart';
import 'package:loan_app/src/presentation/Widgets/alertInfo.dart';
import 'package:loan_app/src/presentation/Widgets/appbar_widget.dart';
import 'package:loan_app/src/presentation/screens/customer_screen.dart';
import 'package:loan_app/src/presentation/screens/main_screen.dart';
import 'package:loan_app/src/presentation/screens/payment_screen.dart';
import 'package:loan_app/src/utils/constans.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:loan_app/src/utils/helper.dart';
import 'package:loan_app/src/utils/responsive.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({Key? key}) : super(key: key);

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

List<Loan> loansFound = [];

class _LoanScreenState extends State<LoanScreen> {
  TermType? selectedOption;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  Customer? selectedCustomer;
  final _loan = Loan(
      customerName: "",
      createdDate: "",
      period: 0,
      interest: 0,
      amount: 0,
      termType: TermType.Semanal);
  List<Customer> customers = [];
  List<Loan> _loans = [];

  @override
  void initState() {
    super.initState();
    loansFound = [];
    // Fetch customers from Firebase and update the dropdown items
    fetchCustomers();
  }

  searchEngine(String enteredKey) {
    List<Loan> loanResult = [];
    if (enteredKey.isNotEmpty) {
      loanResult = _loans
          .where((loan) => loan.customerName
              .toLowerCase()
              .contains(enteredKey.toLowerCase()))
          .toList();
      loansFound = loanResult;
    } else {
      loansFound = [];
    }
    setState(() {});
  }

  Future<void> fetchCustomers() async {
    customers = await _firebaseService.getCustomers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final rp = Responsive(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: bodyColor,
        appBar: const AppBarCustomWidget(title: "Prestamos", isCentered: true),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 14, right: 10, left: 10),
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
            SizedBox(height: rp.hp(4)),
            FutureBuilder(
              future: _firebaseService.getLoans(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Handle error state
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  if (snapshot.data.docs.length > 0) {
                    _loans = snapshot.data.docs
                        .map((doc) => Loan.fromSnapshot(doc))
                        .toList()
                        .cast<Loan>();
                    if (loansFound.isEmpty) {
                      loansFound = _loans;
                    }
                    return _listViewLoans(loansFound, context);
                  } else {
                    return Container(
                      margin: EdgeInsets.only(top: rp.dp(20)),
                      child: const Center(
                          child: Text(
                        "No tenemos prestamos registrado 😔",
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
            _addToLoanDialog(context);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        bottomNavigationBar: _bottomTab(context),
      ),
    );
  }

  Expanded _listViewLoans(List<Loan> loans, BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: loans.length,
        itemBuilder: (context, index) {
          Loan loan = loans[index];
          return Card(
            elevation: 4,
            color: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              title: Text(loan.customerName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 17)),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Monto Prestado : ${Helper.formatNumberWithCommas(Helper.removeTrailingZerosToUseLoan(loan.amount))}",
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 17),
                    ),
                    Text(
                      "Taza De Interest : ${Helper.removeTrailingZerosToUseLoan(loan.interest)}%",
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 17),
                    ),
                    Text(
                      "Plazo : ${loan.period.toString()} ${loan.termTypevalue!} ",
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 17),
                    ),
                    Text(
                      "Fecha De Creación : ${DateFormat("dd-MM-yyyy").format(Helper.parseDate(loan.createdDate))} ",
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 17),
                    )
                  ]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            settings: RouteSettings(arguments: {
                              "id": loans[index].loanId,
                              "customerName": loans[index].customerName
                            }),
                            builder: ((context) => PaymentScreen())));
                      },
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.blue.shade700,
                      )),
                  IconButton(
                      onPressed: () async {
                        bool? accept =
                            await ShowAlertInfo.showConfirmationDialog(
                                context,
                                "Estas seguro que deseas eliminar este préstamo",
                                "Advertencia",
                                const Icon(
                                  Icons.warning,
                                  color: Colors.yellow,
                                ));

                        if (accept!) {
                          await _firebaseService.deleteLoan(loan.loanId!);
                          loansFound = [];
                          setState(() {});
                        }
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

  Future<void> _addToLoanDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Crear Préstamo'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownSearch<Customer>(
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                              labelText: "Seleccionar cliente",
                              hintText: "Clientes")),
                      items: customers,
                      selectedItem: selectedCustomer,
                      itemAsString: (Customer? customer) =>
                          "${customer!.firstName}  ${customer.lastName} \n Celular : ${customer.phoneNumber}",
                      compareFn: (item, selectedItem) =>
                          item.customerId == selectedItem.customerId,
                      popupProps:
                          const PopupPropsMultiSelection.modalBottomSheet(
                        isFilterOnline: true,
                        showSelectedItems: true,
                        showSearchBox: true,
                      ),
                      onChanged: (Customer? customer) {
                        setState(() {
                          selectedCustomer = customer;
                        });
                      },
                      onSaved: (newValue) {
                        _loan.customerName =
                            "${newValue!.firstName} ${newValue.lastName}";
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor seleccione un cliente';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Monto del préstamo'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el monto';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _loan.amount = double.parse(value!);
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Taza de interés'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la taza de interés';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _loan.interest = double.parse(value!);
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Plazo'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el plazo';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _loan.period = int.parse(value!);
                      },
                    ),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(labelText: 'Pagos'),
                      value: selectedOption,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_circle_down_rounded,
                          color: mainColor),
                      items: const [
                        DropdownMenuItem(
                            child: Text("Semanas"), value: TermType.Semanal),
                        DropdownMenuItem(
                            child: Text("Quincenas"),
                            value: TermType.Quincenal),
                        DropdownMenuItem(
                            child: Text("Menses"), value: TermType.Mensual)
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value as TermType;
                        });
                      },
                      onSaved: (newValue) {
                        _loan.termType = newValue as TermType;
                      },
                    ),
                  ],
                ),
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    showDialog(
                        context: context,
                        builder: (context) {
                          return const Center(
                              child: CircularProgressIndicator());
                        });

                    String id = await _firebaseService.saveLoan(_loan);

                    _loan.loanId = id;

                    if (id.isNotEmpty) {
                      await generateAmortization(_loan);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      _showSnackBar(context),
                    );

                    Navigator.of(context).pop();
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

  generateAmortization(Loan loan) async {
    int loanAmount = loan.amount.toInt();
    int interestRate = loan.interest.toInt();
    int period = loan.period;

    int interestPercent = loanAmount * interestRate ~/ 100;

    int interestTotal = (interestPercent * period) - loanAmount;

    int remainingBalance = loanAmount + interestTotal;
    DateTime paymentDate = DateTime.now();

    for (int index = 1; index <= period; index++) {
      int quote = (loanAmount ~/ period) + (interestTotal ~/ period);
      int capital = loanAmount ~/ period;
      remainingBalance -= quote;
      Amortization amortization = setAmortization(
          quote,
          (interestTotal ~/ period).toInt(),
          remainingBalance,
          loan,
          capital,
          index,
          paymentDate);

      paymentDate = amortization.paymentDate!;
      loansFound = [];
      await _firebaseService.saveAmortization(amortization);
    }
  }

  Amortization setAmortization(int quote, int interest, int remainingBalance,
      Loan loan, int capital, int index, DateTime paymentDate) {
    if (loan.termType == TermType.Quincenal) {
      return Amortization(
          isPayment: false,
          loanId: loan.loanId,
          period: index,
          quote: quote,
          interest: interest,
          principal: capital,
          remainingBalance: remainingBalance,
          paymentDate: paymentDate.add(const Duration(days: 14)));
    } else if (loan.termType == TermType.Semanal) {
      return Amortization(
          isPayment: false,
          loanId: loan.loanId,
          period: index,
          quote: quote,
          interest: interest,
          principal: capital,
          remainingBalance: remainingBalance,
          paymentDate: paymentDate.add(const Duration(days: 7)));
    } else {
      return Amortization(
          isPayment: false,
          loanId: loan.loanId,
          period: index,
          quote: quote,
          interest: interest,
          principal: capital,
          remainingBalance: remainingBalance,
          paymentDate: addOneMonth(paymentDate));
    }
  }

  DateTime addOneMonth(DateTime dateTime) {
    int year = dateTime.year;
    int month = dateTime.month + 1;
    if (month > 12) {
      month = 1;
      year++;
    }
    int lastDay = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, lastDay);
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => const MainScreen())));
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
        'Préstamo creado de manera exitosa**',
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
