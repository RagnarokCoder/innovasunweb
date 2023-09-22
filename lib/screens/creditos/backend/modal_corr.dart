import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovasun/screens/creditos/components/modal_abonos.dart';
import 'package:innovasun/screens/creditos/components/modal_correo.dart';

import '../../../constants/responsive/responsive.dart';

modalCredito(
    Size size, BuildContext context, bool isEdit, String doc, String usuario) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          width: size.width,
          height: Responsive.isDesktop(context) ? size.height * 0.8 : 150,
          color: Colors.transparent,
          child: Padding(
              padding: Responsive.isDesktop(context)
                  ? const EdgeInsets.fromLTRB(350, 0, 350, 0)
                  : const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: ModalCredito(
                isEdit: isEdit,
                doc: doc,
                usuario: usuario,
              )),
        );
      });
}

modalAbonos(Size size, BuildContext context, bool isEdit, DocumentSnapshot doc,
    String usuario) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          width: size.width,
          height: Responsive.isDesktop(context) ? size.height * 0.8 : 150,
          color: Colors.transparent,
          child: Padding(
              padding: Responsive.isDesktop(context)
                  ? const EdgeInsets.fromLTRB(350, 0, 350, 0)
                  : const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: ModalAbonos(
                doc: doc,
                size: size,
                usuario: usuario,
              )),
        );
      });
}
