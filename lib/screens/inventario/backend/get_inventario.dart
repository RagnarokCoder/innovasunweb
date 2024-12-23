// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';

import '../inventario.dart';

getProductsI() {
  FirebaseFirestore.instance
      .collection("inventario")
      .snapshots()
      .listen((result) {
    inventario.clear();
    result.docs.forEach((result) {
      inventarioAll.putIfAbsent(result.id, () => result.data());

      if (!inventario.contains(result.data()['nombre'])) {
        inventario.add((result.data()['nombre']));
      }
    });
  });
}
