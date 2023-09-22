import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/ventas/components/carrito.dart';
import 'package:innovasun/screens/ventas/components/modal_credito.dart';
import 'package:innovasun/screens/ventas/ventas.dart';

import '../../../constants/alerts/success.dart';
import '../../../constants/alerts/warning.dart';

Map<String, dynamic> createVenta = {};
dynamic total = 0;

subirVenta(
  Size size,
  BuildContext context,
  StateSetter setSt,
  String usuario,
) async {
  if (carrito.isEmpty) {
    warning(
      size,
      context,
      "¡Carrito vacio!",
      "Debes tener por lo menos un producto en el carrito",
    );
  } else {
    isLoadingVentas = true;

    if (isIva == true) {
      total = subtotal * 1.16;
    } else {
      total = subtotal;
    }

    if (isContado == true) {
      createVenta = {
        "carrito": carrito,
        "subtotal": subtotal,
        "descuento": descuento,
        "total": total,
        "isContado": isContado,
        "fecha": DateTime.now(),
        "fechas": "",
        "uuid": uuid.v4(),
        "comprador": "",
        "usuario": usuario
      };
    } else {
      createVenta = {
        "carrito": carrito,
        "subtotal": subtotal,
        "descuento": descuento,
        "total": total,
        "isContado": isContado,
        "fecha": DateTime.now(),
        "vencimiento": vencimiento,
        "uuid": uuid.v4(),
        "comprador": correoSelect,
        "usuario": usuario
      };
    }

    FirebaseFirestore.instance
        .collection("ventas")
        .add(createVenta)
        .then((value) => {
              setSt(
                () {
                  carrito.clear();
                  subtotal = 0;
                  correoSelect = "";
                  descuento = 0;
                  isLoadingVentas = false;
                },
              ),
              Navigator.of(context).pop(),
              success(
                size,
                context,
                "Venta generada correctamente!",
                "La venta ha sido generada de forma exitosa, revise el ticket.",
              )
            });
  }
}
