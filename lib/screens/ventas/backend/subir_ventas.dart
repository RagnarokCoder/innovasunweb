// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/ventas/components/carrito.dart';
import 'package:innovasun/screens/ventas/components/modal_credito.dart';
import 'package:innovasun/screens/ventas/pdf/vale_salida.dart';
import 'package:innovasun/screens/ventas/pdf/venta.dart';
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
    if (cliente.text.isEmpty) {
      cliente.text = "Sin cliente";
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
        "comprador": cliente.text,
        "usuario": usuario,
        "isIva": isIva,
        "isPago": isPago
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
        "usuario": usuario,
        "isIva": isIva,
        "isPago": isPago
      };
    }
    generateVenta(setSt, !isCotizacion);

    if (isCotizacion == false) {
      generateValeSalida(setSt);
      for (var i in carrito.keys) {
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection("inventario")
            .doc(carrito[i]['id']);
        documentReference.get().then((doc) {
          Map<dynamic, dynamic> producto = doc.data() as Map;
          dynamic cantidad = producto['cantidad'];
          cantidad -= carrito[i]['cantidad'];
          FirebaseFirestore.instance
              .collection("inventario")
              .doc(doc.id)
              .update({"cantidad": cantidad});
        });
      }

      if (isPago == false) {
        Map<String, dynamic> caja = {};
        caja = {
          "cantidad": total,
          "concepto": "venta",
          "fecha": DateTime.now(),
          "isSum": true,
          "recibe": correoSelect,
          "usuario": usuario
        };
        FirebaseFirestore.instance.collection("gastos_caja").add(caja);
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
                    cliente.clear();
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
    } else {
      setSt(
        () {
          carrito.clear();
          subtotal = 0;
          correoSelect = "";
          cliente.clear();
          descuento = 0;
          isLoadingVentas = false;
        },
      );
      Navigator.of(context).pop();
      success(
        size,
        context,
        "Cotización generada correctamente!",
        "La cotización ha sido generada de forma exitosa, revise el ticket.",
      );
    }
  }
}
