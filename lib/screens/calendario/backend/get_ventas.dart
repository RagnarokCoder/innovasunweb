import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/calendario/calendar.dart';

getVentas(StateSetter setter) {
  final fondosD = FirebaseFirestore.instance.collection("ventas");

  fondosD
      .get()
      .then((value) => {
            for (var doc in value.docs)
              {ventas.putIfAbsent(doc.id, () => doc.data())}
          })
      .then((value) => {setter(() {})});
}

getCompras(StateSetter setter) {
  final fondosD = FirebaseFirestore.instance.collection("compras");

  fondosD
      .get()
      .then((value) => {
            for (var doc in value.docs)
              {compras.putIfAbsent(doc.id, () => doc.data())}
          })
      .then((value) => {setter(() {})});
}

getInstalaciones(StateSetter setter) {
  final instalacion = FirebaseFirestore.instance.collection("instalaciones");

  instalacion
      .get()
      .then((value) => {
            for (var doc in value.docs)
              {instalaciones.putIfAbsent(doc.id, () => doc.data())}
          })
      .then((value) => {setter(() {})});
}

getGastos(StateSetter setter) {
  final fondosD = FirebaseFirestore.instance.collection("gastos_caja");

  fondosD
      .get()
      .then((value) => {
            for (var doc in value.docs)
              {gastos.putIfAbsent(doc.id, () => doc.data())}
          })
      .then((value) => {setter(() {})});
}

getUsuarios(StateSetter setter) {
  final fondosD = FirebaseFirestore.instance.collection("usuarios");
  usuarios.clear();
  fondosD
      .get()
      .then((value) => {
            for (var doc in value.docs) {usuarios.add(doc.id)}
          })
      .then((value) => {setter(() {})});
}
