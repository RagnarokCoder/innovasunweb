import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/compras/components/card_compras.dart';
import 'package:innovasun/screens/compras/compras.dart';
import 'package:innovasun/screens/correos/correos.dart';

import '../../../constants/alerts/success.dart';
import '../../../constants/alerts/warning.dart';
import '../components/carrito.dart';
import '../components/modal_compras.dart';

Map<String, dynamic> createCompra = {};
dynamic total = 0;

subirCompra(Size size, BuildContext context, StateSetter setSt, String usuario,
    String doc) async {
  if (correoSelect == "") {
    warning(
      size,
      context,
      "¡Seleccione un correo!",
      "Asegurate de haber seleccionado un correo",
    );
  } else {
    isCompraLoading = true;

    if (isIva == true) {
      total = subtotal * 1.16;
    } else {
      total = subtotal;
    }

    createCompra = {
      "carrito": carritoCompras,
      "subtotal": subtotal,
      "descuento": descuento,
      "total": total,
      "isContado": isContado,
      "fecha": DateTime.now(),
      "uuid": uuid.v4(),
      "correo": correoSelect,
      "usuario": usuario,
      "isPendiente": true,
      "isIva": isIva
    };

    if (doc != "") {
      FirebaseFirestore.instance
          .collection("compras")
          .doc(doc)
          .update(createCompra)
          .then((value) => {
                setSt(
                  () {
                    nombre.clear();
                    descripcion.clear();
                    correoSelect = "";
                    isCompraLoading = false;
                  },
                ),
                Navigator.of(context).pop(),
                success(
                  size,
                  context,
                  "Compra actualizada correctamente!",
                  "La compra ha sido guardada de forma exitosa.",
                )
              });
    } else {
      FirebaseFirestore.instance
          .collection("compras")
          .add(createCompra)
          .then((value) => {
                setSt(
                  () {
                    nombre.clear();
                    descripcion.clear();
                    correoSelect = "";
                    isCompraLoading = false;
                    carritoCompras.clear();
                    subtotal = 0;
                    total = 0;
                    descuento = 0;
                  },
                ),
                Navigator.of(context).pop(),
                success(
                  size,
                  context,
                  "Compra guardada correctamente!",
                  "La compra ha sido guardada de forma exitosa.",
                )
              });
    }
  }
}

updateInventario(Size size, BuildContext context, StateSetter setSt,
    Map<dynamic, dynamic> materiales, String doc) {
  setSt(() {
    isLoadingUpdate = true;
  });
  for (var i in materiales.keys) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("inventario")
        .doc(materiales[i]['id']);
    documentReference.get().then((doc) {
      Map<dynamic, dynamic> producto = doc.data() as Map;
      dynamic cantidad = producto['cantidad'];
      cantidad += materiales[i]['cantidad'];
      FirebaseFirestore.instance
          .collection("inventario")
          .doc(doc.id)
          .update({"cantidad": cantidad});
    });
  }

  FirebaseFirestore.instance
      .collection("compras")
      .doc(doc)
      .update({"isPendiente": false}).then((value) => {
            success(size, context, "Inventario Actualizado.",
                "Los productos han sido cargados correctamente!"),
            setSt(() {
              isLoadingUpdate = false;
            })
          });
}
