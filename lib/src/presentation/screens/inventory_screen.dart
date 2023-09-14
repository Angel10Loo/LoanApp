import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ListView with Edit and Delete'),
        ),
        body: ItemList(),
      ),
    );
  }
}

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(items[index]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Implement the edit functionality here
                  // You can open a dialog or navigate to an edit screen
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Edit Item'),
                        content: TextField(
                          controller: TextEditingController(text: items[index]),
                          onChanged: (value) {
                            items[index] = value;
                          },
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Save'),
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
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Implement the delete functionality here
                  setState(() {
                    items.removeAt(index);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
