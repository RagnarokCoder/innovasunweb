import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/creditos/components/modal_correo.dart';
import 'package:innovasun/screens/creditos/creditos.dart';
import 'package:uuid/uuid.dart';

import '../../../constants/alerts/success.dart';
import '../../../constants/alerts/warning.dart';
import '../components/modal_abonos.dart';

Map<dynamic, dynamic> getVenta = {};
Map<String, dynamic> abonos = {};

var uuid = const Uuid();

subirPago(Size size, BuildContext context, StateSetter setSt, String usuario,
    String doc) async {
  if (responsable.text.isEmpty || abono.text.isEmpty || nombre.text.isEmpty) {
    warning(
      size,
      context,
      "¡Campos Vacios!",
      "No debes dejar campos vacios, verifica que todos los campos contengan datos.",
    );
  } else {
    isLoadingPago = true;

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("ventas").doc(doc);
    documentReference.get().then((doc) {
      if (doc.exists) {
        getVenta = doc.data() as Map;
        if (getVenta['abonos'] != null) {
          abonos = getVenta['abonos'];
        }
        abonos.putIfAbsent(
            uuid.v4(),
            () => {
                  "fecha": fechaPago,
                  "responsable": responsable.text,
                  "concepto": nombre.text,
                  "cantidad": double.parse(abono.text),
                  "registro": usuario
                });
        FirebaseFirestore.instance
            .collection("ventas")
            .doc(doc.id)
            .update({"abonos": abonos}).then((value) => {
                  setSt(
                    () {
                      abonos.clear();
                      abono.clear();
                      nombre.clear();
                      responsable.clear();
                      isLoadingPago = false;
                    },
                  ),
                  Navigator.of(context).pop(),
                  success(
                    size,
                    context,
                    "Abono guardado correctamente!",
                    "El abono ha sido guardado de forma exitosa, revise el pagaré.",
                  )
                });
      }
    });
  }
}

updateAbonos(Size size, BuildContext context, StateSetter setSt, String usuario,
    String doc) async {
  FirebaseFirestore.instance
      .collection("ventas")
      .doc(doc)
      .update({"abonos": abonosModal}).then((value) => {
            setSt(
              () {
                abonosModal.clear();
                isLoadingPago = false;
              },
            ),
            Navigator.of(context).pop(),
            success(
              size,
              context,
              "Abonos guardados correctamente!",
              "Los abonos han sido guardados de forma exitosa, revise el pagaré.",
            )
          });
}
