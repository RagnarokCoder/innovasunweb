import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/modal_inventario.dart';

getEditInventario(String document, StateSetter setter) {
  venta.clear();
  compra.clear();
  stock.clear();
  descripcion.clear();
  nombre.clear();
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection("inventario").doc(document);
  documentReference.get().then((doc) {
    if (doc.exists) {
      getInventory = doc.data() as Map;
      nombre.text = getInventory['nombre'];
      descripcion.text = getInventory['descripcion'];
      stock.text = getInventory['cantidad'].toString();
      venta.text = getInventory['venta'].toString();
      compra.text = getInventory['compra'].toString();
      downloadUrl = getInventory['imagen'];
    }
  });
}
