import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/ventas/components/gaso_caja.dart';

import '../../../constants/alerts/success.dart';
import '../../../constants/alerts/warning.dart';
import '../ventas.dart';

Map<String, dynamic> createGasto = {};

subirGastoCaja(
  Size size,
  BuildContext context,
  StateSetter setSt,
  String usuario,
) async {
  if (recibe.text.isEmpty || cantidad.text.isEmpty || concepto.text.isEmpty) {
    warning(
      size,
      context,
      "¡Campos Vacios!",
      "No debes dejar campos vacios, verifica que todos los campos contengan datos.",
    );
  } else {
    isLoadingGasto = true;

    createGasto = {
      "recibe": recibe.text,
      "cantidad": double.parse(cantidad.text),
      "concepto": concepto.text,
      "fecha": DateTime.now(),
      "usuario": usuario
    };

    FirebaseFirestore.instance
        .collection("gastos_caja")
        .add(createGasto)
        .then((value) => {
              setSt(
                () {
                  recibe.clear();
                  cantidad.clear();
                  concepto.clear();
                  isLoadingGasto = false;
                },
              ),
              Navigator.of(context).pop(),
              success(
                size,
                context,
                "Gasto generado correctamente!",
                "El gasto ha sido generado de forma exitosa, revise el ticket.",
              )
            });
  }
}
