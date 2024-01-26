// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/creditos/creditos.dart';

getCreditos(StateSetter setter) {
  FirebaseFirestore.instance
      .collection("ventas")
      .where("isContado", isEqualTo: false)
      .snapshots()
      .listen((result) {
    creditosGet.clear();
    vencidos = 0;
    result.docs.forEach((result) {
      creditosGet.putIfAbsent(result.id, () => result.data());
      for (var i in creditosGet.keys) {
        DateTime today = DateTime.now();
        DateTime vencimiento = creditosGet[i]['vencimiento'].toDate();
        if (today.isAfter(vencimiento)) {
          vencidos += 1;
          setter(() {});
        }
      }
      debugPrint(vencidos.toString());
    });
  });
}
