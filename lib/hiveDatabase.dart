import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class services {
  final _shopping_box = Hive.box('shopping_box');

  void refreshItems() {
    final data = _shopping_box.keys.map((key) {
      final item = _shopping_box.get(key);
      print("wwwwwwwwwww $item");

      return {"key": key, "name": item["name"], "qty": item["qty"]};
    }).toList();
    // setState(() {
    //   _items = data.reversed.toList();
    //   print("item of lenth  ${_items.length}");
    // });
  }

  //create new items
  Future<void> createIem(Map<String, dynamic> newItem) async {
    await _shopping_box.add(newItem);
    refreshItems();
  }

  //update items
  Future<void> updateIem(int itmeKey, Map<String, dynamic> item) async {
    await _shopping_box.put(itmeKey, item);
    refreshItems();
  }

  //delete item
  Future<void> deleteIeam(int itmeKey) async {
    await _shopping_box.delete(itmeKey);
    refreshItems();
  }
}
