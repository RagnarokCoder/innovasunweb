import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../../constants/alerts/success.dart';
import '../../../constants/color/colores.dart';
import '../../../constants/dialogs/dialog_options.dart';

eliminarProducto(Size size, BuildContext context, StateSetter setSt, String doc,
    String usuario) {
  dialogOptions(
      colorwhite, "¿Desea eliminar este producto?", LineIcons.info, context,
      () {
    Navigator.of(context).pop();
    FirebaseFirestore.instance
        .collection("inventario")
        .doc(doc)
        .delete()
        .then((value) => {
              success(
                size,
                context,
                "¡Producto eliminado!",
                "El producto ha sido eliminado correctamente de la nube.",
              ),
              Navigator.of(context).pop()
            });
  }, () {
    Navigator.of(context).pop();
  });
}
