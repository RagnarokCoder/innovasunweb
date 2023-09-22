import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/activos/components/modal_activo.dart';

getEditActivo(String document, StateSetter setter) {
  precio.clear();
  stock.clear();
  descripcion.clear();
  nombre.clear();
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection("activos").doc(document);
  documentReference.get().then((doc) {
    if (doc.exists) {
      getActivo = doc.data() as Map;
      nombre.text = getActivo['nombre'];
      descripcion.text = getActivo['descripcion'];
      stock.text = getActivo['cantidad'].toString();
      precio.text = getActivo['precio'].toString();
      downloadUrl = getActivo['imagen'];
    }
  });
}
