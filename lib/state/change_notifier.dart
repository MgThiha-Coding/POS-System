import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos_logicflow/state/model.dart';

class AppNotifier extends ChangeNotifier {
  AppNotifier() {
    initializeDatabase();
  }
  // initialize Hive database
  void initializeDatabase() async {
    try {
      box = Hive.box('database');
    } catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
  }

  late Box box;
  late final List<Model> _cart = [];

  // convert Map to List that retrive from Hive and assign with database
  List<Model> get product => box.values
      .map((element) => Model.fromMap(Map<String, dynamic>.from(element)))
      .toList();

  List<Model> get cart => UnmodifiableListView(_cart);
  // CRUD operatiion
  // CREATE
  void save(Model product) {
    box.add(product.toMap());
    notifyListeners();
  }

  // DELETE
  void delete(int index) {
    box.deleteAt(index);
    notifyListeners();
  }

  // UPDATE
  void update(int index, Model product) {
    box.put(index, product.toMap());
    notifyListeners();
  }

  void addtoCart(Model product) {
    int index =
        _cart.indexWhere((element) => element.product == product.product);
    if (index != -1) {
      _cart[index].qty++;
    } else {
      _cart.add(Model(product.product, product.price, product.qty));
    }
    notifyListeners();
  }

  void reduceQuantity(Model product) {
    int index =
        _cart.indexWhere((element) => element.product == product.product);
    if (index != -1) {
      if (_cart[index].qty > 1) {
        _cart[index].qty--;
      } else {
        _cart.removeAt(index);
      }
    }
    notifyListeners();
  }

  double get totalPrice {
    double total = 0.0;
    for (var item in _cart) {
      total += item.price * item.qty;
    }
    return total;
  }

  int get itemQty {
    int totalQty = 0;
    for (var i in _cart) {
      totalQty += i.qty;
    }
    return totalQty;
  }
}

final provider = ChangeNotifierProvider<AppNotifier>((ref) => AppNotifier());
