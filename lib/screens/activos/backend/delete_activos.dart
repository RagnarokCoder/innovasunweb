import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../../constants/alerts/success.dart';
import '../../../constants/color/colores.dart';
import '../../../constants/dialogs/dialog_options.dart';

eliminarActivo(Size size, BuildContext context, StateSetter setSt, String doc,
    String usuario) {
  dialogOptions(
      colorwhite, "¿Desea eliminar este activo?", LineIcons.info, context, () {
    Navigator.of(context).pop();
    FirebaseFirestore.instance
        .collection("activos")
        .doc(doc)
        .delete()
        .then((value) => {
              success(
                size,
                context,
                "¡Activo eliminado!",
                "El activo ha sido eliminado correctamente de la nube.",
              ),
              Navigator.of(context).pop()
            });
  }, () {
    Navigator.of(context).pop();
  });
}
