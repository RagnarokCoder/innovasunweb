// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/correos/components/modal_correo.dart';
import 'package:innovasun/screens/correos/correos.dart';

getEditCorreo(String document, StateSetter setter) {
  correo.clear();
  nombre.clear();
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection("correos").doc(document);
  documentReference.get().then((doc) {
    if (doc.exists) {
      getCorreo = doc.data() as Map;
      nombre.text = getCorreo['nombre'];
      correo.text = getCorreo['correo'];
    }
  });
}

getAllCorreos() {
  FirebaseFirestore.instance.collection("correos").snapshots().listen((result) {
    correos.clear();
    result.docs.forEach((result) {
      if (!correos.contains(result.data()['correo'])) {
        correos.add((result.data()['correo']));
      }
    });
  });
}
