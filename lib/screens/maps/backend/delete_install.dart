import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../../constants/alerts/success.dart';
import '../../../constants/color/colores.dart';
import '../../../constants/dialogs/dialog_options.dart';

eliminarInstall(Size size, BuildContext context, StateSetter setSt, String doc,
    String usuario) {
  dialogOptions(
      colorwhite, "¿Desea eliminar esta Instalación?", LineIcons.info, context,
      () {
    Navigator.of(context).pop();
    FirebaseFirestore.instance
        .collection("instalaciones")
        .doc(doc)
        .delete()
        .then((value) => {
              success(
                size,
                context,
                "¡Instalación eliminada!",
                "La Instalación ha sido eliminada correctamente de la nube.",
              ),
            });
  }, () {
    Navigator.of(context).pop();
  });
}
