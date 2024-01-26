import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../../constants/alerts/success.dart';
import '../../../constants/color/colores.dart';
import '../../../constants/dialogs/dialog_options.dart';

eliminarVenta(Size size, BuildContext context, StateSetter setSt, String doc,
    String usuario, Map<dynamic, dynamic> productos) {
  dialogOptions(
      colorwhite, "¿Desea eliminar esta Venta?", LineIcons.info, context, () {
    Navigator.of(context).pop();
    debugPrint(productos.toString());
    for (var i in productos.keys) {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("inventario")
          .doc(productos[i]['id']);
      documentReference.get().then((doc) {
        Map<dynamic, dynamic> producto = doc.data() as Map;
        dynamic cantidad = producto['cantidad'];
        cantidad += productos[i]['cantidad'];
        FirebaseFirestore.instance
            .collection("inventario")
            .doc(doc.id)
            .update({"cantidad": cantidad});
      });
    }

    FirebaseFirestore.instance
        .collection("ventas")
        .doc(doc)
        .delete()
        .then((value) => {
              success(
                size,
                context,
                "¡Venta eliminada!",
                "La venta ha sido eliminada correctamente de la nube.",
              ),
            });
  }, () {
    Navigator.of(context).pop();
  });
}
