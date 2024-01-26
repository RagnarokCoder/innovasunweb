// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/ventas/components/modal_caja.dart';
import 'package:innovasun/screens/ventas/ventas.dart';

getProductosVentas() {
  FirebaseFirestore.instance
      .collection("inventario")
      .snapshots()
      .listen((result) {
    ventas.clear();
    result.docs.forEach((result) {
      if (!ventas.contains(result.data()['nombre'])) {
        ventas.add((result.data()['nombre']));
      }
    });
  });
}

getCaja(StateSetter setter) {
  final fondosD =
      FirebaseFirestore.instance.collection("caja_chica").doc("caja");

  fondosD
      .get()
      .then((value) => {cajaChica = value.data()!['total']})
      .then((value) => {setter(() {})});
}

void getCajas(StateSetter setter) {
  final fondosD = FirebaseFirestore.instance.collection("gastos_caja");

  DateTime now = DateTime.now();
  DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
  DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

  fondosD
      .where("fecha", isGreaterThanOrEqualTo: firstDayOfMonth)
      .where("fecha", isLessThanOrEqualTo: lastDayOfMonth)
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((DocumentSnapshot document) {
      movimiento[document.id] = document.data();
    });

    setter(() {
      debugPrint(movimiento.toString());
    });
  }).catchError((error) {
    debugPrint("Error getting documents: $error");
  }).then((value) => {
            setter(() {}),
          });
}
