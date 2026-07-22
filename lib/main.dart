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

  // Currently selected item for the Details page (null = nothing selected)
  ShoppingItem? selectedItem;

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
                onTap: () {
                  setState(() {
                    selectedItem = items[rowNum];
                  });
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

  // DetailsPage function — shows the selected item's name, quantity, and id
  Widget DetailsPage() {
    if (selectedItem == null) {
      return const Center(child: Text("No item selected"));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Item: ${selectedItem!.name}"),
          Text("Quantity: ${selectedItem!.quantity}"),
          Text("Database id: ${selectedItem!.id}"),
          const SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton(
                child: const Text("Delete"),
                onPressed: () {
                  shoppingDao.deleteItem(selectedItem!);
                  setState(() {
                    items.remove(selectedItem);
                    selectedItem = null;
                  });
                },
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                child: const Text("Close"),
                onPressed: () {
                  setState(() {
                    selectedItem = null;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // reactiveLayout function — decides tablet/landscape vs phone/portrait layout
  Widget reactiveLayout() {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    if ((width > height) && (width > 720)) {
      // Tablet / landscape: show list and details side by side
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: ListPage(),
          ),
          Expanded(
            flex: 1,
            child: DetailsPage(),
          ),
        ],
      );
    } else {
      // Phone / portrait: show one or the other
      if (selectedItem == null) {
        return ListPage();
      } else {
        return DetailsPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Shopping List"),
      ),
      body: reactiveLayout(),
    );
  }
}