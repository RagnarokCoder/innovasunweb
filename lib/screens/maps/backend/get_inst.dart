import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/modal_instalaciones.dart';

getEditInst(String document, StateSetter setter) {
  clienteController.clear();
  estadoController.clear();
  folioController.clear();
  nombreController.clear();
  direccionController.clear();
  comunidadController.clear();
  numIntController.clear();
  telefonoController.clear();
  cantidadController.clear();
  observController.clear();
  latitud.clear();
  longitud.clear();
  debugPrint(document);
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection("instalaciones").doc(document);
  documentReference.get().then((doc) {
    if (doc.exists) {
      getInst = doc.data() as Map;
      Map<dynamic, dynamic> auxMap = {};
      if (getInst['ubicacion'] != null) {
        auxMap = getInst['ubicacion'];
        latitud.text = auxMap['latitude'].toString();
        longitud.text = auxMap['longitude'].toString();
      }
      clienteController.text = getInst['cliente'];
      estadoController.text = getInst['estado'];
      folioController.text = getInst['folio'].toString();
      nombreController.text = getInst['nombre'].toString();
      direccionController.text = getInst['direccion'].toString();
      comunidadController.text = getInst['comunidad'];
      numIntController.text = getInst['numero'];
      telefonoController.text = getInst['telefono'].toString();
      cantidadController.text = getInst['cantidad'].toString();
      observController.text = getInst['observaciones'].toString();
    }
  });
}
