import 'package:flutter/material.dart';
import 'database.dart';
import 'shopping_item.dart';
import 'shopping_dao.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List to hold shopping items loaded from / synced with the database
  List<ShoppingItem> items = [];

  late AppDatabase database;
  late ShoppingDao shoppingDao;
  int nextId = 0;

  // Controllers for the two TextFields
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    $FloorAppDatabase.databaseBuilder('shopping_database.db').build().then((db) {
      database = db;
      shoppingDao = database.shoppingDao;
      shoppingDao.findAllItems().then((loadedItems) {
        setState(() {
          items = loadedItems;
          if (items.isNotEmpty) {
            nextId = items.map((i) => i.id).reduce((a, b) => a > b ? a : b) + 1;
          }
        });
      });
    });
  }

  // ListPage function — returns the full list UI
  Widget ListPage() {
    return Column(
      children: [
        // Row at the top: Item TextField, Quantity TextField, Add button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _itemController,
                  decoration: const InputDecoration(
                    labelText: 'Item name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Qty',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            ElevatedButton(
              child: const Text("Add"),
              onPressed: () {
                ShoppingItem newItem = ShoppingItem(
                  nextId,
                  _itemController.value.text,
                  _quantityController.value.text,
                );
                nextId++;
                shoppingDao.insertItem(newItem);
                setState(() {
                  items.add(newItem);
                  _itemController.text = "";
                  _quantityController.text = "";
                });
              },
            ),
          ],
        ),

        // Show empty message / the ListView
        items.isEmpty
            ? const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("There are no items in the list"),
        )
            : Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, rowNum) {
              return GestureDetector(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Delete Item"),
                        content: Text(
                            "Do you want to delete '${items[rowNum].name}'?"),
                        actions: [
                          TextButton(
                            child: const Text("Yes"),
                            onPressed: () {
                              shoppingDao.deleteItem(items[rowNum]);
                              setState(() {
                                items.removeAt(rowNum);
                              });
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text("No"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${rowNum + 1}. ${items[rowNum].name}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Qty: ${items[rowNum].quantity}"),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Shopping List"),
      ),
      body: ListPage(),
    );
  }
}