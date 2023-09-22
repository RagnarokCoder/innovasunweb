// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/activos/activosv.dart';

getProductsI(StateSetter setter) {
  FirebaseFirestore.instance.collection("activos").snapshots().listen((result) {
    activos.clear();
    cantidad = 0;
    totalA = 0;
    result.docs.forEach((result) {
      if (!activos.contains(result.data()['nombre'])) {
        setter(() {});
        activos.add((result.data()['nombre']));
        cantidad += result.data()['cantidad'];
        totalA += result.data()['cantidad'] * result.data()['precio'];
      }
    });
  });
}
