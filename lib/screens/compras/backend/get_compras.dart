// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/compras/compras.dart';

getAllCompras(StateSetter setter) {
  FirebaseFirestore.instance.collection("compras").snapshots().listen((result) {
    totalC = 0;
    result.docs.forEach((result) {
      setter(() {
        totalC += result.data()['total'];
      });
    });
  });
}
