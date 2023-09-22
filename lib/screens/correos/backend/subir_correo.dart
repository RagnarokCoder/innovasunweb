import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/correos/components/modal_correo.dart';

import '../../../constants/alerts/success.dart';
import '../../../constants/alerts/warning.dart';

Map<String, dynamic> createCorreo = {};

subirCorreo(Size size, BuildContext context, StateSetter setSt, String usuario,
    String doc) async {
  if (correo.text.isEmpty || nombre.text.isEmpty) {
    warning(
      size,
      context,
      "¡Campos Vacios!",
      "No debes dejar campos vacios, verifica que todos los campos contengan datos.",
    );
  } else {
    isLoadingCorreo = true;

    createCorreo = {
      "nombre": nombre.text,
      "correo": correo.text,
      "fecha": DateTime.now(),
      "usuario": usuario
    };

    if (doc != "") {
      FirebaseFirestore.instance
          .collection("correos")
          .doc(doc)
          .update(createCorreo)
          .then((value) => {
                setSt(
                  () {
                    nombre.clear();
                    correo.clear();
                    isLoadingCorreo = false;
                  },
                ),
                Navigator.of(context).pop(),
                success(
                  size,
                  context,
                  "Correo actualizado correctamente!",
                  "El correo ha sido guardado de forma exitosa.",
                )
              });
    } else {
      FirebaseFirestore.instance
          .collection("correos")
          .add(createCorreo)
          .then((value) => {
                setSt(
                  () {
                    nombre.clear();
                    correo.clear();
                    isLoadingCorreo = false;
                  },
                ),
                Navigator.of(context).pop(),
                success(
                  size,
                  context,
                  "Correo guardado correctamente!",
                  "El correo ha sido guardado de forma exitosa.",
                )
              });
    }
  }
}
