import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  List<Map<String, dynamic>> _items = [];

  final _shopping_box = Hive.box('shopping_box');

  void _refreshItems() {
    final data = _shopping_box.keys.map((key) {
      final item = _shopping_box.get(key);
      print("wwwwwwwwwww $item");

      return {"key": key, "name": item["name"], "qty": item["qty"]};
    }).toList();
    setState(() {
      _items = data.reversed.toList();
      print("item of lenth  ${_items.length}");
    });
  }

  //create new items
  Future<void> _createIem(Map<String, dynamic> newItem) async {
    await _shopping_box.add(newItem);
    _refreshItems();
  }

  //update items
  Future<void> _updateIem(int itmeKey, Map<String, dynamic> item) async {
    await _shopping_box.put(itmeKey, item);
    _refreshItems();
  }

  //delete item
  Future<void> _deleteIeam(int itmeKey) async {
    await _shopping_box.delete(itmeKey);
    _refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Items has been deleted")));
  }

  void _showForm(BuildContext ctx, int? itemKey) async {
    if (itemKey != null) {
      _items.forEach((element) {
        if (element['key'] == itemKey) {
          _nameController.text = element['name'];
          _qtyController.text = element['qty'];
        }
      });
    }
    showModalBottomSheet(
        context: ctx,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                top: 15,
                left: 15,
                right: 15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: "Name"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _qtyController,
                    decoration: const InputDecoration(hintText: "qty"),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (itemKey == null) {
                          _createIem({
                            "name": _nameController.text,
                            "qty": _qtyController.text,
                          });
                        } else {
                          _updateIem(itemKey, {
                            "name": _nameController.text.trim(),
                            "qty": _qtyController.text.trim(),
                          });
                        }

                        _nameController.text = '';
                        _qtyController.text = '';
                        Navigator.of(context).pop();
                      },
                      child: Text("create New"))
                ],
              ),
            ));
  }

  @override
  void initState() {
    // TODO: implement initState
    _refreshItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hive"),
      ),
      body: SizedBox(
        height: 500,
        child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (_, index) {
              return Card(
                color: Colors.orange.shade100,
                elevation: 3,
                child: ListTile(
                  title: Text(_items[index]['name']),
                  subtitle: Text(_items[index]['qty'].toString()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            _showForm(context, _items[index]['key']);
                          },
                          icon: Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            _deleteIeam(_items[index]['key']);
                          },
                          icon: Icon(Icons.delete)),
                    ],
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: const Icon(Icons.add_to_drive),
      ),
    );
  }
}
