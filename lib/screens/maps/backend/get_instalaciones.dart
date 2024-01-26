// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/maps/maps.dart';

getInstalacionesMap(StateSetter setter) {
  final instalacion = FirebaseFirestore.instance.collection("instalaciones");
  instalaciones.clear();
  instalacion
      .get()
      .then((value) => {
            for (var doc in value.docs)
              {instalaciones.putIfAbsent(doc.id, () => doc.data())}
          })
      .then((value) => {setter(() {})});
}
